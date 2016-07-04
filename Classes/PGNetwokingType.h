//
//  PGNetwokingType.h
//  PGNetworking
//
//  Created by tolly on 16/4/5.
//  Copyright © 2016年 张正超. All rights reserved.
//

#ifndef PGNetwokingType_h
#define PGNetwokingType_h

/////////////////////////////////////////////////////////////////////
typedef NS_ENUM (NSUInteger, PGNetworkingServiceType){
    PGNetworkingServiceTypeHome,
    PGNetworkingServiceTypeOMS,
    PGNetworkingServiceTypeProduct,
    PGNetworkingServiceTypeUser,
    PGNetworkingServiceTypeJiuzhang,
    
    PGNetworkingServiceTypePromotion,
    PGNetworkingServiceTypePay = PGNetworkingServiceTypePromotion,
    
    PGNetworkingServiceTypeFORUM,
    PGNetworkingServiceTypeCOMMENT
    
};


//不用bool值是为了以后方便扩展
typedef NS_ENUM (NSUInteger, PGNetworkingEncryptionType){
    PGNetworkingEncryptionTypeNotUse,
    PGNetworkingEncryptionTypeUse
};



//////////////////////////////////////////////////////////////////
typedef NS_ENUM (NSUInteger, PGAPIEntityResponseType){
    PGAPIEntityResponseTypeDefault = 0,       //API还没有起飞，默认
    PGAPIEntityResponseTypeSuccess,       //API请求成功且返回数据正确，
    PGAPIEntityResponseTypeNoContent,     //API请求成功但返回数据不正确。
    PGAPIEntityResponseTypeParamsError,    //参数是错误的
    PGAPIEntityResponseTypeTimeout,       //请求超时。
    PGAPIEntityResponseTypeNOJsonObject,  //
    PGAPIEntityResponseTypeErrDetail,     //
    PGAPIEntityResponseTypeNoNetWork      //网络不通。
};


//////////////////////////////////////////////////////////////////
typedef NS_ENUM (NSUInteger, PGAPIEntityRequestType){
    PGAPIEntityRequestTypeGet,
    PGAPIEntityRequestTypePost
};

//////////////////////////////////////////////////////////////////


#endif /* PGNetwokingType_h */
