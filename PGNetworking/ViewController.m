//
//  ViewController.m
//  PGNetworking
//
//  Created by 张正超 on 16/4/5.
//  Copyright © 2016年 张正超. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveCocoa.h>

#import "PGBaseAPIEntity.h"
#import "PGNetworkingReachability.h"
#import "NSString+urlEncoding.h"

#import "PGAPIEngine.h"

#import "APIRegion.h"
#import "APIBestPay.h"
#import "APIFunctionSwitch.h"
//#import <FLEXManager.h>

#import "PGBaseModel.h"
#import "regionModel.h"
#import <lib.h>

#import "PGLogs.h"

@interface ViewController ()

@property (strong,nonatomic, nullable) NSMutableDictionary *commonParams;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
   
//    APIRegion *region = [APIRegion new];
//   [region paramsForApiWithParams:^NSDictionary *{
//       return @{@"xx":@"123"};
//   }];
//    region.whenSuccess = ^(__kindof PGBaseAPIEntity *api){
//        
//        regionModel *m = [api fetchDataWithReformer:api];
//        
//        NSLog(@"%@",[m class]);
// 
//    };
//    region.whenFail = ^(__kindof PGBaseAPIEntity *api){
//        NSLog(@"%@",api);
//    };
//    [region send];
//    
//
//    APIBestPay *pay = [APIBestPay new];
//    
//    pay.whenSuccess = ^(__kindof PGBaseAPIEntity *api){
//        NSLog(@"==> %@",[api fetchData]);
//        
//    };
//    
////    [pay send];
//    
//    APIFunctionSwitch *switchxx = [APIFunctionSwitch new];
//    switchxx .whenSuccess = ^(__kindof PGBaseAPIEntity *api){
//        NSLog(@"==> %@",[api fetchData]);
//    };
//    
//    [switchxx send];

    
    [[[[APIRegion new] paramsForApiWithParams:^NSDictionary *{
        _commonParams = [NSMutableDictionary dictionary];
        NSString *screenReslolutionStr = [NSString stringWithFormat:@"%.2fx%.2f", [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height];
        
        //设备型号
        NSString *equipmentType = @"iPhone";
        
        
        //服务器版本号
        [_commonParams setObject:@"1.0" forKey:@"apiVersion"];
        ////版本号
        [_commonParams setObject:@"6.3.0" forKey:@"appVersion"];
        //设备类型
        [_commonParams setObject:@"IPHONE" forKey:@"deviceType"];
        //渠道编号
        [_commonParams setObject:@"appstore" forKey:@"cpsId"];
        //屏幕分辨率
        [_commonParams setObject:screenReslolutionStr forKey:@"screenReslolution"];
        //设备的型号 iPhone6
        [_commonParams setObject:equipmentType forKey:@"equipmentType"];
        //系统版本 ios8.2
        [_commonParams setObject:@"9.2" forKey:@"sysVersion"];
        //设备的唯一标示
        [_commonParams setObject:@"122131231231" forKey:@"appKey"];

        
        //设备支持webp
        

        [_commonParams setObject:@"1" forKey:@"supportWebp"];
 
        
        //区域 areaId 不能为空 如果为空了 默认的为北京   token 这个不能为空

        [_commonParams setObject:@"    " forKey:@"token"];//未登录的标示

        [_commonParams setObject:@"500" forKey:@"areaId"];

        
        //pushtoken 为空不传

        
        //消息推送渠道有哪些，0,1
        NSString *channelCode = @"0,1";
        [_commonParams setValue:channelCode forKey:@"channelCode"];
        
        return [_commonParams copy];
    }] sendSignal] subscribeNext:^(APIRegion *x) {
//        NSLog(@"%@",[x fetchData]);
    }];
    
    
    [PGLogs log:@"hello %@",@"world"];
    [PGLogs log:@"hello %@",@"world"];
    [PGLogs log:@"hello %@",@"world"];
    [PGLogs log:@"hello %@",@"world"];
    [PGLogs log:@"hello %@",@"world"];

    
    [[PGLogs fetchLog] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PGASLMessage *msg = obj;
        [msg showDescription];
    }];
    
   
}

- (void)handleTestClick{
    ViewController *vc = [[ViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dealloc{

}

@end
