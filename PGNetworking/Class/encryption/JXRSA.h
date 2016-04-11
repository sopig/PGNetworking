//
//  JXRSA.h
//  jiuxian
//
//  Created by Dely on 15/9/11.
//  Copyright (c) 2015年 jiuxian.com. All rights reserved.
//
/**
 *  本类主要des加密的base64编码后的key进行加解密
 */

#import <Foundation/Foundation.h>
#import "CRSA.h"
#import <Base64.h>


@interface JXRSA : NSObject

/**
 *  导入本地公钥是否成功
 *
 *  @return 成功标志
 */
+ (BOOL)importRSAPublicKey;

/**
*  导入本地私钥是否成功
*
*  @return 成功标志
*/
+ (BOOL)importRSAPrivateKey;


#pragma mark ---------------------------加密-------------------------------

/**
 *  RSA加密数据NSString
 *
 *  @param cipherString 需要RSA加密的NSString
 *
 *  @return 加密后的base64编码的NSString
 */
+ (NSString *)encryptToStringWithCipherString:(NSString *)cipherString;


#pragma mark ---------------------------解密-------------------------------

/**
 *  RSA解密数据NSString
 *
 *  @param cipherString 需要RSA解密的NSString(经过base64编码)
 *
 *  @return 解密后的NSString
 */
+ (NSString *)decryptToStringWithCipherString:(NSString *)cipherString;


@end
