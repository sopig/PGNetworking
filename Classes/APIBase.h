//
//  APIBase.h
//  PGNetworking
//
//  Created by tolly on 16/4/12.
//  Copyright © 2016年 张正超. All rights reserved.
//

#import "PGBaseAPIEntity.h"


#define PGDeprecated(instead) NS_DEPRECATED(2_0, 2_0, 2_0, 2_0, instead)

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


//////////////////////////////////////////////////////////////////////////////////////////////////////
- (PGAPIEntityRequestType)requestType;//如果是get方式，不用覆写
//////////////////////////////////////////////////////////////////////////////////////////////////////

//取数据
- (NSDictionary *)fetchData;
//- (id)fetchModel;
//请求起飞
- (APIBase *)send;

- (RACSignal *)sendSignal; PGDeprecated("sendSignal方法会造成循环引用的问题，暂不能使用");


@end
