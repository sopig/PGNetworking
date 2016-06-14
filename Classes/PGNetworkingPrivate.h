//
//  PGNetworkingPrivate.h
//  Pods
//
//  Created by 张正超 on 16/6/14.
//
//

#import <Foundation/Foundation.h>

@interface PGNetworkingPrivate : NSObject

+ (BOOL)checkJson:(id)json;

+ (BOOL)checkJson:(id)json withValidator:(id)validatorJson ;

@end
