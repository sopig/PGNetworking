//
//  JXAppConfigSurport.h
//  jiuxian
//
//  Created by 张正超 on 15/12/4.
//  Copyright © 2015年 jiuxian.com. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXTERN NSString *_Nonnull const JXHOSTDOMAIN;

typedef NS_ENUM(NSInteger, JXAPISERVICETYPE) {
    JXAPISERVICE_developer,
    JXAPISERVICE_qa,
    JXAPISERVICE_GRAY,
    JXAPISERVICE_ONLINE,
    JXAPISERVICE_TEST,
    JXAPISERVICE_reserve
};

@interface JXAppConfigSurport : NSObject

+ (nullable instancetype)surport;

- (void)setDefaultHostDomain;

- (nonnull NSDictionary *)getServerWithType:(JXAPISERVICETYPE)type;

- (nonnull NSString *)urlStringFromSurport:(nonnull NSString *)sKey;


@end
