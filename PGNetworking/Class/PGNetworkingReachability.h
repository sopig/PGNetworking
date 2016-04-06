//
//  PGNetworkingReachability.h
//  PGNetworking
//
//  Created by tolly on 16/4/6.
//  Copyright © 2016年 张正超. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AFNetworkReachabilityManager.h>
#import <ReactiveCocoa.h>

@interface PGNetworkingReachability : NSObject

+ (RACSignal *)openNetworkCheck;

+ (AFNetworkReachabilityStatus )netStatus;

@end
