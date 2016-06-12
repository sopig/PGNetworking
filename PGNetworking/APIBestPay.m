//
//  APIBestPay.m
//  jiuxian
//
//  Created by 张正超 on 16/6/12.
//  Copyright © 2016年 jiuxian.com. All rights reserved.
//

#import "APIBestPay.h"

@implementation APIBestPay

- (PGNetworkingServiceType)serviceType{
    return PGNetworkingServiceTypePay;
}

- (NSString *)apiName{
    return @"pay/getYiPayNotifyUrl.htm";
}



@end
