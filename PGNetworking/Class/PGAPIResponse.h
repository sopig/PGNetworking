//
//  PGAPIResponse.h
//  PGNetworking
//
//  Created by 张正超 on 16/4/6.
//  Copyright © 2016年 张正超. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PGNetwokingType.h"
@interface PGAPIResponse : NSObject

@property (nonatomic, assign) PGAPIEntityResponseType responseType;

@property (nonatomic, copy, readonly) id content;
@property (nonatomic, copy, readonly) NSString *contentString;

@property (nonatomic, assign, readonly) NSInteger requestId;
@property (nonatomic, copy, readonly) NSURLRequest *request;
@property (nonatomic, copy, readonly) NSData *responseData;
@property (nonatomic, copy) NSDictionary *requestParams;
@property (nonatomic, assign, readonly) BOOL isCache;


@end
