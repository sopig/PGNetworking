//
//  PGAPIEngine.m
//  PGNetworking
//
//  Created by tolly on 16/4/6.
//  Copyright © 2016年 张正超. All rights reserved.
//

#import "PGAPIEngine.h"
#import "JXCommonParamsGenerator.h"
#import "NSString+urlEncoding.h"
#import "JXEncryption.h"

@interface PGAPIEngine ()

@property (nonatomic, strong) NSNumber *recordedRequestId;

@property (nonatomic, strong) NSMutableDictionary *taskCenter;


@property (nonatomic, strong) NSURLSessionConfiguration *config;

@property (nonatomic, strong) AFHTTPSessionManager *manager;

@end

@implementation PGAPIEngine

+ (instancetype)shareInstance {
    static PGAPIEngine *__instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __instance = [PGAPIEngine new];
    });
    return __instance;
}


- (NSMutableDictionary *)taskCenter {
    if (!_taskCenter) {
        _taskCenter = [NSMutableDictionary dictionary];
    }
    return _taskCenter;
}


- (AFHTTPSessionManager *)prepareManager{
    if (!_config) {
        _config = [NSURLSessionConfiguration defaultSessionConfiguration];
        _config.timeoutIntervalForRequest = kPGNetworkingTimeoutSeconds;
        _config.timeoutIntervalForResource = kPGNetworkingTimeoutSeconds;
        _config.networkServiceType = NSURLNetworkServiceTypeDefault;
        _config.discretionary = YES;
    }
    
    if (!_manager) {
        _manager =[[AFHTTPSessionManager alloc] initWithSessionConfiguration:_config];
        AFHTTPRequestSerializer *reqSerializer = [AFHTTPRequestSerializer serializer];
        [reqSerializer setValue:@"text/html; q=1.0, text/*; q=0.8, image/gif; q=0.6, image/jpeg; q=0.6, image/*; q=0.5, */*; q=0.1" forHTTPHeaderField:@"Accept"];
        
        AFHTTPResponseSerializer *resSerializer = [AFHTTPResponseSerializer serializer];
        resSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/x-www-form-urlencoded", @"text/html",@"text/plain",@"text/css",@"text/javascript",@"application/json" ,nil];
        
        _manager.requestSerializer = reqSerializer;
        _manager.responseSerializer = resSerializer;
    }
    
    
    return _manager;
}

- (NSInteger)callGETWithParams:(NSDictionary *)params apiEntity:(PGBaseAPIEntity *)api success:(void (^)(PGAPIResponse *res))success fail:(void (^)(PGAPIResponse *res))fail {
    
    NSString *baseUrl = [PGNetworkingConfig  baseUrlWithServiceType:api.child.serviceType];
    NSString *url = [NSString stringWithFormat:@"%@%@",baseUrl,api.child.apiName];
    
    //
    PGAPIResponse *apiResponse = [PGAPIResponse new];
    NSMutableDictionary *mDic = [[JXCommonParamsGenerator commonParamsDictionary] mutableCopy];
    [mDic addEntriesFromDictionary:params];
    apiResponse.requestParams = [mDic copy];
    apiResponse.requestId = 0;
    
    NSDictionary *allParams = nil;
    BOOL shouldEncry = [api shouldEncrypt];
    
    if (shouldEncry) {
        allParams = [self EncrptyParameter:mDic];
        
    } else {
        allParams = [mDic copy];
    }
    
    
    if (!url || url.length <= 0) {
        apiResponse.responseType = PGAPIEntityResponseTypeParamsError;
        fail(apiResponse);
        return 0;
    }
    NSString *requestId = [NSString stringWithFormat:@"%@",[self generateRequestId]];
    
    NSURLSessionDataTask *task = [[self prepareManager] GET:url parameters:allParams progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        task.taskDescription = requestId;
        apiResponse.task = task;
        apiResponse.request = task.currentRequest;
        apiResponse.response = task.response;
        
        NSError *error = nil;
        if (!responseObject) return ;
        id response = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&error];
        
        //
        if (error) {
            apiResponse.responseType = PGAPIEntityResponseTypeNoContent;
            apiResponse.error = error;
            fail(apiResponse);
            return ;
        }
        
        if (response && ![response isKindOfClass:NSDictionary.class]) {
            apiResponse.responseType = PGAPIEntityResponseTypeNoContent;
            fail(apiResponse);
            return ;
        }
        
        NSDictionary *resDic = nil;
        if (shouldEncry) {
            resDic = [[self decrptyParameterForParamDic:(NSDictionary *)response] copy];
        } else {
            resDic = [response copy];
        }
        
        
        if(!resDic) {
            apiResponse.requestId = apiResponse.task.taskDescription.integerValue;
            apiResponse.responseData = nil;
            apiResponse.content = nil;
            apiResponse.task = task;
            apiResponse.error = task.error;
            apiResponse.contentString = nil;
            apiResponse.responseType = PGAPIEntityResponseTypeNoContent;
            APILog(apiResponse);
            fail(apiResponse);
            
            return;
        }
        
        
        
        apiResponse.requestId = apiResponse.task.taskDescription.integerValue;
        apiResponse.responseData = responseObject;
        apiResponse.content = responseObject;
        apiResponse.contentString = [resDic mj_JSONString];
        apiResponse.responseType = PGAPIEntityResponseTypeSuccess;
        
        APILog(apiResponse);
        success(apiResponse);
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        task.taskDescription = requestId;
        apiResponse.request = task.currentRequest;
        if (-1001 == error.code ) {
            apiResponse.responseType = PGAPIEntityResponseTypeTimeout;
        } else {
            apiResponse.responseType = PGAPIEntityResponseTypeNoNetWork;
        }
        
        apiResponse.requestId = apiResponse.task.taskDescription.integerValue;
        apiResponse.responseData = nil;
        apiResponse.content = nil;
        apiResponse.task = task;
        apiResponse.error = task.error;
        apiResponse.contentString = nil;
        
        APILog(apiResponse);
        
        fail(apiResponse);
    }];
    
    task.taskDescription = requestId;
    
    [self.taskCenter setObject:task forKey:requestId];
    
    return task.taskDescription.integerValue;

    
}

- (NSInteger)callPOSTWithParams:(NSDictionary *)params apiEntity:(PGBaseAPIEntity *)api success:(void (^)(PGAPIResponse *res))success fail:(void (^)(PGAPIResponse *res))fail{
    NSString *baseUrl = [PGNetworkingConfig  baseUrlWithServiceType:api.child.serviceType];
    NSString *url = [NSString stringWithFormat:@"%@%@",baseUrl,api.child.apiName];
    
    
    PGAPIResponse *apiResponse = [PGAPIResponse new];
    NSMutableDictionary *mDic = [[JXCommonParamsGenerator commonParamsDictionary] mutableCopy];
    [mDic addEntriesFromDictionary:params];
    apiResponse.requestParams = [mDic copy];
    apiResponse.requestId = 0;
    
    NSDictionary *allParams = nil;
    BOOL shouldEncry = [api shouldEncrypt];
    
    if (shouldEncry) {
        allParams = [self EncrptyParameter:mDic];
        
    } else {
        allParams = [mDic copy];
    }
    
    if (!url || url.length <= 0) {
        apiResponse.responseType = PGAPIEntityResponseTypeParamsError;
        fail(apiResponse);
        return 0;
    }
    NSString *requestId = [NSString stringWithFormat:@"%@",[self generateRequestId]];
    
    
    NSURLSessionDataTask *task = [[self prepareManager] POST:url parameters:allParams progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        task.taskDescription = requestId;
        apiResponse.task = task;
        apiResponse.request = task.currentRequest;
        apiResponse.response = task.response;
        NSError *error = nil;
        id response = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&error];
        
        //
        if (error) {
            apiResponse.responseType = PGAPIEntityResponseTypeNoContent;
            apiResponse.error = error;
            fail(apiResponse);
            return ;
        }
        
        if (response && ![response isKindOfClass:NSDictionary.class]) {
            apiResponse.responseType = PGAPIEntityResponseTypeNoContent;
            fail(apiResponse);
            return;
        }
        
        NSDictionary *resDic = nil;
        if (shouldEncry) {
            resDic = [[self decrptyParameterForParamDic:(NSDictionary *)response] copy];
        } else {
            resDic = [response copy];
        }
        
        if(!resDic) {
            apiResponse.requestId = apiResponse.task.taskDescription.integerValue;
            apiResponse.responseData = nil;
            apiResponse.content = nil;
            apiResponse.task = task;
            apiResponse.error = task.error;
            apiResponse.contentString = nil;
            apiResponse.responseType = PGAPIEntityResponseTypeNoContent;
            APILog(apiResponse);
            fail(apiResponse);
            
            return;
        }
        
        
        apiResponse.requestId = apiResponse.task.taskDescription.integerValue;
        apiResponse.responseData = responseObject;
        apiResponse.content = responseObject;
        apiResponse.contentString = [resDic mj_JSONString];
        apiResponse.responseType = PGAPIEntityResponseTypeSuccess;
        
        APILog(apiResponse);
        success(apiResponse);
        
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        task.taskDescription = requestId;
        apiResponse.request = task.currentRequest;
        if (-1001 == error.code ) {
            apiResponse.responseType = PGAPIEntityResponseTypeTimeout;
        } else {
            apiResponse.responseType = PGAPIEntityResponseTypeNoNetWork;
        }
        
        apiResponse.requestId = apiResponse.task.taskDescription.integerValue;
        apiResponse.responseData = nil;
        apiResponse.content = nil;
        apiResponse.task = task;
        apiResponse.error = task.error;
        apiResponse.contentString = nil;
        
        APILog(apiResponse);
        
        fail(apiResponse);
        
    }];
    
    [self.taskCenter setObject:task forKey:requestId];
    
    return task.taskDescription.integerValue;


}


#if 0

- (NSInteger)callGETWithParams:(NSDictionary *)params serviceType:(PGNetworkingServiceType)serviceType apiName:(NSString *)apiName success:(void (^)(PGAPIResponse *res))success fail:(void (^)(PGAPIResponse *res))fail{
    
    
    NSString *baseUrl = [PGNetworkingConfig  baseUrlWithServiceType:serviceType];
    NSString *url = [NSString stringWithFormat:@"%@%@",baseUrl,apiName];
    
    //
    PGAPIResponse *apiResponse = [PGAPIResponse new];
    NSMutableDictionary *mDic = [[JXCommonParamsGenerator commonParamsDictionary] mutableCopy];
    [mDic addEntriesFromDictionary:params];
    apiResponse.requestParams = [mDic copy];
    apiResponse.requestId = 0;
    
    NSDictionary *allParams = nil;
    BOOL shouldEncry = [PGNetworkingConfig shouldEncryption];
    
    if (shouldEncry) {
        allParams = [self EncrptyParameter:mDic];
        
    } else {
        allParams = [mDic copy];
    }
    

    if (!url || url.length <= 0) {
        apiResponse.responseType = PGAPIEntityResponseTypeParamsError;
        fail(apiResponse);
        return 0;
    }
    NSString *requestId = [NSString stringWithFormat:@"%@",[self generateRequestId]];
    
    NSURLSessionDataTask *task = [[self prepareManager] GET:url parameters:allParams progress:^(NSProgress * _Nonnull downloadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        task.taskDescription = requestId;
        apiResponse.task = task;
        apiResponse.request = task.currentRequest;
        apiResponse.response = task.response;
       
        NSError *error = nil;
        if (!responseObject) return ;
        id response = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&error];
        
        //
        if (error) {
            apiResponse.responseType = PGAPIEntityResponseTypeNoContent;
            apiResponse.error = error;
            fail(apiResponse);
            return ;
        }
        
        if (response && ![response isKindOfClass:NSDictionary.class]) {
            apiResponse.responseType = PGAPIEntityResponseTypeNoContent;
            fail(apiResponse);
            return ;
        }
        
        NSDictionary *resDic = nil;
        if ([PGNetworkingConfig shouldEncryption]) {
            resDic = [[self decrptyParameterForParamDic:(NSDictionary *)response] copy];
        } else {
            resDic = [response copy];
        }
        
        
        if(!resDic) {
            apiResponse.requestId = apiResponse.task.taskDescription.integerValue;
            apiResponse.responseData = nil;
            apiResponse.content = nil;
            apiResponse.task = task;
            apiResponse.error = task.error;
            apiResponse.contentString = nil;
            apiResponse.responseType = PGAPIEntityResponseTypeNoContent;
            APILog(apiResponse);
            fail(apiResponse);
            
            return;
        }

        
        
        apiResponse.requestId = apiResponse.task.taskDescription.integerValue;
        apiResponse.responseData = responseObject;
        apiResponse.content = responseObject;
        apiResponse.contentString = [resDic mj_JSONString];
        apiResponse.responseType = PGAPIEntityResponseTypeSuccess;
        
        APILog(apiResponse);
        success(apiResponse);
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        task.taskDescription = requestId;
        apiResponse.request = task.currentRequest;
        if (-1001 == error.code ) {
           apiResponse.responseType = PGAPIEntityResponseTypeTimeout;
        } else {
           apiResponse.responseType = PGAPIEntityResponseTypeNoNetWork;
        }
        
        apiResponse.requestId = apiResponse.task.taskDescription.integerValue;
        apiResponse.responseData = nil;
        apiResponse.content = nil;
        apiResponse.task = task;
        apiResponse.error = task.error;
        apiResponse.contentString = nil;
        
        APILog(apiResponse);
        
        fail(apiResponse);
    }];
    
    task.taskDescription = requestId;
    
    [self.taskCenter setObject:task forKey:requestId];
    
    return task.taskDescription.integerValue;
}

- (NSInteger)callPOSTWithParams:(NSDictionary *)params serviceType:(PGNetworkingServiceType)serviceType apiName:(NSString *)apiName success:(void (^)(PGAPIResponse *res))success fail:(void (^)(PGAPIResponse *res))fail {
    
    NSString *baseUrl = [PGNetworkingConfig  baseUrlWithServiceType:serviceType];
    NSString *url = [NSString stringWithFormat:@"%@%@",baseUrl,apiName];
    
    
    
    PGAPIResponse *apiResponse = [PGAPIResponse new];
    NSMutableDictionary *mDic = [[JXCommonParamsGenerator commonParamsDictionary] mutableCopy];
    [mDic addEntriesFromDictionary:params];
    apiResponse.requestParams = [mDic copy];
    apiResponse.requestId = 0;
    
    NSDictionary *allParams = nil;
    BOOL shouldEncry = [PGNetworkingConfig shouldEncryption];
    
    if (shouldEncry) {
        allParams = [self EncrptyParameter:mDic];
       
    } else {
        allParams = [mDic copy];
    }

    if (!url || url.length <= 0) {
        apiResponse.responseType = PGAPIEntityResponseTypeParamsError;
        fail(apiResponse);
        return 0;
    }
    NSString *requestId = [NSString stringWithFormat:@"%@",[self generateRequestId]];
    
    
     NSURLSessionDataTask *task = [[self prepareManager] POST:url parameters:allParams progress:^(NSProgress * _Nonnull uploadProgress) {
    
     } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         
         task.taskDescription = requestId;
         apiResponse.task = task;
         apiResponse.request = task.currentRequest;
         apiResponse.response = task.response;
         NSError *error = nil;
         id response = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&error];
         
         //
         if (error) {
             apiResponse.responseType = PGAPIEntityResponseTypeNoContent;
             apiResponse.error = error;
             fail(apiResponse);
             return ;
         }
         
         if (response && ![response isKindOfClass:NSDictionary.class]) {
             apiResponse.responseType = PGAPIEntityResponseTypeNoContent;
             fail(apiResponse);
             return;
         }
         
         NSDictionary *resDic = nil;
         if ([PGNetworkingConfig shouldEncryption]) {
             resDic = [[self decrptyParameterForParamDic:(NSDictionary *)response] copy];
         } else {
             resDic = [response copy];
         }
         
         if(!resDic) {
             apiResponse.requestId = apiResponse.task.taskDescription.integerValue;
             apiResponse.responseData = nil;
             apiResponse.content = nil;
             apiResponse.task = task;
             apiResponse.error = task.error;
             apiResponse.contentString = nil;
             apiResponse.responseType = PGAPIEntityResponseTypeNoContent;
             APILog(apiResponse);
             fail(apiResponse);
             
             return;
         }

         
         apiResponse.requestId = apiResponse.task.taskDescription.integerValue;
         apiResponse.responseData = responseObject;
         apiResponse.content = responseObject;
         apiResponse.contentString = [resDic mj_JSONString];
         apiResponse.responseType = PGAPIEntityResponseTypeSuccess;
         
         APILog(apiResponse);
         success(apiResponse);

         
         
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         task.taskDescription = requestId;
         apiResponse.request = task.currentRequest;
         if (-1001 == error.code ) {
             apiResponse.responseType = PGAPIEntityResponseTypeTimeout;
         } else {
             apiResponse.responseType = PGAPIEntityResponseTypeNoNetWork;
         }
         
         apiResponse.requestId = apiResponse.task.taskDescription.integerValue;
         apiResponse.responseData = nil;
         apiResponse.content = nil;
         apiResponse.task = task;
         apiResponse.error = task.error;
         apiResponse.contentString = nil;
         
         APILog(apiResponse);
         
         fail(apiResponse);

     }];
    
    [self.taskCenter setObject:task forKey:requestId];
    
    return task.taskDescription.integerValue;

}
#endif

- (void)cancelRequestWithRequestID:(NSInteger)requestID {
    NSURLSessionDataTask *task = self.taskCenter[[NSString stringWithFormat:@"%ld",(long)requestID]];
    [task cancel];
    [self.taskCenter removeObjectForKey:[NSString stringWithFormat:@"%ld",(long)requestID]];
}

- (void)cancelRequestWithRequestIDs:(NSArray *)requestIDs {
    [requestIDs enumerateObjectsUsingBlock:^(NSNumber *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self cancelRequestWithRequestID:obj.integerValue];
    }];
}


#pragma mark - _private

- (NSString *)queryStringFromParams:(NSDictionary *)paramDic {
    NSMutableArray *params = [[NSMutableArray alloc] initWithCapacity:paramDic.count];
    [paramDic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        
        if (obj == nil || obj == [NSNull null]) {
            [params addObject:[NSString stringWithFormat:@"%@=", key]];
        }
        else {
            if ([obj isKindOfClass:[NSString class]]) {
                NSString *value = (NSString *) obj;
                value = [value trimLeftAndRight];
                value = [value urlEncoding];
                [params addObject:[NSString stringWithFormat:@"%@=%@", key, value]];
            }
            else {
                [params addObject:[NSString stringWithFormat:@"%@=%@", key, obj]];
            }
        }
    }];
    
    return [params componentsJoinedByString:@"&"];
}


//数据返回解密
- (NSDictionary *)decrptyParameterForParamDic:(NSDictionary *)responseDic {
    
    //容错处理
    if ([responseDic objectForKey:DATAKEY] && [responseDic objectForKey:ENCRPTYKEY]) {
        
        // key存在
        if ((![[responseDic objectForKey:DATAKEY] isEqual:[NSNull null]]) && (![[responseDic objectForKey:ENCRPTYKEY] isEqual:[NSNull null]])) {
            //k1 k2不为NULL
            //加密的des密文
            NSString *desEncString = [responseDic objectForKey:ENCRPTYKEY];
            
            //RSA解密获取3des明文密钥(base64编码)
            NSString *desString = [JXRSA decryptToStringWithCipherString:desEncString];
            
            //加密的数据密文
            NSString *encDataString = [responseDic objectForKey:DATAKEY];
            
            //用3des密钥解密加密的数据
            NSString *desDataString = [JXDES tripleDES:encDataString encryptOrDecrypt:kCCDecrypt DESBase64Key:desString];
            
            NSDictionary *tmpDict = [desDataString mj_JSONObject];
            
            return tmpDict;
            
        } else {
            return nil;
        }
    }
    return nil;
}



- (NSDictionary *)EncrptyParameter:(NSDictionary *)paramsDic{
    NSString *parameString = [self queryStringFromParams:paramsDic];
    
    //3des密钥(base64编码后)
    NSString *desKey = [JXUUID base64DesKeyString];
    
    //用3des密钥加密参数得到加密后数据
    NSString *encrParameString = [JXDES tripleDES:parameString encryptOrDecrypt:kCCEncrypt DESBase64Key:desKey];
    
    //用RSA加密3des密钥
    NSString *encrypt3Des = [JXRSA encryptToStringWithCipherString:desKey];
    
    //拼接参数
    
    if (!encrParameString  || !encrypt3Des) {
        return nil;
    }
    
    NSDictionary *paramDict = @{
                                DATAKEY:encrParameString,
                                ENCRPTYKEY:encrypt3Des,
                                HTTPTYPE:HTTPDEVICE
                                };
    return [paramDict copy];
}


- (NSString *)jsonStringWithObject:(id)jsonObject{
    // 将字典或者数组转化为JSON串
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonObject
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                 encoding:NSUTF8StringEncoding];
    
    if ([jsonString length] > 0 && error == nil){
        return jsonString;
    }else{
        return nil;
    }
}



- (NSNumber *)generateRequestId
{
    if (_recordedRequestId == nil) {
        _recordedRequestId = @(1);
    } else {
        if ([_recordedRequestId integerValue] == NSIntegerMax) {
            _recordedRequestId = @(1);
        } else {
            _recordedRequestId = @([_recordedRequestId integerValue] + 1);
        }
    }
    return _recordedRequestId;
}



@end



