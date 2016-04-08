//
//  PGReauestGenerator.h
//  PGNetworking
//
//  Created by 张正超 on 16/4/5.
//  Copyright © 2016年 张正超. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
#import "PGNetworkingConfig.h"

#pragma mark - Private

extern NSString *__getBaseUrl(PGNetworkingServiceType type);

@interface PGAPIEnginePrepare : NSObject

+ (instancetype)shareInstance;

- (NSString *)getUrl:(NSString *)url params:(NSDictionary *)params;


@end
