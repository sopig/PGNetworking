//
//  PGAPIEngine.h
//  PGNetworking
//
//  Created by tolly on 16/4/6.
//  Copyright © 2016年 张正超. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PGNetworking.h"
#import "PGAPIEnginePrepare.h"
@interface PGAPIEngine : NSObject

+ (instancetype)shareInstance;

- (NSInteger)callGETWithParams:(NSDictionary *)params serviceType:(PGNetworkingServiceType)serviceType apiName:(NSString *)apiName encryptionType:(PGNetworkingEncryptionType)encryType success:(void (^)(PGAPIResponse *))success fail:(void (^)(PGAPIResponse *))fail;

- (NSInteger)callPOSTWithParams:(NSDictionary *)params serviceType:(PGNetworkingServiceType)serviceType apiName:(NSString *)apiName encryptionType:(PGNetworkingEncryptionType)encryType success:(void (^)(PGAPIResponse *))success fail:(void (^)(PGAPIResponse *))fail;

@end
