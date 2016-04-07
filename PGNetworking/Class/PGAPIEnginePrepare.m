//
//  PGReauestGenerator.m
//  PGNetworking
//
//  Created by 张正超 on 16/4/5.
//  Copyright © 2016年 张正超. All rights reserved.
//

#import "PGAPIEnginePrepare.h"
@interface PGAPIEnginePrepare ()

@property (nonatomic, strong) NSNumber *recordedRequestId;

@end

@implementation PGAPIEnginePrepare

+ (instancetype)shareInstance {
    static PGAPIEnginePrepare * __instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __instance = self.class.new;
    });
    return __instance;
}


#pragma mark - Private

NSURL *__getBaseUrl(PGNetworkingServiceType type){
    
    switch (type) {
        case PGNetworkingServiceTypeHome:
            return nil;
            break;
        case PGNetworkingServiceTypeOMS:
            return nil;
            break;
        case PGNetworkingServiceTypeProduct:
            return nil;
            break;
        case PGNetworkingServiceTypePromotion:
            return nil;
            break;
        case PGNetworkingServiceTypeUser:
            return nil;
            break;
        case PGNetworkingServiceTypeJiuzhang:
            return nil;
            break;
    }
}

- (NSNumber *)__generateRequestId
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



#pragma mark - Public
- (AFHTTPSessionManager *)prepareManagerForServiceType:(PGNetworkingServiceType)type params:(id)params{
    
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



@end
