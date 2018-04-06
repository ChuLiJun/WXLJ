//
//  ViewController.m
//  wxPayDemo
//
//  Created by keji shengui on 2018/4/6.
//  Copyright © 2018年 kejishengui. All rights reserved.
//

#import "ViewController.h"
#import "WXApi.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /*
     第一步   导入 SDK     pod 'WechatOpenSDK'
     第二步   配置白名单    LSApplicationQueriesSchemes
     第三步   配置URL schemes   wx251d0396a1ab***  //微信开放平台获取
     第四步。  appDelegate.m 导入头文件 遵循代理 设置回调和通知监听 回调结果
    
    */
    
    self.view.backgroundColor =[UIColor whiteColor];
    UIButton *btn =[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 100, 100);
    btn.center =self.view.center;
    btn.layer.cornerRadius =10;
    btn.layer.masksToBounds =YES;
    btn.backgroundColor =[UIColor purpleColor];
    [btn setTitle:@"点击支付" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
}

-(void)btnClick:(UIButton*)button{
    
    NSLog(@"点击了支付按钮");
    if([WXApi isWXAppInstalled]){
        // 监听一个通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getOrderPayResult:) name:@"WXPay" object:nil];
        [self wxpayRequest];
    }else{
        [self alertShowWxpayResoult];
    }
    
    
}
-(void)wxpayRequest{
    
   
    
    PayReq *request = [[PayReq alloc] init];
    request.partnerId = @"1491180982";
    request.prepayId= @"wx06213524871559ea7697f9dc3524188023";
    request.package = @"Sign=WXPay";
    request.nonceStr= @"JOXFbaB5PHqAWdFb";
#warning Mark 特别注意 这里的时间戳 如果你传递的格式不对 就会一直报签名认证失败
    request.timeStamp= [[NSString stringWithFormat:@"1523021724"]intValue];
    request.sign= @"9576856176CB27B1CCAD36CFF23F882E";
    [WXApi sendReq:request];
}

#pragma mark - 收到支付成功的消息后作相应的处理
- (void)getOrderPayResult:(NSNotification *)notification
{
    if ([notification.object isEqualToString:@"success"]) {
        NSLog(@"支付成功");
        
    } else if([notification.object isEqualToString:@"cancel"]){
        NSLog(@"取消支付");
        
    }else{
        
        NSLog(@"支付失败");
    }
}

//未安装微信 提示框
-(void)alertShowWxpayResoult{
    // 1.创建UIAlertController
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示"
                                                                             message:@"未安装微信!"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        
    }];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"OK Action");
        
    }];
    [alertController addAction:cancelAction];    // A
    [alertController addAction:okAction];    // B
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
