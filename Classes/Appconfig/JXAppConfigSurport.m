//
//  JXAppConfigSurport.m
//  jiuxian
//
//  Created by 张正超 on 15/12/4.
//  Copyright © 2015年 jiuxian.com. All rights reserved.
//

#import "JXAppconfigPlist.h"
#import "JXAppConfigSurport.h"

NSString *const JXHOSTDOMAIN = @"com.jiuxian.hostDomain";

@interface JXAppConfigSurport ()

@property(nonnull, nonatomic, strong) NSDictionary *config_developer;
@property(nonnull, nonatomic, strong) NSDictionary *config_qa;
@property(nonnull, nonatomic, strong) NSDictionary *config_gray;
@property(nonnull, nonatomic, strong) NSDictionary *config_online;
@property(nonnull, nonatomic, strong) NSDictionary *config_test;
@property(nonnull, nonatomic, strong) NSDictionary *config_reserve;

@end

@implementation JXAppConfigSurport

+ (instancetype)surport {
    static JXAppConfigSurport *__ConfigSurport = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __ConfigSurport = [[self class] new];
    });
    return __ConfigSurport;

}

- (NSDictionary *)config_qa {
    if (!_config_qa) {
        _config_qa = [NSDictionary dictionaryWithContentsOfFile:[JXAppconfigPlist loadPlists][0]][@"server_qa"];
    }
    return _config_qa;
}

- (NSDictionary *)config_developer {
    if (!_config_developer) {
        _config_developer = [NSDictionary dictionaryWithContentsOfFile:[JXAppconfigPlist loadPlists][0]][@"server_developer"];
    }
    return _config_developer;
}

- (NSDictionary *)config_gray {
    if (!_config_gray) {
        _config_gray = [NSDictionary dictionaryWithContentsOfFile:[JXAppconfigPlist loadPlists][0]][@"server_gray"];
    }

    return _config_gray;
}

- (NSDictionary *)config_online {
    if (!_config_online) {
        _config_online = [NSDictionary dictionaryWithContentsOfFile:[JXAppconfigPlist loadPlists][0]][@"server_online"];
    }
    return _config_online;
}

- (NSDictionary *)config_test {
    if (!_config_test) {
        _config_test = [NSDictionary dictionaryWithContentsOfFile:[JXAppconfigPlist loadPlists][0]][@"server_testApphome"];
    }

    return _config_test;
}

- (NSDictionary *)config_reserve {
    if (!_config_reserve) {
        _config_reserve = [NSDictionary dictionaryWithContentsOfFile:[JXAppconfigPlist loadPlists][0]][@"server_reserve"];
    }
    return _config_reserve;
}


- (void)setDefaultHostDomain {
    if (![[NSUserDefaults standardUserDefaults] valueForKey:JXHOSTDOMAIN]) {
        [[NSUserDefaults standardUserDefaults] setValue:@(JXAPISERVICE_ONLINE) forKey:JXHOSTDOMAIN];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}


- (nonnull NSDictionary *)getServerWithType:(JXAPISERVICETYPE)type {
    switch (type) {
        case JXAPISERVICE_developer: {

            return self.config_developer;

        }
            break;
        case JXAPISERVICE_qa: {
            return self.config_qa;

        }
            break;
        case JXAPISERVICE_GRAY: {
            return self.config_gray;

        }
            break;
        case JXAPISERVICE_ONLINE: {
            return self.config_online;

        }
            break;
        case JXAPISERVICE_TEST: {
            return self.config_test;

        }
            
        case JXAPISERVICE_reserve: {
            return self.config_reserve;
            
        }
            break;
    }

    return nil;
}

- (NSString *)urlStringFromSurport:(NSString *)sKey {

    return [self getServerWithType:[[NSUserDefaults standardUserDefaults] integerForKey:JXHOSTDOMAIN]][sKey];

}

@end
