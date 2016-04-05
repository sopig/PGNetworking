//
//  PGCommonParamsGenerator.h
//  PGNetworking
//
//  Created by 张正超 on 16/4/5.
//  Copyright © 2016年 张正超. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PGBaseAPIEntity;
/////////////////////////////////////////////////////////////////////////
@protocol PGAppContext <NSObject>

@end
/////////////////////////////////////////////////////////////////////////
@protocol PGCommonParams <NSObject>

@optional
- (nonnull NSString *)apiVersion;

- (nonnull NSString *)appVersion;

- (nonnull NSString *)deviceType;

- (nonnull NSString *)cpsId;

- (nonnull NSString *)screenReslolution;

- (nonnull NSString *)equipmentType ;

- (nonnull NSString *)sysVersion;

- (nonnull NSString *)appKey;

- (nonnull NSString *)token;

- (nonnull NSString *)areaId ;

- (nonnull NSString *)pushToken;

- (nonnull NSString *)channelCode;


@end


/////////////////////////////////////////////////////////////////////////
@protocol PGCommonParamsGenerator <NSObject>

@required

+ (nonnull NSObject<PGCommonParams> *)appContext;

+ (nonnull NSDictionary *)commonParamsDictionary;

@end


/////////////////////////////////////////////////////////////////////////
@protocol PGAPIEntity <NSObject>

@required


@optional
- (void)cleanData;
- (nullable NSDictionary *)reformParams:(nullable NSDictionary *)params;
- (BOOL)shouldCache;

@end

/////////////////////////////////////////////////////////////////////////
@protocol PGAPIResponseDelegate <NSObject>

@required

- (void)doSuccess:(PGBaseAPIEntity *_Nonnull)api;
- (void)doFailed:(PGBaseAPIEntity *_Nonnull)api;

@end

/////////////////////////////////////////////////////////////////////////
//数据的转化
@protocol PGAPIResponseDataReformer <NSObject>
@required
- (id _Nullable)api:(PGBaseAPIEntity *_Nonnull)api reformData:(NSDictionary *_Nonnull)data;

@end

/////////////////////////////////////////////////////////////////////////
@protocol PGAPIValidator <NSObject>
//数据格式的验证
- (BOOL)api:(PGBaseAPIEntity *_Nonnull)api isCorrectWithCallBackData:(NSDictionary *_Nullable)data;

- (BOOL)api:(PGBaseAPIEntity *_Nonnull)api isCorrectWithParamsData:(NSDictionary *_Nullable)data;


@end


/////////////////////////////////////////////////////////////////////////
@protocol PGAPIParamsDataSource <NSObject>

- (NSDictionary *_Nullable)paramsForApi:(PGBaseAPIEntity *_Nullable)api;

@end


/////////////////////////////////////////////////////////////////////////
@protocol PGApiInterceptor <NSObject>
#if 0
@optional
- (void)manager:(PGBaseAPIEntity *)api beforePerformSuccessWithResponse:(xxx *)response;
- (void)manager:(PGBaseAPIEntity *)api afterPerformSuccessWithResponse:(xxx *)response;

- (void)manager:(PGBaseAPIEntity *)api beforePerformFailWithResponse:(xxx *)response;
- (void)manager:(PGBaseAPIEntity *)api afterPerformFailWithResponse:(xxx *)response;

- (BOOL)manager:(PGBaseAPIEntity *)api shouldCallAPIWithParams:(xxx *)params;
- (void)manager:(PGBaseAPIEntity *)api afterCallingAPIWithParams:(xxx *)params;
#endif
@end


/////////////////////////////////////////////////////////////////////////



/////////////////////////////////////////////////////////////////////////
