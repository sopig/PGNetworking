//
//  PGBaseAPIManager.h
//  PGNetworking
//
//  Created by tolly on 16/4/5.
//  Copyright © 2016年 张正超. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PGNetworking.h"

@interface PGBaseAPIEntity : NSObject

@property (nonatomic, weak, nullable) id<PGAPIResponseDelegate> delegate;
@property (nonatomic, weak, nullable) id<PGAPIParamsDataSource> paramSource;
@property (nonatomic, weak, nullable) id<PGAPIValidator> validator;
@property (nonatomic, weak, nullable) NSObject<PGAPIEntity> *child;
@property (nonatomic, weak, nullable) id<PGApiInterceptor> interceptor;

@property (nonatomic, copy, readonly) NSString *_Nonnull errorMessage;
@property (nonatomic, readonly) PGAPIEntityErrorType errorType;

@property (nonatomic, assign, readonly) BOOL isReachable;
@property (nonatomic, assign, readonly) BOOL isLoading;

- (id _Nullable)fetchDataWithReformer:(id<PGAPIResponseDataReformer> _Nullable)reformer;

//尽量使用loadData这个方法,这个方法会通过param source来获得参数，这使得参数的生成逻辑位于controller中的固定位置
- (NSInteger)loadData;

- (void)cancelAllRequests;
- (void)cancelRequestWithRequestId:(NSInteger)requestID;

// 拦截器方法，继承之后需要调用一下super
//- (void)beforePerformSuccessWithResponse:(AIFURLResponse *)response;
//- (void)afterPerformSuccessWithResponse:(AIFURLResponse *)response;
//
//- (void)beforePerformFailWithResponse:(AIFURLResponse *)response;
//- (void)afterPerformFailWithResponse:(AIFURLResponse *)response;
//
//- (BOOL)shouldCallAPIWithParams:(NSDictionary *)params;
//- (void)afterCallingAPIWithParams:(NSDictionary *)params;

/*
 用于给继承的类做重载，在调用API之前额外添加一些参数,但不应该在这个函数里面修改已有的参数。
 子类中覆盖这个函数的时候就不需要调用[super reformParams:params]了
 RTAPIBaseManager会先调用这个函数，然后才会调用到 id<RTAPIManagerValidator> 中的 manager:isCorrectWithParamsData:
 所以这里返回的参数字典还是会被后面的验证函数去验证的。
 
 假设同一个翻页Manager，ManagerA的paramSource提供page_size=15参数，ManagerB的paramSource提供page_size=2参数
 如果在这个函数里面将page_size改成10，那么最终调用API的时候，page_size就变成10了。然而外面却觉察不到这一点，因此这个函数要慎用。
 
 这个函数的适用场景：
 当两类数据走的是同一个API时，为了避免不必要的判断，我们将这一个API当作两个API来处理。
 那么在传递参数要求不同的返回时，可以在这里给返回参数指定类型。
 
 具体请参考AJKHDXFLoupanCategoryRecommendSamePriceAPIManager和AJKHDXFLoupanCategoryRecommendSameAreaAPIManager
 
 */
- (NSDictionary *)reformParams:(NSDictionary *)params;
- (void)cleanData;
- (BOOL)shouldCache;




- (nullable NSURLSessionDataTask *)get;



@end
