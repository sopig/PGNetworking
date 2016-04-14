//
//  APIBase.m
//  PGNetworking
//
//  Created by tolly on 16/4/12.
//  Copyright © 2016年 张正超. All rights reserved.
//

#import "APIBase.h"
#import "ReactiveCocoa.h"

@interface APIBase ()

@end

@implementation APIBase
- (instancetype)init{
    if (self = [super init]) {
        self.delegate = self;
        self.validator = self;
        self.paramSource = self;
        self.child = self;
        self.interceptor = self;
        
    }
    return self;
}

- (PGNetworkingServiceType)serviceType {
    return PGNetworkingServiceTypeProduct;
}

- (NSString *)apiName{
    return @"/product/regionList.htm";
}

- (PGAPIEntityRequestType)requestType {
    return PGAPIEntityRequestTypeGet;
}

- (NSDictionary *)paramsForApi:(PGBaseAPIEntity *)api{
    return nil;
}



- (BOOL)api:(PGBaseAPIEntity *)api isCorrectWithParamsData:(NSDictionary *)data{
    return YES;
}

- (BOOL)api:(PGBaseAPIEntity *)api isCorrectWithCallBackData:(NSDictionary * _Nullable)data{
    return YES;
}



//数据转化为model
- (id)api:(PGBaseAPIEntity *)api reformData:(NSDictionary *)data {
    
    return [NSObject new];
    
}

//回调
- (void)doFailed:(PGBaseAPIEntity *)api{
    if (self.whenFail) {
         self.whenFail(api);
    }
}

- (void)doSuccess:(PGBaseAPIEntity *)api{
    if (self.whenSuccess) {
        self.whenSuccess(api);
    }
}


- (RACSignal *)sendSignal {
    
    @weakify(self);
    RACSignal *signal = [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        @weakify(subscriber);
        self.whenSuccess = ^(PGBaseAPIEntity *api){
            @strongify(subscriber);
            [subscriber sendNext:api];
            [subscriber sendCompleted];
        };
        
        self.whenFail = ^(PGBaseAPIEntity *api){
             @strongify(subscriber);
            [subscriber sendNext:api];
            [subscriber sendCompleted];
        };
        
         NSInteger requestID = [self loadData];
        
        return [RACDisposable disposableWithBlock:^{
            
            [self cancelRequestWithRequestId:requestID];
            
        }];
    }] replayLast];
    
    return signal;
}

- (APIBase *)send {
    [self loadData];
    return self;
}


- (void)dealloc{

}
@end
