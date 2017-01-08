//
//  AppDelegate.m
//  WUO
//
//  Created by mofeini on 17/1/1.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

#import "AppDelegate.h"
#import "MainTabBarController.h"
#import "XYLaunchPlayerController.h"
#import "XYCustomNavController.h"
#import "WUOHTTPRequest.h"
#import "Reachability.h"

@interface AppDelegate () {
    Reachability *_reachability;
    XYNetworkState _previousState; // 上一次网络状态
}

@property (nonatomic, strong) MainTabBarController *mainVc;
@property (nonatomic, strong) XYCustomNavController *customNav;

@end

@implementation AppDelegate

@synthesize isLogin = _isLogin;

- (MainTabBarController *)mainVc {
    if (_mainVc == nil) {
        _mainVc = [MainTabBarController new];
    }
    return _mainVc;
}

- (XYCustomNavController *)customNav {
    if (_customNav == nil) {
        XYLaunchPlayerController *playerVc = [XYLaunchPlayerController new];
        _customNav = [[XYCustomNavController alloc] initWithRootViewController:playerVc];
    }
    
    return _customNav;
}

- (BOOL)isLogin {
    
    id loginCode = [[NSUserDefaults standardUserDefaults] objectForKey:XYUserLoginStatuKey];
    
    if (loginCode == nil) {
        return NO;
    }
    if ([loginCode integerValue] == 0) {
        _isLogin = YES;
    } else if ([loginCode integerValue] == -2) {
        _isLogin = NO;
    }
    return _isLogin;
}

- (void)setIsLogin:(BOOL)isLogin {
    _isLogin = isLogin;
    
    if (isLogin) {
        
        self.window.rootViewController = self.mainVc;
        [self.customNav.view removeFromSuperview];
        self.customNav = nil;
    } else {
        
        self.window.rootViewController = self.customNav;
        [self.mainVc.view removeFromSuperview];
        self.mainVc = nil;
    }
    
}


- (UIViewController *)getRootVc {
    
    if (self.isLogin) {
        
         return self.mainVc;
    } else {
        
        return self.customNav;
    }
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [self getRootVc];
    [self.window makeKeyAndVisible];
    [self checkNetworkState];
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    
    
    id loginCode = [[NSUserDefaults standardUserDefaults] objectForKey:XYUserLoginStatuKey];
    if (loginCode == nil) {
        // 第一次登陆
        return;
    }
    [WUOHTTPRequest setActivityIndicator:YES];
    [WUOHTTPRequest dynamicWithIdstamp:@"" type:1 serachLabel:@"" finished:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        [WUOHTTPRequest setActivityIndicator:NO];
        NSInteger code = [responseObject[@"code"] integerValue];;
        NSInteger codeDB = [loginCode integerValue];
        if (code == codeDB ) {
            return;
        }
        if (code == -2) {
            
            [self showInfo:[NSString stringWithFormat:@"您的账号已于%@在其他设备上登录，如果不是您的操作，您的密码可能已经泄露，请立刻重新登录后修改密码", @"(刚刚)"]];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                // 用户没有登录
                self.isLogin = NO;
            });
            
            [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"code"] forKey:XYUserLoginStatuKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
    }];
    
}

- (void)checkNetworkState {
    
    // 监听网络状态发生改变的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkChange) name:kReachabilityChangedNotification object:nil];
    _reachability = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    [_reachability startNotifier];
}

- (void)networkChange {
    
    NSString *tip = nil;
    
    // 获取当前网络状态
    XYNetworkState currentState = [XYNetworkRequest currnetNetworkState];
    if (currentState == _previousState) return;
    
    _previousState = currentState;
    
    switch (currentState) {
        case XYNetworkStateNone:
            tip = @"请检查网络状况";
            break;
        case XYNetworkState2G:
            tip = @"已切换到2G网络";
            break;
        case XYNetworkState3G:
            tip = @"已切换到3G网络";
            break;
        case XYNetworkState4G:
            tip = @"已切换到4G网络";
            break;
        case XYNetworkStateWIFI:
            tip = nil;
            break;
            
        default:
            break;
    }
    
    if (tip.length) {
        [self xy_showMessage:tip];
    }
}

@end
