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
@property (nonatomic, copy) NSURLRequest *request;
@property (nonatomic, copy) NSHTTPURLResponse *response;
@property (nonatomic, copy) NSURLSessionDataTask *task;


@property (nonatomic, copy) id content;
@property (nonatomic, copy) NSData *responseData;
@property (nonatomic, copy) NSString *contentString;


@property (nonatomic, assign) NSInteger requestId;

@property (nonatomic, copy) NSDictionary *requestParams;
@property (nonatomic, assign) BOOL isCache;

@property (nonatomic, copy) NSError *error;
@property (nonatomic, copy) NSString *errorMsg;

@end
