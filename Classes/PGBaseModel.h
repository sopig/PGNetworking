//
//  PGBaseModel.h
//  Pods
//
//  Created by 张正超 on 16/4/14.
//
//

#import <Foundation/Foundation.h>


@interface PGBaseModel : NSObject

@property (nonatomic , strong) NSString *errCode;
@property (nonatomic , strong) NSString *errMsg;
@property (nonatomic , strong) NSDictionary *result;
@property (nonatomic , strong) NSString *success;
@property (nonatomic , strong) NSString *toast;

@end
