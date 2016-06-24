//
//  PGMacros.h
//  PGNetworking
//
//  Created by tolly on 16/4/6.
//  Copyright © 2016年 张正超. All rights reserved.
//

#ifndef PGMacros_h
#define PGMacros_h

#ifndef weakify
#if __has_feature(objc_arc)
#define weakify(x) autoreleasepool {} __weak __typeof__(x) __weak_ ## x ## __ = x;
#else // #if __has_feature(objc_arc)
#define weakify(x) autoreleasepool {} __block __typeof__(x) __block_ ## x ## __ = x;
#endif // #if __has_feature(objc_arc)
#endif // #ifndef	weakify

#ifndef strongify
#if __has_feature(objc_arc)
#define strongify(x) try {} @finally {} __typeof__(x) x = __weak_ ## x ## __;
#else // #if __has_feature(objc_arc)
#define strongify(x) try {} @finally {} __typeof__(x) x = __block_ ## x ## __;
#endif // #if __has_feature(objc_arc)
#endif // #ifndef	@normalize

#if __has_feature(objc_instancetype)

#undef	AS_SINGLETON
#define AS_SINGLETON

#undef	AS_SINGLETON
#define AS_SINGLETON( ... ) \
- (instancetype)sharedInstance; \
+ (instancetype)sharedInstance;

#undef	DEF_SINGLETON
#define DEF_SINGLETON \
- (instancetype)sharedInstance \
{ \
return [[self class] sharedInstance]; \
} \
+ (instancetype)sharedInstance \
{ \
static dispatch_once_t once; \
static id __singleton__; \
dispatch_once( &once, ^{ __singleton__ = [[self alloc] init]; } ); \
return __singleton__; \
}

#undef	DEF_SINGLETON
#define DEF_SINGLETON( ... ) \
- (instancetype)sharedInstance \
{ \
return [[self class] sharedInstance]; \
} \
+ (instancetype)sharedInstance \
{ \
static dispatch_once_t once; \
static id __singleton__; \
dispatch_once( &once, ^{ __singleton__ = [[self alloc] init]; } ); \
return __singleton__; \
}

#else	// #if __has_feature(objc_instancetype)

#undef	AS_SINGLETON
#define AS_SINGLETON( __class ) \
- (__class *)sharedInstance; \
+ (__class *)sharedInstance;

#undef	DEF_SINGLETON
#define DEF_SINGLETON( __class ) \
- (__class *)sharedInstance \
{ \
return [__class sharedInstance]; \
} \
+ (__class *)sharedInstance \
{ \
static dispatch_once_t once; \
static __class * __singleton__; \
dispatch_once( &once, ^{ __singleton__ = [[[self class] alloc] init]; } ); \
return __singleton__; \
}

#endif	// #if __has_feature(objc_instancetype)

#undef	DEF_SINGLETON_AUTOLOAD
#define DEF_SINGLETON_AUTOLOAD( __class ) \
DEF_SINGLETON( __class ) \
+ (void)load \
{ \
[self sharedInstance]; \
}


#define APILog(__apiResponse) NSLog(@"\n======sopig.cc start========\n[requestID] %@\n[URI] %@\n[requestParams] %@\n[RequestHeaderFields] %@\n[MIMEType] %@\n[ResponseHeaderFields] %@\n[contentString] %@\n[errorReason] %@\n======sopig.cc end=========\n",\
      __apiResponse.task.taskDescription,\
      [NSString stringWithFormat:@"%@://%@%@",__apiResponse.request.URL.scheme,__apiResponse.request.URL.host,__apiResponse.request.URL.path],\
      __apiResponse.requestParams, \
      __apiResponse.request.allHTTPHeaderFields,\
      __apiResponse.response.MIMEType,\
      __apiResponse.response.allHeaderFields,\
      __apiResponse.contentString,\
      __apiResponse.error.localizedFailureReason);


#define JX_DEFAULTS [NSUserDefaults standardUserDefaults]


#endif /* PGMacros_h */
