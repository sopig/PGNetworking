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

@interface ViewController ()

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

    
    [[[APIRegion new] sendSignal] subscribeNext:^(APIRegion *x) {
        NSLog(@"%@",[x fetchData]);
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
