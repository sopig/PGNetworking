//
//  PGNetworkingConfig.h
//  PGNetworking
//
//  Created by 张正超 on 16/4/5.
//  Copyright © 2016年 张正超. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PGBaseAPIEntity.h"


#define DATAKEY @"k1"       //加密数据key
#define ENCRPTYKEY @"k2"    //密钥数据key
#define HTTPTYPE @"k3"          //系统型号参数
#define HTTPDEVICE @"IOS"       //ios

//是否使用缓存
#define kPGNetworkingShouldCache YES
//使用什么加密方式
#define kPGNetworkingEncrypType PGNetworkingEncryptionTypeUse

static NSTimeInterval kCacheOutdateTimeSeconds = 100;
static NSTimeInterval kPGNetworkingTimeoutSeconds = 10;


@interface PGNetworkingConfig : NSObject

@property (nonatomic, strong, nonnull) NSObject<PGCommonParamsGenerator> *commonParamsGenerator;


+ (NSString *_Nonnull)baseUrlWithServiceType:(PGNetworkingServiceType)serviceType;

+ (BOOL)shouldEncryption;


@end
