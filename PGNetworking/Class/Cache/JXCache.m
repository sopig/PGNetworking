//
//  JXCache.m
//  jiuxian
//
//  Created by 张正超 on 15/12/10.
//  Copyright © 2015年 jiuxian.com. All rights reserved.
//

/**
 *  暂时依赖开源项目 YTKKeyValueStore，后续替换自己的方案
 */


#import "JXCache.h"
#import "YTKKeyValueStore.h"


#define store_table_name @"com_jiuxian_cache"

@interface JXCache ()
@property(nonatomic, nonnull, strong) YTKKeyValueStore *store;
@end


@implementation JXCache

/**
 *  暂时写成单例，后续考虑实际情况，重写
 *
 *
 */
+ (instancetype)cache {
    static id __cache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __cache = [self class].new;

    });
    return __cache;
}

- (YTKKeyValueStore *)store {
    if (!_store) {
        _store = [[YTKKeyValueStore alloc] initDBWithName:@"jiuxian.db"];
        [_store createTableWithName:store_table_name];
    }
    return _store;
}


- (void)putObject:(id)obj forKey:(NSString *)sKey {
    
    if ([[obj class] isSubclassOfClass:[NSNumber class]]) {
        [self.store putNumber:obj withId:sKey intoTable:store_table_name];
    } else if ([[obj class] isSubclassOfClass:[NSString class]]){
        [self.store putString:obj withId:sKey intoTable:store_table_name];
    } else {
        [self.store putObject:obj withId:sKey intoTable:store_table_name];
    }
    
    
}

- (id)getObjectByKey:(NSString *)sKey {
    return [self.store getObjectById:sKey fromTable:store_table_name];
}

- (YTKKeyValueItem *)getItemByKey:(NSString *)sKey {
    return [self.store getYTKKeyValueItemById:sKey fromTable:store_table_name];
}

- (void)deleteObjectByKey:(NSString *)sKey {
    [self.store deleteObjectById:sKey fromTable:store_table_name];
}


- (void)clearAllCache {
    if (!_store)
           return;
    
    [_store clearTable:store_table_name];
     _store = nil;
}

#pragma mark -
- (BOOL)isOutdatedForKey:(NSString *)sKey {
    YTKKeyValueItem *item = [self getItemByKey:sKey];
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:item.createdTime];
    return timeInterval > kCacheOutdateTimeSeconds;

}

#pragma mark -  URL Cache
- (NSDictionary *)fetchCachedDataForkey:(NSString *)key {
    //如果无网络则直接返回缓存数据
    if (![PGNetworkingReachability isReachable]) {
        return [self getObjectByKey:key];
    }
    //如果缓存过期
    if ([self isOutdatedForKey:key]) {
        return nil;
    } else {
        return [self getObjectByKey:key];
    }
}
- (NSData *)fetchCachedDataWithServiceType:(PGNetworkingServiceType)serviceType apiName:(NSString *)apiName requestParams:(NSDictionary *)params{
    NSString *key = [self keyWithServiceType:serviceType apiName:apiName requestParams:params];
    
    //如果无网络则直接返回缓存数据
    if (![PGNetworkingReachability isReachable]) {
        return [self getObjectByKey:key];
    }
    //如果缓存过期
    if ([self isOutdatedForKey:key]) {
        return nil;
    } else {
        return [self getObjectByKey:key];
    }
}

- (void)saveCacheWithData:(NSDictionary *)responseData forKey:(NSString *_Nonnull)key {
    if ([self getObjectByKey:key]) {
        [self deleteObjectByKey:key];
    }
    
    [self putObject:responseData forKey:key];
}

- (void)saveCacheWithData:(NSDictionary *)responseData serviceType:(PGNetworkingServiceType)serviceType apiName:(NSString *)apiName requestParams:(NSDictionary *)requestParams{
    NSString *key = [self keyWithServiceType:serviceType apiName:apiName requestParams:requestParams];
    
    if ([self getObjectByKey:key]) {
        [self deleteObjectByKey:key];
    }
    
    [self putObject:responseData forKey:key];
}

- (NSString *)keyWithServiceType:(PGNetworkingServiceType)serviceType apiName:(NSString *)apiName requestParams:(NSDictionary *)requestParams
{
    return @"sKey";
}

@end
