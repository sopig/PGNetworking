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

@property (nonatomic , strong) PGBaseAPIEntity *api;

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
    
    
   return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @weakify(self);
       
        self.whenSuccess = ^(PGBaseAPIEntity *api){
            @strongify(self);
            [subscriber sendNext:api];
            [subscriber sendCompleted];
        };
        
        self.whenFail = ^(PGBaseAPIEntity *api){
            @strongify(self);
            [subscriber sendNext:self];
            [subscriber sendCompleted];
        };
        
        NSInteger requestID = [self loadData];
        
        return [RACDisposable disposableWithBlock:^{
            @strongify(self);
            [self cancelRequestWithRequestId:requestID];
            
        }];
    }] replayLast];
 
}

- (APIBase *)send {
    [self loadData];
    return self;
}


- (void)dealloc{

}
@end
