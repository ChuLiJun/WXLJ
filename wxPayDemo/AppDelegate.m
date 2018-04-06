//
//  AppDelegate.m
//  wxPayDemo
//
//  Created by keji shengui on 2018/4/6.
//  Copyright © 2018年 kejishengui. All rights reserved.
//

#import "AppDelegate.h"
#import "WXApi.h"     //导入微信头文件
@interface AppDelegate ()<WXApiDelegate>    //遵循代理方法

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //这里需要换成 自己app 在微信开放平台申请的appID 注意 这里的appID 对应的bunlde ID 一定要和微信开放平台的一致
    
    [WXApi registerApp:@"wxasdmmmvme123"]; //注册微信 如果你的工程中导入了友盟分享 建议在友盟之后注册
    return YES;
}

// 支持所有iOS系统
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    //    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    //    if (!result) {
    // 其他如支付等SDK的回调。 注释掉的部分为添加友盟分享之后 ，两种回调的书写方式
    BOOL  result = [WXApi handleOpenURL:url delegate:(id<WXApiDelegate>)self];
    //}
    return result;
    
}
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options
{
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    //    BOOL result = [[UMSocialManager defaultManager]  handleOpenURL:url options:options];
    //    if (!result) {
    // 其他如支付等SDK的回调
    BOOL   result = [WXApi handleOpenURL:url delegate:(id<WXApiDelegate>)self];
    //  }
    return result;
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    //    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    //    if (!result) {
    // 其他如支付等SDK的回调
    BOOL  result = [WXApi handleOpenURL:url delegate:(id<WXApiDelegate>)self];
    //}
    return result;
}

#pragma mark 微信回调方法
- (void)onResp:(BaseResp *)resp
{
    NSString * strMsg = [NSString stringWithFormat:@"errorCode: %d",resp.errCode];
    NSLog(@"strMsg: %@",strMsg);
    
    NSString * errStr       = [NSString stringWithFormat:@"errStr: %@",resp.errStr];
    NSLog(@"errStr: %@",errStr);
    
    
    NSString * strTitle;
    //判断是微信消息的回调
    if ([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        strTitle = [NSString stringWithFormat:@"发送媒体消息的结果"];
    }
    
    
    NSString * wxPayResult;
    //判断是否是微信支付回调 (注意是PayResp 而不是PayReq)
    if ([resp isKindOfClass:[PayResp class]])
    {
        //支付返回的结果, 实际支付结果需要去微信服务器端查询
        
        strTitle = [NSString stringWithFormat:@"支付结果"];
        
        switch (resp.errCode)
        {
            case WXSuccess:
            {
                strMsg = @"支付结果:";
                NSLog(@"支付成功: %d",resp.errCode);
                
                wxPayResult = @"success";
                break;
            }
            case WXErrCodeUserCancel:
            {
                strMsg = @"用户取消了支付";
                NSLog(@"用户取消支付: %d",resp.errCode);
                wxPayResult = @"cancel";
                break;
            }
            default:
            {
                strMsg = [NSString stringWithFormat:@"支付失败! code: %d  errorStr: %@",resp.errCode,resp.errStr];
                NSLog(@":支付失败: code: %d str: %@",resp.errCode,resp.errStr);
                wxPayResult = @"faile";
                break;
            }
        }
        
        //发出通知
        NSNotification * notification = [NSNotification notificationWithName:@"WXPay" object:wxPayResult];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    }
}




- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
