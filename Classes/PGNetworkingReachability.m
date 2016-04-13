//
//  PGNetworkingReachability.m
//  PGNetworking
//
//  Created by tolly on 16/4/6.
//  Copyright © 2016年 张正超. All rights reserved.
//

#import "PGNetworkingReachability.h"
#import "JXCache.h"
@implementation PGNetworkingReachability

+ (void)load{
    [super load];
    [[self openNetworkCheck] subscribeNext:^(NSNotification * x) {
        
        [[JXCache cache] putObject:x.userInfo[AFNetworkingReachabilityNotificationStatusItem]
                            forKey:AFNetworkingReachabilityNotificationStatusItem];
    }];
}

+ (RACSignal *)openNetworkCheck{
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager startMonitoring];
    
    return [[NSNotificationCenter defaultCenter] rac_addObserverForName:AFNetworkingReachabilityDidChangeNotification object:nil];
}

+ (void)closeNetworkingCheck {
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
}

+ (BOOL)isReachable{
    if (![[JXCache cache] getObjectByKey:AFNetworkingReachabilityNotificationStatusItem]) {
        return YES;
    }
    else {
        NSArray *net = (NSArray *)[[JXCache cache] getObjectByKey:AFNetworkingReachabilityNotificationStatusItem];
        NSNumber *netStatus = net[0];
        
        switch (netStatus.integerValue) {
            case AFNetworkReachabilityStatusUnknown:
            case AFNetworkReachabilityStatusNotReachable:
                return NO;
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
            case AFNetworkReachabilityStatusReachableViaWiFi:
                return YES;
                break;
        }
    }

    return YES;
}

+ (AFNetworkReachabilityStatus )netStatus{
   return [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus;
}




@end
