//
//  APIRegion.h
//  PGNetworking
//
//  Created by 张正超 on 16/4/12.
//  Copyright © 2016年 张正超. All rights reserved.
//

#import "PGBaseAPIEntity.h"

@interface APIRegion : PGBaseAPIEntity<PGAPIEntity,PGAPIResponseDelegate,PGAPIResponseDataReformer,PGAPIParamsDataSource,PGAPIValidator,PGApiInterceptor>


@end
