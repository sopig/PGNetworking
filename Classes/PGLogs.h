//
//  PGLogs.h
//  Pods
//
//  Created by 张正超 on 16/6/22.
//
//

#import <Foundation/Foundation.h>
#import "PGASLMessage.h"

FOUNDATION_EXPORT NSString *const PGLogEnable;

@interface PGLogs : NSObject

+ (void)log:(NSString *)content, ... ;

+ (NSMutableArray *)fetchLog;


@end
