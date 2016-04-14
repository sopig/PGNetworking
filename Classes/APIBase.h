//
//  APIBase.h
//  PGNetworking
//
//  Created by tolly on 16/4/12.
//  Copyright © 2016年 张正超. All rights reserved.
//

#import "PGBaseAPIEntity.h"


@interface APIBase : PGBaseAPIEntity<PGAPIEntity,PGAPIResponseDelegate,PGAPIResponseDataReformer,PGAPIParamsDataSource,PGAPIValidator,PGApiInterceptor>

//请求落地的回调
@property (nonatomic ,copy) void (^whenSuccess)(PGBaseAPIEntity *api);
@property (nonatomic ,copy) void (^whenFail)(PGBaseAPIEntity *api);





- (PGNetworkingServiceType)serviceType ;

- (NSString *)apiName;

//请求参数
- (NSDictionary *)paramsForApi:(PGBaseAPIEntity *)api;

//数据转化为model
- (id)api:(PGBaseAPIEntity *)api reformData:(NSDictionary *)data;


//请求起飞
- (APIBase *)send;

- (RACSignal *)sendSignal;

//////////////////////////////////////////////////////////////////////////////////////////////////////
- (PGAPIEntityRequestType)requestType;//如果是get方式，不用覆写
//////////////////////////////////////////////////////////////////////////////////////////////////////

@end
