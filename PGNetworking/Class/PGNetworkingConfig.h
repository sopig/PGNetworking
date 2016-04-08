//
//  PGNetworkingConfig.h
//  PGNetworking
//
//  Created by 张正超 on 16/4/5.
//  Copyright © 2016年 张正超. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PGBaseAPIEntity.h"

#define kPGNetworkingShouldCache YES
#define kPGNetworkingEncrypType PGNetworkingEncryptionTypeUse

static NSTimeInterval kCacheOutdateTimeSeconds = 300;  
static NSTimeInterval kPGNetworkingTimeoutSeconds = 10;


@interface PGNetworkingConfig : NSObject

@property (nonatomic, strong) NSObject<PGCommonParamsGenerator> *commonParamsGenerator;

@end
