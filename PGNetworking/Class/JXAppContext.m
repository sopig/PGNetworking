//
//  JXAppContext.m
//  PGNetworking
//
//  Created by 张正超 on 16/4/5.
//  Copyright © 2016年 张正超. All rights reserved.
//

#import "JXAppContext.h"
#import <UIKit/UIKit.h>
#import <AdSupport/AdSupport.h>


#import "UIDevice+JXHardware.h"   //后期需封装Foundation

@implementation JXAppContext

- (NSString *)apiVersion{
    return @"1.0";
}

- (NSString *)appVersion {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
}

- (NSString *)deviceType {
    return @"IPHONE";
}

- (NSString *)cpsId {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"com.jiuxian.appcpsid"];
}

- (NSString *)screenReslolution {
    return [NSString stringWithFormat:@"%.2fx%.2f",
            [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height];
}

- (NSString *)equipmentType {
    return [[UIDevice currentDevice] hardwareDescription];
}

- (NSString *)sysVersion {
    return [[UIDevice currentDevice] systemVersion];
}

- (NSString *)appKey {
    
    if ([[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled]) {
        NSString *idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
        if (idfa) {
            return idfa;
        } else {
            NSString *idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
            return idfv;
        }
    } else {
        NSString *idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        return idfv;
    }
}

- (NSString *)channelCode {
    return @"0,1";
}


- (NSString *)token {
    return @"";
}

- (NSString *)areaId {
    return @"";
}

- (NSString *)pushToken {
    return @"";
}

@end
