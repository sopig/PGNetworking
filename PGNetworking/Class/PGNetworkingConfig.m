//
//  PGNetworkingConfig.m
//  PGNetworking
//
//  Created by 张正超 on 16/4/5.
//  Copyright © 2016年 张正超. All rights reserved.
//

#import "PGNetworkingConfig.h"
#import "JXAppConfigSurport.h"

@implementation PGNetworkingConfig

+ (NSString *)baseUrlWithServiceType:(PGNetworkingServiceType)serviceType {
    switch (serviceType) {
        case PGNetworkingServiceTypeHome:
            return [[JXAppConfigSurport surport] urlStringFromSurport:@"JXBASE_URL_HOME"];
            break;
        case PGNetworkingServiceTypeOMS:
            return [[JXAppConfigSurport surport] urlStringFromSurport:@"JXBASE_URL_OMS"];
            break;
        case PGNetworkingServiceTypeProduct:
            return [[JXAppConfigSurport surport] urlStringFromSurport:@"JXBASE_URL_PRODUCT"];
            break;
        case PGNetworkingServiceTypeUser:
            return [[JXAppConfigSurport surport] urlStringFromSurport:@"JXBASE_URL_USER"];
            break;
        case PGNetworkingServiceTypeJiuzhang:
            return [[JXAppConfigSurport surport] urlStringFromSurport:@"JXBASE_URL_JIUZHANG"];
            break;
        case PGNetworkingServiceTypePromotion:
            return [[JXAppConfigSurport surport] urlStringFromSurport:@"JXBASE_URL_PROMOTION"];
            break;
    }
}

+ (BOOL)shouldEncryption{
    return [[JXAppConfigSurport surport] urlStringFromSurport:@"isENCRPTY"];
}

@end
