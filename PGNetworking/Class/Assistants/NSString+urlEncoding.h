//
//  NSString+urlEncoding.h
//  PGNetworking
//
//  Created by tolly on 16/4/8.
//  Copyright © 2016年 张正超. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (urlEncoding)

- (NSString *)trimLeftAndRight;

- (NSString *)urlEncoding;

- (NSString *)urlDecoding;
@end
