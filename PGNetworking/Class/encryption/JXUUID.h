//
//  JXUUID.h
//  jiuxian
//
//  Created by Dely on 15/9/11.
//  Copyright (c) 2015年 jiuxian.com. All rights reserved.
//

/**
 *  本类主要生成des加密的随机数
 */

#import <Foundation/Foundation.h>
#import <Base64.h>
@interface JXUUID : NSObject

/**
 *  获取uuid
 *
 *  @return 获取uudid String
 */
+ (NSString *)uuid;

/**
 *  获取des加解密的key
 *
 *  @return 加解密的key
 */
+ (NSString *)desKeyString;

/**
 *  获取UUID的base编码，用于网络传输
 *
 *  @param desKeyString des加解密的真实的key
 *
 *  @return 编码后的key
 */
+ (NSString *)base64DesKeyString:(NSString *)desKeyString;

/**
 *  直接获取des加解密的key 进行base64编码后的base64Key
 *
 *  @return 编码后key base64Key
 */
+ (NSString *)base64DesKeyString;

@end
