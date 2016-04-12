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
   
    
    [[APIRegion new] loadData];
    
    
    
    return;
    
    
    
    
//    http://sopig.cn/2016/03/02/CI%E6%90%AD%E5%BB%BA%E5%92%8C%E8%84%9A%E6%9C%AC%E8%87%AA%E5%8A%A8%E5%8C%96/
    
    NSLog(@"%@",[@"http://sopig.cn/2016/03/02/CI%E6%90%AD%E5%BB%BA%E5%92%8C%E8%84%9A%E6%9C%AC%E8%87%AA%E5%8A%A8%E5%8C%96/" urlDecoding]);
    
    
    NSString *encod = [@"http://sopig.cn/2016/03/02/CI搭建和脚本自动化/" urlEncoding];
    
    NSLog(@"%@",encod);
    
    
    UIWebView *webv = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [webv loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com"]]];
    [self.view addSubview:webv];
    
    
    return;
    
    @weakify(self);
    [[PGNetworkingReachability openNetworkCheck] subscribeNext:^(NSNotification* x) {
        @strongify(self);
        
        NSLog(@"%@",x.userInfo[@"AFNetworkingReachabilityNotificationStatusItem"]);
        
    }];
    
    
    
    RACSignal *siganl = [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        // block调用时刻：每当有订阅者订阅信号，就会调用block。
        
        // 2.发送信号
        [subscriber sendNext:@1];
         [subscriber sendNext:@2];
         [subscriber sendNext:@3];
        
        // 如果不在发送数据，最好发送信号完成，内部会自动调用[RACDisposable disposable]取消订阅信号。
        [subscriber sendCompleted];
        
        return [RACDisposable disposableWithBlock:^{
            
            // block调用时刻：当信号发送完成或者发送错误，就会自动执行这个block,取消订阅信号。
            
            // 执行完Block后，当前信号就不在被订阅了。
            
            NSLog(@"信号被销毁");
            
        }];
    }] replayLazily];
    
    // 3.订阅信号,才会激活信号.
    [siganl subscribeNext:^(id x) {
        // block调用时刻：每当有信号发出数据，就会调用block.
        NSLog(@"接收到数据1:%@",x);
    }];
    
    [siganl subscribeNext:^(id x) {
        // block调用时刻：每当有信号发出数据，就会调用block.
        NSLog(@"接收到数据2:%@",x);
    }];
    
    [siganl subscribeNext:^(id x) {
        // block调用时刻：每当有信号发出数据，就会调用block.
        NSLog(@"接收到数据3:%@",x);
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
