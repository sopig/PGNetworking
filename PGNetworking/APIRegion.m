//
//  APIRegion.m
//  PGNetworking
//
//  Created by 张正超 on 16/4/12.
//  Copyright © 2016年 张正超. All rights reserved.
//

#import "APIRegion.h"
#import "regionModel.h"
@implementation APIRegion


- (id)api:(PGBaseAPIEntity *)api reformData:(NSDictionary *)data{
    
    regionModel *model = [regionModel yy_modelWithDictionary:data];
    
    return model;
    
}

@end
