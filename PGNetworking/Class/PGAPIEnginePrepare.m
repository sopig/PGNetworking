//
//  PGReauestGenerator.m
//  PGNetworking
//
//  Created by 张正超 on 16/4/5.
//  Copyright © 2016年 张正超. All rights reserved.
//

#import "PGAPIEnginePrepare.h"
#import "JXCommonParamsGenerator.h"

@interface PGAPIEnginePrepare ()

@property (nonatomic, strong) NSNumber *recordedRequestId;

@end

@implementation PGAPIEnginePrepare

+ (instancetype)shareInstance {
    static PGAPIEnginePrepare * __instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __instance = self.class.new;
    });
    return __instance;
}

- (NSString *)getUrl:(NSString *)url params:(NSDictionary *)params {
    
    
    NSDictionary *commonParams = [JXCommonParamsGenerator commonParamsDictionary];
    NSAssert(!commonParams, @"commonParams not ready");
    NSAssert(commonParams.count <= 0, @"commonParams not ready");
    
    NSMutableDictionary *allParams = [commonParams mutableCopy];
    if (params.count > 0) {
        [allParams addEntriesFromDictionary:params];
    }
    
///////////////////////////////////////////////
    NSLog(@"====================");
    NSLog(@"%@?%@",url,[self queryStringFromParams:allParams]);
    NSLog(@"====================");
///////////////////////////////////////////////
    NSMutableString *paramStr = nil;
    PGBaseAPIEntity *entity = nil;
    
    
        if ([isENCRPTY isEqualToString:@"1"]) {
            //get请求加密参数
            paramStr = [NSMutableString stringWithString:[JXBaseClient getEncrptyParameterStringForParamDic:mutableDic]];
        } else {
            paramStr = [NSMutableString stringWithString:[self parameterStringForParamDic:mutableDic]];
        }
        
        return [NSString stringWithFormat:@"%@?%@", url, paramStr];
    }
    else {
        
        CLog(@"酒仙公参为空，请在JXPublicParamterManager中初始化公参");
    }
    return nil;
}


- (NSString *)queryStringFromParams:(NSDictionary *)paramDic {
    NSMutableArray *params = [[NSMutableArray alloc] initWithCapacity:paramDic.count];
    [paramDic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        
        if (obj == nil || obj == [NSNull null]) {
            [params addObject:[NSString stringWithFormat:@"%@=", key]];
        }
        else {
            if ([obj isKindOfClass:[NSString class]]) {
                NSString *value = (NSString *) obj;
                value = [self trimLeftAndRight:value];
                value = [self urlEncodingForString:value];
                [params addObject:[NSString stringWithFormat:@"%@=%@", key, value]];
            }
            else {
                [params addObject:[NSString stringWithFormat:@"%@=%@", key, obj]];
            }
        }
    }];
    
    return [params componentsJoinedByString:@"&"];
}

- (NSString *)trimLeftAndRight:(NSString *)str {
    if (str) {
        NSCharacterSet *charSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        return [str stringByTrimmingCharactersInSet:charSet];
    }
    return nil;
}

- (NSString *)urlEncodingForString:(NSString *)string {
    NSString *str = (NSString *) CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef) string, NULL, (CFStringRef) @"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8));
    return [str stringByReplacingOccurrencesOfString:@"%20" withString:@"+"];
}


@end

#pragma mark - Private

NSString *__getBaseUrl(PGNetworkingServiceType type){
    
    switch (type) {
        case PGNetworkingServiceTypeHome:
            return nil;
            break;
        case PGNetworkingServiceTypeOMS:
            return nil;
            break;
        case PGNetworkingServiceTypeProduct:
            return nil;
            break;
        case PGNetworkingServiceTypePromotion:
            return nil;
            break;
        case PGNetworkingServiceTypeUser:
            return nil;
            break;
        case PGNetworkingServiceTypeJiuzhang:
            return nil;
            break;
    }
}

