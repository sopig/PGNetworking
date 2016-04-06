//
//  PGNetworkingReachability.m
//  PGNetworking
//
//  Created by tolly on 16/4/6.
//  Copyright © 2016年 张正超. All rights reserved.
//

#import "PGNetworkingReachability.h"

@implementation PGNetworkingReachability

+ (RACSignal *)openNetworkCheck{
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager startMonitoring];
    
    return [[NSNotificationCenter defaultCenter] rac_addObserverForName:AFNetworkingReachabilityDidChangeNotification object:nil];
}

+ (void)closeNetworkingCheck {
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
}

+ (BOOL)isReachable{
   return [[AFNetworkReachabilityManager sharedManager] isReachable];
}

+ (AFNetworkReachabilityStatus )netStatus{
   return [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus;
}




@end
