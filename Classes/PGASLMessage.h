//
//  PGASLMessage.h
//  Pods
//
//  Created by 张正超 on 16/6/27.
//
//

#import <Foundation/Foundation.h>
#import <asl.h>

@interface PGASLMessage : NSObject

@property (nonatomic , nullable , copy) NSString *ASL_TIME;
@property (nonatomic , nullable , copy) NSString *ASL_SENDER;
@property (nonatomic , nullable , copy) NSString *ASL_MSG_ID;
@property (nonatomic , nullable , copy) NSString *ASL_LEVEL;
@property (nonatomic , nullable , copy) NSString *ASL_HOST;
@property (nonatomic , nullable , copy) NSString *ASL_MSG;


- (nonnull instancetype)initWithASL:(nonnull aslmsg)aslmsg;

- (void)showDescription;

@end
