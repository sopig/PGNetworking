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


- (AFHTTPSessionManager *)prepareManager{
    
    NSURLSessionConfiguration * config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.timeoutIntervalForRequest = kPGNetworkingTimeoutSeconds;
    config.timeoutIntervalForResource = kPGNetworkingTimeoutSeconds;
    config.networkServiceType = NSURLNetworkServiceTypeDefault;
    config.discretionary = YES;
    
    
    AFHTTPSessionManager *manager =[[AFHTTPSessionManager alloc] initWithSessionConfiguration:config];
    AFHTTPRequestSerializer *reqSerializer = [AFHTTPRequestSerializer serializer];
    [reqSerializer setValue:@"text/html; q=1.0, text/*; q=0.8, image/gif; q=0.6, image/jpeg; q=0.6, image/*; q=0.5, */*; q=0.1" forHTTPHeaderField:@"Accept"];
    
    AFHTTPResponseSerializer *resSerializer = [AFHTTPResponseSerializer serializer];
    resSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/x-www-form-urlencoded", @"text/html",@"text/plain",@"text/css",@"text/javascript",@"application/json" ,nil];
    
    manager.requestSerializer = reqSerializer;
    manager.responseSerializer = resSerializer;
    
    return manager;
}


- (NSInteger)callGETWithParams:(NSDictionary *)params serviceType:(PGNetworkingServiceType)serviceType apiName:(NSString *)apiName success:(void (^)(PGAPIResponse *res))success fail:(void (^)(PGAPIResponse *res))fail{
    
    NSString *baseUrl = [PGNetworkingConfig  baseUrlWithServiceType:serviceType];

    NSString *url = [self getUrl:baseUrl params:params];
    
    
    [[self prepareManager] GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    
    
    return 0;
}

- (NSInteger)callPOSTWithParams:(NSDictionary *)params serviceType:(PGNetworkingServiceType)serviceType apiName:(NSString *)apiName success:(void (^)(PGAPIResponse *res))success fail:(void (^)(PGAPIResponse *res))fail {
    return 0;
}






#pragma mark - _private

- (NSString *)getUrl:(NSString *)url params:(NSDictionary *)params {
    
    
    NSDictionary *commonParams = [JXCommonParamsGenerator commonParamsDictionary];
    NSAssert(!commonParams, @"commonParams not ready");
    NSAssert(commonParams.count <= 0, @"commonParams not ready");
    
    NSMutableDictionary *allParams = [commonParams mutableCopy];
    if (params.count > 0) {
        [allParams addEntriesFromDictionary:params];
    }
    
    ///////////////////////////////////////////////
    NSLog(@"====================");
    NSLog(@"%@?%@",url,[self queryStringFromParams:allParams]);
    NSLog(@"====================");
    ///////////////////////////////////////////////
    NSMutableString *paramStr = nil;
    
    
    BOOL shouldEncry = [PGNetworkingConfig shouldEncryption];
    
    if (shouldEncry) {
        paramStr = [NSMutableString stringWithString:[self getEncrptyParameterStringForParamDic:allParams]];
    } else {
        paramStr = [NSMutableString stringWithString:[self queryStringFromParams:allParams]];
    }
    
    return [NSString stringWithFormat:@"%@?%@",url,paramStr];
}


- (NSString *)getEncrptyParameterStringForParamDic:(NSDictionary *)paramDic {
    
    NSString *parameString = [self queryStringFromParams:paramDic];
    
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
    
    NSString *parameStr = [self queryStringFromParams:paramDict];
    
    return parameStr;
}


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




@end



