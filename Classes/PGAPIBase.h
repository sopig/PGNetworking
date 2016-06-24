//
//  APIBase.h
//  PGNetworking
//
//  Created by tolly on 16/4/12.
//  Copyright © 2016年 张正超. All rights reserved.
//

#import "PGBaseAPIEntity.h"
#import "PGBaseModel.h"

#define PGDeprecated(instead) NS_DEPRECATED_IOS(2_0, 2_0, instead)

@interface PGAPIBase : PGBaseAPIEntity<PGAPIEntity,PGAPIResponseDelegate,PGAPIResponseDataReformer,PGAPIParamsDataSource,PGAPIValidator,PGApiInterceptor>

//请求落地的回调
@property (nonatomic ,copy) void (^whenSuccess)(PGBaseAPIEntity *api);
@property (nonatomic ,copy) void (^whenFail)(PGBaseAPIEntity *api);


/////////////////////
- (BOOL)shouldCache;
- (BOOL)shouldEncrypt;
/////////////////////


- (PGNetworkingServiceType)serviceType ;

-(PGAPIBase *)paramsForApiWithParams:(NSDictionary *(^)(void))block;

- (NSString *)apiName;

//请求参数
- (NSDictionary *)paramsForApi:(PGBaseAPIEntity *)api;

//数据转化为model
- (id)api:(PGBaseAPIEntity *)api reformData:(NSDictionary *)data;


//////////////////////////////////////////////////////////////////////////////////////////////////////
- (PGAPIEntityRequestType)requestType;//如果是get方式，不用覆写
//////////////////////////////////////////////////////////////////////////////////////////////////////


//取数据
- (NSDictionary *)fetchData;

- (id)fetchModel;
//请求起飞
- (PGAPIBase *)send;

- (RACSignal *)sendSignal;

- (void)cancelSend;
@end
