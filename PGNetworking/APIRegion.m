//
//  APIRegion.m
//  PGNetworking
//
//  Created by 张正超 on 16/4/12.
//  Copyright © 2016年 张正超. All rights reserved.
//

#import "APIRegion.h"

@implementation APIRegion

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

}

- (void)doSuccess:(PGBaseAPIEntity *)api{
  id x =  [api fetchDataWithReformer:self];
}

@end
