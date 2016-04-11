//
//  JXDES.m
//  jiuxian
//
//  Created by Dely on 15/9/10.
//  Copyright (c) 2015年 jiuxian.com. All rights reserved.
//

#import "JXDES.h"
@implementation JXDES

+ (NSString *)tripleDES:(NSString *)plainString encryptOrDecrypt:(CCOperation)encryptOrDecrypt DESBase64Key:(NSString *)base64KeyString {

    //对base64编码过后的BasekeyString进行解码成真正的keyString
//    NSData *keyData = [GTMBase64 decodeString:base64KeyString];
    NSData *keyData = [base64KeyString base64DecodedData];
    const void *vkey = (const void *) [keyData bytes];

    const void *vplainText;
    size_t plainTextBufferSize;

    if (encryptOrDecrypt == kCCDecrypt) {

        //解密
//        NSData *EncryptData = [GTMBase64 decodeData:[plainString dataUsingEncoding:NSUTF8StringEncoding]];
         NSData *EncryptData = [plainString base64DecodedData];
        plainTextBufferSize = [EncryptData length];
        vplainText = [EncryptData bytes];

    } else {

        //加密
        NSData *data = [plainString dataUsingEncoding:NSUTF8StringEncoding];
        plainTextBufferSize = [data length];
        vplainText = (const void *) [data bytes];
    }

    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;

    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc(bufferPtrSize * sizeof(uint8_t));
    memset((void *) bufferPtr, 0x0, bufferPtrSize);

    ccStatus = CCCrypt(encryptOrDecrypt,
            kCCAlgorithm3DES,
            kCCOptionPKCS7Padding | kCCOptionECBMode,
            vkey,
            kCCKeySize3DES,
            nil,
            vplainText,
            plainTextBufferSize,
            (void *) bufferPtr,
            bufferPtrSize,
            &movedBytes);

    NSString *resultString;

    if (encryptOrDecrypt == kCCDecrypt) {
        //解密
        resultString = [[NSString alloc] initWithData:[NSData dataWithBytes:(const void *) bufferPtr
                                                                     length:(NSUInteger) movedBytes]
                                             encoding:NSUTF8StringEncoding];
    } else {
        //加密
        NSData *myData = [NSData dataWithBytes:(const void *) bufferPtr length:(NSUInteger) movedBytes];
        resultString = [myData base64EncodedString];
//        [GTMBase64 stringByEncodingData:myData];
    }
    if (bufferPtr) {
        free(bufferPtr);
    }

    return resultString;

}


@end
