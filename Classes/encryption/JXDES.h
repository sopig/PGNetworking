//
//  JXDES.h
//  jiuxian
//
//  Created by Dely on 15/9/10.
//  Copyright (c) 2015年 jiuxian.com. All rights reserved.
//

/**
 *  本类主要对传输数据进行加解密
 */

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import <Security/Security.h>
#import <Base64.h>

@interface JXDES : NSObject

/**
 *  3Des 加解密 对明文加密和密文解密
 *
 *  @param plainString      需要加解密的数据
 *  @param encryptOrDecrypt 加解密模式 kCCEncrypt-加密  kCCDecrypt-解密
 *  @param base64KeyString        进行base编码过后的keyString
 *
 *  @return 返回加解密的结果String
 */
+ (NSString *)tripleDES:(NSString *)plainString encryptOrDecrypt:(CCOperation)encryptOrDecrypt DESBase64Key:(NSString *)base64KeyString;


@end
