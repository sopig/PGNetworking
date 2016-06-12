//
//  APIApplePay.m
//  PGNetworking
//
//  Created by 张正超 on 16/6/12.
//  Copyright © 2016年 张正超. All rights reserved.
//

#import "APIApplePay.h"

@implementation APIApplePay

- (PGNetworkingServiceType)serviceType{
    return PGNetworkingServiceTypePay;
}

- (NSString *)apiName{
    return @"pay/getApplePayData.htm";
}


@end
