//
//  NSString+json.m
//  PGNetworking
//
//  Created by 张正超 on 16/4/12.
//  Copyright © 2016年 张正超. All rights reserved.
//

#import "NSString+json.h"

@implementation NSString (json)

- (NSDictionary *)toDictionary{
    
    NSData *jsonData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    id dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&error];
    if(error || ![dic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    return (NSDictionary *)dic;
}

@end
