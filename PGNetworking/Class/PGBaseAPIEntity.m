//
//  PGBaseAPIManager.m
//  PGNetworking
//
//  Created by tolly on 16/4/5.
//  Copyright © 2016年 张正超. All rights reserved.
//

#import "PGBaseAPIEntity.h"
#import "JXCommonParamsGenerator.h"

@implementation PGBaseAPIEntity

- (nullable NSURLSessionDataTask *)get{
    return [[AFHTTPSessionManager manager] GET:@"https://www.baidu.com" parameters:nil
    progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"%@",downloadProgress.localizedDescription);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
      NSLog(@"%@", [JXCommonParamsGenerator commonParamsDictionary]);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    NSLog(@"%@", [JXCommonParamsGenerator commonParamsDictionary]);
    }];
}

@end
