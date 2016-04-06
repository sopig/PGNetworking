//
//  PGAPIEngine.h
//  PGNetworking
//
//  Created by tolly on 16/4/6.
//  Copyright © 2016年 张正超. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PGNetworking.h"

@interface PGAPIEngine : NSObject

+ (instancetype)shareInstance;

- (NSInteger)callGETWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName success:(void (^)(PGAPIResponse* response))success fail:(void (^)(PGAPIResponse* response))fail;
- (NSInteger)callPOSTWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName success:(void (^)(PGAPIResponse* response))success fail:(void (^)(PGAPIResponse* response))fail;

@end
