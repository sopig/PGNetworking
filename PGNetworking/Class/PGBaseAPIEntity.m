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
    NSDictionary *apiParams = [self reformParams:params];
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
                        
                        break;
                    case PGAPIEntityRequestTypePost:
                        
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
    NSString *serviceIdentifier = self.child.serviceType;
    NSString *methodName = self.child.methodName;
    NSData *result = [self.cache fetchCachedDataWithServiceIdentifier:serviceIdentifier methodName:methodName requestParams:params];
    
    if (result == nil) {
        return NO;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
//        PGAPIResponse *response = [PGAPIResponse new];
        
//        AIFURLResponse *response = [[AIFURLResponse alloc] initWithData:result];
//        response.requestParams = params;
//        [AIFLogger logDebugInfoWithCachedResponse:response methodName:methodName serviceIdentifier:[[AIFServiceFactory sharedInstance] serviceWithIdentifier:serviceIdentifier]];
//        [self successedOnCallingAPI:response];
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
    if (response.content) {
        self.fetchedRawData = [response.content copy];
    } else {
        self.fetchedRawData = [response.responseData copy];
    }
    [self removeRequestIdWithRequestID:response.requestId];
    if ([self.validator api:self isCorrectWithCallBackData:response.content]) {
        
        if ([self shouldCache] && !response.isCache) {
            [self.cache saveCacheWithData:response.responseData serviceIdentifier:self.child.serviceType methodName:self.child.methodName requestParams:response.requestParams];
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

/*
 拦截器的功能可以由子类通过继承实现，也可以由其它对象实现,两种做法可以共存
 当两种情况共存的时候，子类重载的方法一定要调用一下super
 然后它们的调用顺序是BaseManager会先调用子类重载的实现，再调用外部interceptor的实现
 
 notes:
 正常情况下，拦截器是通过代理的方式实现的，因此可以不需要以下这些代码
 但是为了将来拓展方便，如果在调用拦截器之前manager又希望自己能够先做一些事情，所以这些方法还是需要能够被继承重载的
 所有重载的方法，都要调用一下super,这样才能保证外部interceptor能够被调到
 这就是decorate pattern
 */
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

//如果需要在调用API之前额外添加一些参数，比如pageNumber和pageSize之类的就在这里添加
//子类中覆盖这个函数的时候就不需要调用[super reformParams:params]了
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


#pragma mark -  Public
- (void)cancelAllRequests
{
//    [[AIFApiProxy sharedInstance] cancelRequestWithRequestIDList:self.requestIdList];
    [self.requestIdList removeAllObjects];
}

- (void)cancelRequestWithRequestId:(NSInteger)requestID
{
    [self removeRequestIdWithRequestID:requestID];
//    [[AIFApiProxy sharedInstance] cancelRequestWithRequestID:@(requestID)];
}

- (id)fetchDataWithReformer:(id<PGAPIResponseDataReformer>)reformer
{
    id resultData = nil;
    if ([reformer respondsToSelector:@selector(api:reformData:)]) {
        resultData = [reformer api:self reformData:self.fetchedRawData];
    } else {
        resultData = [self.fetchedRawData mutableCopy];
    }
    return resultData;
}



@end
