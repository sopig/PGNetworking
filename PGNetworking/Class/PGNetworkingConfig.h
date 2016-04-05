//
//  PGNetworkingConfig.h
//  PGNetworking
//
//  Created by 张正超 on 16/4/5.
//  Copyright © 2016年 张正超. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PGNetworkingProtocol.h"

@interface PGNetworkingConfig : NSObject

@property (nonatomic, strong) NSObject<PGCommonParamsGenerator> *commonParamsGenerator;

@end
