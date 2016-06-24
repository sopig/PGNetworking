//
//  PGAPIEngine.h
//  PGNetworking
//
//  Created by tolly on 16/4/6.
//  Copyright © 2016年 张正超. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PGNetworking.h"

@interface PGAPIEngine : NSObject

+ (instancetype)shareInstance;


- (NSInteger)callGETWithParams:(NSDictionary *)params apiEntity:(PGBaseAPIEntity *)api success:(void (^)(PGAPIResponse *res))success fail:(void (^)(PGAPIResponse *res))fail;

- (NSInteger)callPOSTWithParams:(NSDictionary *)params apiEntity:(PGBaseAPIEntity *)api success:(void (^)(PGAPIResponse *res))success fail:(void (^)(PGAPIResponse *res))fail;

- (void)cancelRequestWithRequestID:(NSInteger)requestID;

- (void)cancelRequestWithRequestIDs:(NSArray *)requestIDs;

@end
