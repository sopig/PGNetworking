//
//  JXCache.h
//  jiuxian
//
//  Created by 张正超 on 15/12/10.
//  Copyright © 2015年 jiuxian.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YTKKeyValueStore.h"
#import "PGNetworking.h"

@interface JXCache : NSObject


+ (instancetype)cache;

//
- (NSDictionary *)fetchCachedDataForkey:(NSString *)key;
- (NSData *)fetchCachedDataWithServiceType:(PGNetworkingServiceType)serviceType apiName:(NSString *)apiName requestParams:(NSDictionary *)params;

- (void)saveCacheWithData:(NSDictionary *)responseData forKey:(NSString *)key;
- (void)saveCacheWithData:(NSDictionary *)responseData serviceType:(PGNetworkingServiceType)serviceType apiName:(NSString *)apiName requestParams:(NSDictionary *)requestParams;

//基础方法
- (void)putObject:(id)obj forKey:(NSString *)sKey;

- (id)getObjectByKey:(NSString *)sKey;

- (YTKKeyValueItem *)getItemByKey:(NSString *)sKey;

- (void)deleteObjectByKey:(NSString *)sKey;

- (void)clearAllCache;

@end
