//
//  NSString+urlEncoding.m
//  PGNetworking
//
//  Created by tolly on 16/4/8.
//  Copyright © 2016年 张正超. All rights reserved.
//

#import "NSString+urlEncoding.h"

@implementation NSString (urlEncoding)


- (NSString *)trimLeftAndRight {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)urlEncoding{
    
    NSString *str = [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"!*'();:@&=+$,/?%#[]"]];
    //空格替换成+
    return [str stringByReplacingOccurrencesOfString:@"%20" withString:@"+"];
}

- (NSString *)urlDecoding {
    return [self stringByRemovingPercentEncoding];
}

@end
