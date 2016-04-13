//
//  JXAppconfigPlist.h
//  jiuxian
//
//  Created by 张正超 on 15/12/7.
//  Copyright © 2015年 jiuxian.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JXAppconfigPlist : NSObject

@property(nonnull, nonatomic, strong) NSString *JXAppconfig;   //全局配置文件

+ (nullable NSArray *)propertyName;

+ (nullable NSArray *)loadPlists;

@end
