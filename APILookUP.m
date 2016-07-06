//
//  APILookUP.m
//  PGNetworking
//
//  Created by 张正超 on 16/7/6.
//  Copyright © 2016年 张正超. All rights reserved.
//

#import "APILookUP.h"

@implementation APILookUP

- (PGNetworkingServiceType)serviceType{
    return PGNetworkingServiceTypeDefault;
}

- (NSString *)apiName{
    return @"http://itunes.apple.com/lookup?id=543114016";
}

- (BOOL)shouldCache {
    return NO;
}

- (BOOL)shouldEncrypt {
    return NO;
}

@end
