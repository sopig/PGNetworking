//
//  PGAPIEngine.m
//  PGNetworking
//
//  Created by tolly on 16/4/6.
//  Copyright © 2016年 张正超. All rights reserved.
//

#import "PGAPIEngine.h"

@implementation PGAPIEngine

+ (instancetype)shareInstance {
    static PGAPIEngine *__instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __instance = [PGAPIEngine new];
    });
    return __instance;
}

- (NSInteger)callGETWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName success:(void (^)(PGAPIResponse *))success fail:(void (^)(PGAPIResponse *))fail {
    return 0;
}

- (NSInteger)callPOSTWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName success:(void (^)(PGAPIResponse *))success fail:(void (^)(PGAPIResponse *))fail {
    return 0;
}

@end
