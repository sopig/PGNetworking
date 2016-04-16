//
//  APIBase.m
//  PGNetworking
//
//  Created by tolly on 16/4/12.
//  Copyright © 2016年 张正超. All rights reserved.
//

#import "APIBase.h"
#import "ReactiveCocoa.h"
//#import <FBRetainCycleDetector/FBRetainCycleDetector.h>
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
    return [@{@"test":@"hello PGNetworking"} copy];
}



- (BOOL)api:(PGBaseAPIEntity *)api isCorrectWithParamsData:(NSDictionary *)data{
    return YES;
}

- (BOOL)api:(PGBaseAPIEntity *)api isCorrectWithCallBackData:(NSDictionary * _Nullable)data{
    return YES;
}



//数据转化为model
- (id)api:(PGBaseAPIEntity *)api reformData:(NSDictionary *)data {
    return @"hello PGNetworking";
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
    
//    NSAssert(0, @"sendSignal方法会造成循环引用的问题，暂不能使用");
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        
        self.whenSuccess = ^(PGBaseAPIEntity *api){

            [subscriber sendNext:api];
            [subscriber sendCompleted];
            
            
        };
        
        self.whenFail = ^(PGBaseAPIEntity *api){
            
            [subscriber sendNext:api];
            [subscriber sendCompleted];
        };
       
        NSInteger requestID = [self loadData];
        
        return [RACDisposable disposableWithBlock:^{
          
            [self cancelRequestWithRequestId:requestID];
            
        }];
    }];
 
}

- (APIBase *)send {
    [self loadData];
    return self;
}


- (id)fetchModel{
    return  [self fetchDataWithReformer:self];
}

- (void)dealloc{

}
@end
