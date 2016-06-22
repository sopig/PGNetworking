//
//  PGLogs.m
//  Pods
//
//  Created by 张正超 on 16/6/22.
//
//

#import "PGLogs.h"

@implementation PGLogs

+ (void)log:(NSString *)content, ...
{
#ifdef DEBUG
    if (!content) {
        return;
    }
    va_list args;
    va_start(args, content);
    NSLogv([NSString stringWithFormat:@"[sopig.cc] %@" ,content], args);
    va_end(args);
#endif
    
}
@end
