//
//  JXCommonParamsGenerator.m
//  PGNetworking
//
//  Created by 张正超 on 16/4/5.
//  Copyright © 2016年 张正超. All rights reserved.
//

#import "JXCommonParamsGenerator.h"
#import "JXAppContext.h"

#define saveNil(obj) if (!obj)\
         obj = @"";

static id _context = nil;

@implementation JXCommonParamsGenerator

+ (NSObject<PGCommonParams> *)appContext {
   if (!_context) {
       Class Context = NSClassFromString(@"AppContext");
       if (Context) {
           return _context = [Context new];
       }
       else {
           return _context = [JXAppContext new];
       }
   } else {
       return _context;
   }
    

    

}

+ (NSDictionary *)commonParamsDictionary {
    
    NSObject<PGCommonParams> *context = [self appContext];
    
    return [context commonParams];
}

@end
