//
//  JXAppconfigPlist.m
//  jiuxian
//
//  Created by 张正超 on 15/12/7.
//  Copyright © 2015年 jiuxian.com. All rights reserved.
//

#import "JXAppconfigPlist.h"
#import <objc/runtime.h>
@implementation JXAppconfigPlist

+ (NSArray *)propertyName {
    unsigned int count;
    NSMutableArray *value = [NSMutableArray new];
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    for (int i = 0; i < count; i++) {
        objc_property_t property = properties[i];
        [value addObject:[NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding]];
//        CLog(@"name:%s", property_getName(property));
//        CLog(@"attributes:%s", property_getAttributes(property));

    }
    free(properties);
    return [value copy];
}

+ (NSArray *)loadPlists {

    NSArray *plistNames = [[JXAppconfigPlist propertyName] copy];
    NSMutableArray *paths = [NSMutableArray array];
    [plistNames enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        NSString *path = [[NSBundle mainBundle] pathForResource:obj ofType:@"plist"];
        NSAssert(path, ([NSString stringWithFormat:@"检查%@plist配置文件是否正确", obj, nil]));
        [paths addObject:path];
    }];

    return [paths copy];

}

@end
