//
//  APIBase.h
//  PGNetworking
//
//  Created by tolly on 16/4/12.
//  Copyright © 2016年 张正超. All rights reserved.
//

#import "PGBaseAPIEntity.h"

@interface APIBase : PGBaseAPIEntity<PGAPIEntity,PGAPIResponseDelegate,PGAPIResponseDataReformer,PGAPIParamsDataSource,PGAPIValidator,PGApiInterceptor>

@end
