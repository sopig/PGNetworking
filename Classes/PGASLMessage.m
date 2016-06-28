//
//  PGASLMessage.m
//  Pods
//
//  Created by 张正超 on 16/6/27.
//
//

#import "PGASLMessage.h"
#import "PGLogs.h"

@implementation PGASLMessage

- (instancetype)initWithASL:(aslmsg)aslmsg{
    if (self = [super init]) {
        NSString *time = [self getASLValue:aslmsg key:ASL_KEY_TIME];
        NSString *sender = [self getASLValue:aslmsg key:ASL_KEY_SENDER];
        NSString *msgID = [self getASLValue:aslmsg key:ASL_KEY_MSG_ID];
        NSString *level = [self getASLValue:aslmsg key:ASL_KEY_LEVEL];
        NSString *host = [self getASLValue:aslmsg key:ASL_KEY_HOST];
        NSString *msg = [self getASLValue:aslmsg key:ASL_KEY_MSG];
        
        _ASL_TIME = time;
        _ASL_SENDER = sender;
        _ASL_MSG_ID = msgID;
        _ASL_LEVEL = level;
        _ASL_HOST = host;
        _ASL_MSG = msg;
 
    }
    
    return self;
}


- (NSString *)getASLValue:(aslmsg)asl key:(const char *)key {
    const char * value = asl_get(asl,key);
    if (value) {
        return [@(value) copy];
    }
    
    return nil;
}

- (NSString *)description{
    return [[NSString stringWithFormat:@"[%@]-[%@]-[%@]-[%@]: %@",[self formatDate:self.ASL_TIME.integerValue] ,self.ASL_SENDER,self.ASL_LEVEL,self.ASL_HOST,self.ASL_MSG] copy];
}


- (void)showDescription{
    
    [PGLogs log:@"[%@]-[%@]-[%@]-[%@]: %@",[self formatDate:self.ASL_TIME.integerValue] ,self.ASL_SENDER,self.ASL_LEVEL,self.ASL_HOST,self.ASL_MSG];
    
}


- (NSString *)formatDate:(NSTimeInterval)time {
    NSDateFormatter *format  = [NSDateFormatter new];
    [format setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
    [format setTimeZone:[NSTimeZone systemTimeZone]];
    
    return [format stringFromDate:[NSDate dateWithTimeIntervalSince1970:time]];
}

@end
