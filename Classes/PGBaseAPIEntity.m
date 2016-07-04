//
//  PGBaseAPIManager.m
//  PGNetworking
//
//  Created by tolly on 16/4/5.
//  Copyright © 2016年 张正超. All rights reserved.
//

#import "PGBaseAPIEntity.h"
#import "JXCommonParamsGenerator.h"
#import "PGNetworking.h"
#import "JXCache.h"


@interface PGBaseAPIEntity ()

@property (nonatomic, strong, readwrite) id fetchedRawData;
@property (nonatomic, strong, readwrite) NSString *contentString;

@property (nonatomic, copy, readwrite) NSString *errorMessage;
@property (nonatomic, readwrite) PGAPIEntityResponseType errorType;
@property (nonatomic, strong) NSMutableArray *requestIdList;

@property (nonatomic, strong) JXCache *cache;


@end

@implementation PGBaseAPIEntity

- (JXCache *)cache {
    if (!_cache) {
        _cache = [JXCache cache];
    }
    return _cache;
}

- (NSMutableArray *)requestIdList {
    if (!_requestIdList) {
        _requestIdList = [NSMutableArray array];
    }
    return _requestIdList;
}

- (PGAPIEntityResponseType)responseType {
    return self.errorType;
}

- (BOOL)isReachable {
    BOOL isReachable = [PGNetworkingReachability isReachable];
    if (!isReachable) {
        self.errorType = PGAPIEntityResponseTypeNoNetWork;
    }
    return isReachable;
}

- (BOOL)isLoading {
   return [self.requestIdList count] > 0;
}

#pragma mark - Life
- (instancetype)init {
    if (self = [super init]) {
        _delegate = nil;
        _validator = nil;
        _paramSource = nil;
        
        _fetchedRawData = nil;
        _errorMessage = nil;
        _errorType = PGAPIEntityResponseTypeDefault;
        if ([self conformsToProtocol:@protocol(PGAPIEntity)]) {
            self.child = (NSObject <PGAPIEntity>*)self;
        }
    }
    return self;
}

- (void)dealloc {
    [self cancelAllRequests];
    self.requestIdList = nil;
}

#pragma mark - load data

- (NSInteger)loadData{
    NSDictionary *params = [self.paramSource paramsForApi:self];
    NSInteger requestId = [self loadDataWithParams:params];
    return requestId;

}

- (NSInteger)loadDataWithParams:(NSDictionary *)params
{
    NSInteger requestId = 0;
    NSDictionary *apiParams = [self reformParams:params];   //参数重装
    if ([self shouldCallAPIWithParams:apiParams]) {
        if ([self.validator api:self isCorrectWithParamsData:apiParams]) {
            
            // 先检查一下是否有缓存
            if ([self shouldCache] && [self hasCacheWithParams:apiParams]) {
                return 0;
            }
            
            
            // 实际的网络请求
            if ([self isReachable]) {
                switch (self.child.requestType)
                {
                    case PGAPIEntityRequestTypeGet:
                        {
                           NSUInteger REQUEST_ID = [[PGAPIEngine shareInstance] callGETWithParams:apiParams apiEntity:self success:^(PGAPIResponse *res) {
                               
                                [self successedOnCallingAPI:res];
                    
                            } fail:^(PGAPIResponse *res) {
                               
                                [self failedOnCallingAPI:res withErrorType:res.responseType];
                            }];
                            
                            [self.requestIdList addObject:@(REQUEST_ID)];
                        }
                        
                        break;
                    case PGAPIEntityRequestTypePost:
                        {
                            NSUInteger REQUEST_ID = [[PGAPIEngine shareInstance] callPOSTWithParams:apiParams apiEntity:self  success:^(PGAPIResponse *res) {
                            
                                [self successedOnCallingAPI:res];
                            
                            } fail:^(PGAPIResponse *res) {
                            
                                [self failedOnCallingAPI:res withErrorType:res.responseType];
                            }];
                        
                            [self.requestIdList addObject:@(REQUEST_ID)];
                        }

                        break;
                }
                
                NSMutableDictionary *params = [apiParams mutableCopy];
                params[kPGBaseAPIEntityRequestID] = @(requestId);
                [self afterCallingAPIWithParams:params];
                return requestId;
                
            } else {
                [self failedOnCallingAPI:nil withErrorType:PGAPIEntityResponseTypeNoNetWork];
                return requestId;
            }
        } else {
            [self failedOnCallingAPI:nil withErrorType:PGAPIEntityResponseTypeParamsError];
            return requestId;
        }
    }
    return requestId;
}

- (BOOL)hasCacheWithParams:(NSDictionary *)params {

    NSDictionary *result = [self.cache fetchCachedDataForkey:[self keyForcache]];
    
    if (result == nil) {
        return NO;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
       
       PGAPIResponse *response = [PGAPIResponse new];
        response.responseType = PGAPIEntityResponseTypeSuccess;
        response.content = [result copy];
        response.contentString = [result mj_JSONString];
        response.isCache = YES;
        
        
        APILog(response);
        [self successedOnCallingAPI:response];
        
    });
    return YES;
}

- (void)removeRequestIdWithRequestID:(NSInteger)requestId
{
    NSNumber *requestIDToRemove = nil;
    for (NSNumber *storedRequestId in self.requestIdList) {
        if ([storedRequestId integerValue] == requestId) {
            requestIDToRemove = storedRequestId;
        }
    }
    if (requestIDToRemove) {
        [self.requestIdList removeObject:requestIDToRemove];
    }
}


#pragma mark - api callbacks
- (void)apiCallBack:(PGAPIResponse *)response
{
    if (response.responseType == PGAPIEntityResponseTypeSuccess) {
        [self successedOnCallingAPI:response];
    }else{
        [self failedOnCallingAPI:response withErrorType:PGAPIEntityResponseTypeTimeout];
    }
}

- (void)successedOnCallingAPI:(PGAPIResponse *)response
{
    
    self.fetchedRawData = [response.responseData copy];
    self.contentString = [response.contentString copy];
    
//    if (response.contentString) {
//        self.fetchedRawData = [[response.contentString mj_JSONObject] copy];
//    } else {
//        self.fetchedRawData = [[response.contentString mj_JSONObject] copy];
//    }
    [self removeRequestIdWithRequestID:response.requestId];
    if ([self.validator api:self isCorrectWithCallBackData:response.content]) {
        
        if (!response.contentString || response.contentString <= 0) {
             [self failedOnCallingAPI:response withErrorType:PGAPIEntityResponseTypeNoContent];
             return;
        }
        
        if ([self shouldCache] && !response.isCache) {
            [self.cache saveCacheWithData:[response.contentString mj_JSONObject] forKey:[self keyForcache]];
        }
        
        [self beforePerformSuccessWithResponse:response];
        [self.delegate doSuccess:self];
        [self afterPerformSuccessWithResponse:response];
    } else {
        [self failedOnCallingAPI:response withErrorType:PGAPIEntityResponseTypeNoContent];
    }
}

- (void)failedOnCallingAPI:(PGAPIResponse *)response withErrorType:(PGAPIEntityResponseType)errorType
{
    self.errorType = errorType;
    [self removeRequestIdWithRequestID:response.requestId];
    [self beforePerformFailWithResponse:response];
    [self.delegate doFailed:self];
    [self afterPerformFailWithResponse:response];
}


#pragma mark - method for interceptor

- (void)beforePerformSuccessWithResponse:(PGAPIResponse *)response
{
    self.errorType = PGAPIEntityResponseTypeSuccess;
    if (self != self.interceptor && [self.interceptor respondsToSelector:@selector(api:beforePerformSuccessWithResponse:)]) {
        [self.interceptor api:self beforePerformSuccessWithResponse:response];
    }
}

- (void)afterPerformSuccessWithResponse:(PGAPIResponse *)response
{
    if (self != self.interceptor && [self.interceptor respondsToSelector:@selector(api:afterPerformSuccessWithResponse:)]) {
        [self.interceptor api:self afterPerformSuccessWithResponse:response];
    }
}

- (void)beforePerformFailWithResponse:(PGAPIResponse *)response
{
    if (self != self.interceptor && [self.interceptor respondsToSelector:@selector(api:beforePerformFailWithResponse:)]) {
        [self.interceptor api:self beforePerformFailWithResponse:response];
    }
}

- (void)afterPerformFailWithResponse:(PGAPIResponse *)response
{
    if (self != self.interceptor && [self.interceptor respondsToSelector:@selector(api:afterPerformFailWithResponse:)]) {
        [self.interceptor api:self afterPerformFailWithResponse:response];
    }
}

//只有返回YES才会继续调用API
- (BOOL)shouldCallAPIWithParams:(NSDictionary *)params
{
    if (self != self.interceptor && [self.interceptor respondsToSelector:@selector(api:shouldCallAPIWithParams:)]) {
        return [self.interceptor api:self shouldCallAPIWithParams:params];
    } else {
        return YES;
    }
}

- (void)afterCallingAPIWithParams:(NSDictionary *)params
{
    if (self != self.interceptor && [self.interceptor respondsToSelector:@selector(api:afterCallingAPIWithParams:)]) {
        [self.interceptor api:self afterCallingAPIWithParams:params];
    }
}


#pragma mark - method for child
- (void)cleanData
{
    IMP childIMP = [self.child methodForSelector:@selector(cleanData)];
    IMP selfIMP = [self methodForSelector:@selector(cleanData)];
    
    if (childIMP == selfIMP) {
        self.fetchedRawData = nil;
        self.errorMessage = nil;
        self.errorType = PGAPIEntityResponseTypeDefault;
    } else {
        if ([self.child respondsToSelector:@selector(cleanData)]) {
            [self.child cleanData];
        }
    }
}


- (NSDictionary *)reformParams:(NSDictionary *)params
{
    IMP childIMP = [self.child methodForSelector:@selector(reformParams:)];
    IMP selfIMP = [self methodForSelector:@selector(reformParams:)];
    
    if (childIMP == selfIMP) {
        return params;
    } else {
        // 如果child是继承得来的，那么这里就不会跑到，会直接跑子类中的IMP。
        // 如果child是另一个对象，就会跑到这里
        NSDictionary *result = nil;
        result = [self.child reformParams:params];
        if (result) {
            return result;
        } else {
            return params;
        }
    }
}

- (BOOL)shouldCache
{
    return kPGNetworkingShouldCache;
}

- (PGNetworkingEncryptionType)encryptionType {
    return kPGNetworkingEncrypType;
}

- (BOOL)shouldEncrypt{
    return [PGNetworkingConfig shouldEncryption];
}

- (BOOL)logEnable {
    return YES;
}


#pragma mark -  Public
- (void)cancelAllRequests
{
    
    [[PGAPIEngine shareInstance] cancelRequestWithRequestIDs:self.requestIdList];
    
    [self.requestIdList removeAllObjects];
}

- (void)cancelRequestWithRequestId:(NSInteger)requestID
{
    [[PGAPIEngine shareInstance] cancelRequestWithRequestID:requestID];
    [self removeRequestIdWithRequestID:requestID];
}

- (id)fetchDataWithReformer:(id<PGAPIResponseDataReformer>)reformer
{
    id resultData = nil;
    if ([reformer respondsToSelector:@selector(api:reformData:)]) {
        resultData = [reformer api:self reformData:[self fetchData]];
    } else {
        resultData = [self fetchData];
    }
    return resultData;
}

- (id)fetchPureData{
    if ([self.fetchedRawData isKindOfClass:[NSData class]]) {
        return [self.fetchedRawData copy];
    }
    return nil;
}

- (NSDictionary *)fetchData{
    return [[self.contentString mj_JSONObject] copy];
}




#pragma mark - _Private

- (NSString *)keyForcache{
    NSString *baseUrl = [PGNetworkingConfig  baseUrlWithServiceType:self.child.serviceType];
    
    NSMutableDictionary *mDic = [[JXCommonParamsGenerator commonParamsDictionary] mutableCopy];
    [mDic addEntriesFromDictionary:[self.paramSource paramsForApi:self]];
    
    NSString *paramsString = [mDic mj_JSONString];
    
    return [NSString stringWithFormat:@"%@%@%@",baseUrl,self.child.apiName,[paramsString urlEncoding]];
}


@end
