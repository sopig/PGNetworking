//
//  PGAPIEngine.m
//  PGNetworking
//
//  Created by tolly on 16/4/6.
//  Copyright © 2016年 张正超. All rights reserved.
//

#import "PGAPIEngine.h"
#import "PGAPIEnginePrepare.h"
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


- (NSInteger)callGETWithParams:(NSDictionary *)params serviceType:(PGNetworkingServiceType)serviceType apiName:(NSString *)apiName encryptionType:(PGNetworkingEncryptionType)encryType success:(void (^)(PGAPIResponse *))success fail:(void (^)(PGAPIResponse *))fail{
    
    NSString *url = nil;
    
    
    [self prepareManager] GET:<#(nonnull NSString *)#> parameters:<#(nullable id)#> progress:<#^(NSProgress * _Nonnull downloadProgress)downloadProgress#> success:<#^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)success#> failure:<#^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)failure#>
    
    
    
    return 0;
}

- (NSInteger)callPOSTWithParams:(NSDictionary *)params serviceType:(PGNetworkingServiceType)serviceType apiName:(NSString *)apiName encryptionType:(PGNetworkingEncryptionType)encryType success:(void (^)(PGAPIResponse *))success fail:(void (^)(PGAPIResponse *))fail {
    
    return 0;
}




@end
