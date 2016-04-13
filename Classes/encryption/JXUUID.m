//
//  JXUUID.m
//  jiuxian
//
//  Created by Dely on 15/9/11.
//  Copyright (c) 2015年 jiuxian.com. All rights reserved.
//

#import "JXUUID.h"
@implementation JXUUID

+ (NSString *)uuid {

    CFUUIDRef puuid = CFUUIDCreate(nil);
    CFStringRef uuidString = CFUUIDCreateString(nil, puuid);
    NSString *result = (NSString *) CFBridgingRelease(CFStringCreateCopy(NULL, uuidString));
    CFRelease(puuid);
    CFRelease(uuidString);
    return result;
}

+ (NSString *)desKeyString {
    //获取uuid
    NSString *uuidString = [JXUUID uuid];
    //uuid生成36位 保留24位，随机剔除其中12位
    NSMutableString *tmpString = [uuidString mutableCopy];

    for (int i = 0; i < 12; i++) {
        if (i > (tmpString.length - 1)) {
            return nil;
        }
        NSInteger index = random() % tmpString.length;
        [tmpString deleteCharactersInRange:NSMakeRange(index, 1)];
    }

    return [tmpString copy];
}

+ (NSString *)base64DesKeyString:(NSString *)desKeyString {
    return [desKeyString base64EncodedString];
//    [GTMBase64 encodeBase64String:desKeyString];
}

+ (NSString *)base64DesKeyString {
    NSString *desKeyString = [JXUUID desKeyString];
    return [JXUUID base64DesKeyString:desKeyString];
}

@end
