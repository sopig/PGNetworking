//
//  PGCommonParamsGenerator.h
//  PGNetworking
//
//  Created by 张正超 on 16/4/5.
//  Copyright © 2016年 张正超. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PGAppContext <NSObject>

@optional
- (NSString *)apiVersion;

- (NSString *)appVersion;

- (NSString *)deviceType;

- (NSString *)cpsId;

- (NSString *)screenReslolution;

- (NSString *)equipmentType ;

- (NSString *)sysVersion;

- (NSString *)appKey;

- (NSString *)token;

- (NSString *)areaId ;

- (NSString *)pushToken;

- (NSString *)channelCode;


@end

@protocol PGCommonParamsGenerator <NSObject>

@required

+ (NSObject<PGAppContext> *)appContext;

+ (NSDictionary *)commonParamsDictionary;

@end
