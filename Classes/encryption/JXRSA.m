//
//  JXRSA.m
//  jiuxian
//
//  Created by Dely on 15/9/11.
//  Copyright (c) 2015年 jiuxian.com. All rights reserved.
//

#import "JXRSA.h"
@implementation JXRSA

+ (BOOL)importRSAPublicKey {

    CRSA *wrapper = [CRSA shareInstance];
    if ([wrapper importRSAKeyWithType:KeyTypePublic]) {
        return YES;
    }
//    CLog(@"公钥导入失败无法加解密");
    return NO;
}

+ (BOOL)importRSAPrivateKey {

    CRSA *wrapper = [CRSA shareInstance];
    if ([wrapper importRSAKeyWithType:KeyTypePrivate]) {
        return YES;
    }
//    CLog(@"私钥导入失败无法加解密");
    return NO;
}

#pragma mark ---------------------------加密-------------------------------


/**
 *  RSA加密数据NSString
 *
 *  @param cipherString 需要RSA加密的NSString
 *
 *  @return 加密后的base64编码的NSString
 */
+ (NSString *)encryptToStringWithCipherString:(NSString *)cipherString {

    CRSA *wrapper = [CRSA shareInstance];
    return [wrapper encryptByRsa:cipherString withKeyType:KeyTypePublic];
}


#pragma mark ---------------------------解密-------------------------------


+ (NSString *)decryptToStringWithCipherString:(NSString *)cipherString{
    CRSA *wrapper = [CRSA shareInstance];
    return [wrapper decryptByRsa:cipherString withKeyType:KeyTypePrivate];
}
@end
