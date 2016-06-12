//
//  APIFunctionSwitch.m
//  PGNetworking
//
//  Created by 张正超 on 16/6/12.
//  Copyright © 2016年 张正超. All rights reserved.
//

#import "APIFunctionSwitch.h"

@implementation APIFunctionSwitch

- (PGNetworkingServiceType)serviceType{
    return PGNetworkingServiceTypeHome;
}

- (NSString *)apiName{
  return  @"home/getFunctionSwitch.htm";
}

@end
