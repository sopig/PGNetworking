//
//  JXCommonParamsGenerator.m
//  PGNetworking
//
//  Created by 张正超 on 16/4/5.
//  Copyright © 2016年 张正超. All rights reserved.
//

#import "JXCommonParamsGenerator.h"
#import "JXAppContext.h"


@implementation JXCommonParamsGenerator

+ (NSObject<PGAppContext> *)appContext {
    return [JXAppContext new];
}

+ (NSDictionary *)commonParamsDictionary {
    
    NSObject<PGAppContext> *context = [JXCommonParamsGenerator appContext];
    
    return @{@"apiVersion":[context apiVersion],
             @"appVersion":[context appVersion],
             @"deviceType":[context deviceType],
             @"cpsId":[context cpsId],
             @"screenReslolution":[context screenReslolution],
             @"equipmentType":[context equipmentType],
             @"sysVersion":[context sysVersion],
             @"appKey":[context appKey],
             @"token":[context token],
             @"areaId":[context areaId],
             @"pushToken":[context pushToken],
             @"channelCode":[context channelCode]};
}

@end
