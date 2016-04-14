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

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
   
    
//    APIRegion *region = [APIRegion new];
//    region.whenSuccess = ^(__kindof PGBaseAPIEntity *api){
//        NSLog(@"%@",api);
//    };
//    region.whenFail = ^(__kindof PGBaseAPIEntity *api){
//        NSLog(@"%@",api);
//    };
//    [region send];
    
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(100, 100, 100, 100);
    [button setTitle:@"11" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(handleTestClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    [[[APIRegion new] sendSignal] subscribeNext:^(id x) {
        NSLog(@"%@",x);
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
