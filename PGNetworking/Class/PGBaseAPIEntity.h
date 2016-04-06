//
//  PGBaseAPIManager.h
//  PGNetworking
//
//  Created by tolly on 16/4/5.
//  Copyright © 2016年 张正超. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PGNetwokingType.h"

//调用成功之后的params里取出 requestId
static NSString *_Nonnull const kPGBaseAPIEntityRequestID = @"kPGBaseAPIEntityRequestID";


@class PGBaseAPIEntity;
@class PGAPIResponse;
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
- (NSString *_Nonnull)methodName;
- (NSString *_Nonnull)serviceType;
- (PGAPIEntityRequestType)requestType;

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

@optional
- (void)api:(PGBaseAPIEntity *_Nonnull)api beforePerformSuccessWithResponse:(PGAPIResponse *_Nonnull)response;
- (void)api:(PGBaseAPIEntity *_Nonnull)api afterPerformSuccessWithResponse:(PGAPIResponse *_Nonnull)response;

- (void)api:(PGBaseAPIEntity *_Nonnull)api beforePerformFailWithResponse:(PGAPIResponse *_Nonnull)response;
- (void)api:(PGBaseAPIEntity *_Nonnull)api afterPerformFailWithResponse:(PGAPIResponse *_Nonnull)response;

- (BOOL)api:(PGBaseAPIEntity *_Nonnull)api shouldCallAPIWithParams:(NSDictionary *_Nonnull)params;
- (void)api:(PGBaseAPIEntity *_Nonnull)api afterCallingAPIWithParams:(NSDictionary *_Nonnull)params;

@end


/////////////////////////////////////////////////////////////////////////



/////////////////////////////////////////////////////////////////////////



@interface PGBaseAPIEntity : NSObject

@property (nonatomic, weak, nullable) id<PGAPIResponseDelegate> delegate;
@property (nonatomic, weak, nullable) id<PGAPIParamsDataSource> paramSource;
@property (nonatomic, weak, nullable) id<PGAPIValidator> validator;
@property (nonatomic, weak, nullable) NSObject<PGAPIEntity> *child;
@property (nonatomic, weak, nullable) id<PGApiInterceptor> interceptor;

@property (nonatomic, copy, readonly) NSString *_Nonnull errorMessage;
@property (nonatomic, readonly) PGAPIEntityResponseType responseType;

@property (nonatomic, assign, readonly) BOOL isReachable;
@property (nonatomic, assign, readonly) BOOL isLoading;

- (id _Nullable)fetchDataWithReformer:(id<PGAPIResponseDataReformer> _Nullable)reformer;

- (NSInteger)loadData;


- (void)cancelAllRequests;
- (void)cancelRequestWithRequestId:(NSInteger)requestID;

// 拦截器方法，继承之后需要调用一下super
- (void)beforePerformSuccessWithResponse:(PGAPIResponse *_Nonnull)response;
- (void)afterPerformSuccessWithResponse:(PGAPIResponse *_Nonnull)response;

- (void)beforePerformFailWithResponse:(PGAPIResponse *_Nonnull)response;
- (void)afterPerformFailWithResponse:(PGAPIResponse *_Nonnull)response;

- (BOOL)shouldCallAPIWithParams:(NSDictionary *_Nonnull)params;
- (void)afterCallingAPIWithParams:(NSDictionary *_Nonnull)params;



- (NSDictionary *_Nullable)reformParams:(NSDictionary *_Nullable)params;
- (void)cleanData;
- (BOOL)shouldCache;

@end
