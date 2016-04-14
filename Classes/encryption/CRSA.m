//
//  CRSA.m
//  MGJH5ContainerDemo
//
//  Created by xinba on 4/28/14.
//  Copyright (c) 2014年 juangua. All rights reserved.
//

#import "CRSA.h"

#define BUFFSIZE  1024

#import <openssl/pem.h>
#import <openssl/rsa.h>

#import <Base64.h>

#define PADDING RSA_PADDING_TYPE_PKCS1

@implementation CRSA

+ (id)shareInstance {
    static CRSA *_crsa = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _crsa = [[self alloc] init];
    });
    return _crsa;
}

- (BOOL)importRSAKeyWithType:(KeyType)type {
    FILE *file;
    NSString *keyName = type == KeyTypePublic ? @"public_key" : @"private_key";
    NSString *keyPath = [[NSBundle mainBundle] pathForResource:keyName ofType:@"pem"];

    NSAssert([[NSFileManager defaultManager] fileExistsAtPath:keyPath], @"Public key not exist");

    file = fopen([keyPath UTF8String], "rb");

    if (NULL != file) {
        if (type == KeyTypePublic) {
            _rsa = PEM_read_RSA_PUBKEY(file, NULL, NULL, NULL);
            assert(_rsa != NULL);
        }
        else {
            _rsa = PEM_read_RSAPrivateKey(file, NULL, NULL, NULL);
            assert(_rsa != NULL);
        }

        fclose(file);

        return (_rsa != NULL) ? YES : NO;
    }

    return NO;
}

- (NSString *)encryptByRsa:(NSString *)content withKeyType:(KeyType)keyType {
    if (![self importRSAKeyWithType:keyType])
        return nil;

    int status;
    size_t length = [content length];
    unsigned char input[length + 1];
    bzero(input, length + 1);
    int i = 0;
    for (; i < length; i++) {
        input[i] = (unsigned char) [content characterAtIndex:i];
    }

    int flen = [self getBlockSizeWithRSA_PADDING_TYPE:PADDING];

    char *encData = (char *) malloc((size_t) flen);
    bzero(encData, (size_t) flen);

    switch (keyType) {
        case KeyTypePublic:
            status = RSA_public_encrypt((int)length, (unsigned char *) input, (unsigned char *) encData, _rsa, PADDING);
            break;

        case KeyTypePrivate:
            status = RSA_private_encrypt((int)length, (unsigned char *) input, (unsigned char *) encData, _rsa, PADDING);
            break;
    }

    if (status) {
        NSData *returnData = [NSData dataWithBytes:encData length:(size_t) status];
        free(encData);
        encData = NULL;

        NSString *ret = [returnData base64EncodedString];
        return ret;
    }
    free(encData);
    encData = NULL;

    return nil;
}

- (NSString *)decryptByRsa:(NSString *)content withKeyType:(KeyType)keyType {
    if (![self importRSAKeyWithType:keyType])
        return nil;

    int status;

    NSData *data = [content base64DecodedData];
    NSUInteger length = [data length];

    int flen = [self getBlockSizeWithRSA_PADDING_TYPE:PADDING];
    char *decData = (char *) malloc((size_t) flen);
    bzero(decData, (size_t) flen);

    switch (keyType) {
        case KeyTypePublic:
            status = RSA_public_decrypt((int)length, (unsigned char *) [data bytes], (unsigned char *) decData, _rsa, PADDING);
            break;

        case KeyTypePrivate:
            status = RSA_private_decrypt((int)length, (unsigned char *) [data bytes], (unsigned char *) decData, _rsa, PADDING);
            break;
    }

    if (status) {
        NSMutableString *decryptString = [[NSMutableString alloc] initWithBytes:decData length:strlen(decData) encoding:NSASCIIStringEncoding];
        free(decData);
        decData = NULL;

        return decryptString;
    }

    free(decData);
    decData = NULL;

    return nil;
}

- (int)getBlockSizeWithRSA_PADDING_TYPE:(RSA_PADDING_TYPE)padding_type {
    int len = RSA_size(_rsa);

    if (padding_type == RSA_PADDING_TYPE_PKCS1 || padding_type == RSA_PADDING_TYPE_SSLV23) {
        len -= 11;
    }

    return len;
}
@end
