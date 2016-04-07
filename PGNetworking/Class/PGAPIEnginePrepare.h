//
//  PGReauestGenerator.h
//  PGNetworking
//
//  Created by 张正超 on 16/4/5.
//  Copyright © 2016年 张正超. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
#import "PGNetworkingConfig.h"

typedef NS_ENUM (NSUInteger, PGNetworkingServiceType){
    PGNetworkingServiceTypeHome,
    PGNetworkingServiceTypeOMS,
    PGNetworkingServiceTypeProduct,
    PGNetworkingServiceTypeUser,
    PGNetworkingServiceTypeJiuzhang,
    
    PGNetworkingServiceTypePromotion,
    PGNetworkingServiceTypePay = PGNetworkingServiceTypePromotion
};


//不用bool值是为了以后方便扩展
typedef NS_ENUM (NSUInteger, PGNetworkingEncryptionType){
    PGNetworkingEncryptionTypeUse,
    PGNetworkingEncryptionTypeNotUse
};


@interface PGAPIEnginePrepare : NSObject

+ (instancetype)shareInstance;

- (AFHTTPSessionManager *)prepareManagerForServiceType:(PGNetworkingServiceType)type params:(id)params;

@end
