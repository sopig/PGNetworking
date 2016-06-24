//
//  PGLogs.m
//  Pods
//
//  Created by 张正超 on 16/6/22.
//
//

#import "PGLogs.h"
#import <asl.h>

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

+ (void)fetchLog {
    asl_object_t query = asl_new(ASL_TYPE_QUERY);
    NSString *pid = @([[NSProcessInfo processInfo] processIdentifier]).stringValue;
    if (!pid) return;
    asl_set_query(query, ASL_KEY_PID, [pid UTF8String], ASL_QUERY_OP_EQUAL);
    
    aslresponse response = asl_search(NULL, query);
    aslmsg aslMessage = NULL;
    
    NSMutableArray * logs = [NSMutableArray array];
    
    while (true) {
        aslMessage = asl_next(response);
        if (!aslMessage) break;
        const char *value = asl_get(aslMessage, ASL_KEY_MSG);
        if (value) {
            NSLog(@"ASL ===>  %@",@(value));
        }
        
    
    }
    
}
@end



