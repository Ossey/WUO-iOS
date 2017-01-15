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



@interface AppDelegate () <EMClientDelegate>

@property (nonatomic, strong) MainTabBarController *mainVc;
@property (nonatomic, strong) XYCustomNavController *customNav;

@end

@implementation AppDelegate {
    Reachability *_reachability;
    XYNetworkState _previousState; // 上一次网络状态
}

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
        // 当用户登录app账号成功时，登录环信账号
        [self loginImUserAccount];
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
    [[EMClient sharedClient] addDelegate:self delegateQueue:nil];
    
    [self checkImStatus];
    
    return YES;
}


// 检测用户IM登录状态，如果未登录，就登录
- (void)checkImStatus {

    BOOL isLogin =  [[EMClient sharedClient] isLoggedIn];
    if (isLogin) {
        NSLog(@"用户IM已经登录成功");
    } else {
        NSLog(@"用户IM未登录");
        [self loginImUserAccount];
    }
}

// app进入后台时调用
- (void)applicationDidEnterBackground:(UIApplication *)application {

    // 程序进入后台时，需要调用此方法断开连接
    [[EMClient sharedClient] applicationDidEnterBackground:application];
}

// app将要从后台返回时
- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    // 程序进入前台时，需要调用此方法进行重连
    [[EMClient sharedClient] applicationWillEnterForeground:application];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    
    
    id loginCode = [[NSUserDefaults standardUserDefaults] objectForKey:XYUserLoginStatuKey];
    if (loginCode == nil) {
        // 第一次登陆
        return;
    }
    [WUOHTTPRequest setActivityIndicator:YES];
    [WUOHTTPRequest topicWithIdstamp:@"" type:1 serachLabel:@"" finished:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        [WUOHTTPRequest setActivityIndicator:NO];
        NSInteger code = [responseObject[@"code"] integerValue];;
        NSInteger codeDB = [loginCode integerValue];
        if (code == codeDB ) {
            return;
        }
        
        // 检测登录状态
        [WUOHTTPRequest  checkLoginStatusFromResponseCode:code];
                
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

- (XYLoginInfoItem *)currentloginInfo {
    if (_currentloginInfo == nil) {
        // 读取用户登录后存储的登录信息
        NSDictionary *loginInfo  = [NSDictionary dictionaryWithContentsOfFile:kLoginInfoPath];
        _currentloginInfo = [XYLoginInfoItem loginInfoItemWithDict:loginInfo];

    }
    return _currentloginInfo;
}

#pragma mark - IM 相关
- (void)loginImUserAccount {
    
    
    
    // EMOptions设置配置信息 AppKey:注册的AppKey。
    EMOptions *options = [EMOptions optionsWithAppkey:@"wuwo#ziwo"];
    //apnsCertName:推送证书名（不需要加后缀）
    options.apnsCertName = @"MeSelf_APNS_DistriBution";
    // 初始化SDK
    EMError *error = [[EMClient sharedClient] initializeSDKWithOptions:options];
    if (!error) {
        NSLog(@"初始化成功");
    }
    
    // 登录前判断是否自动登录
    BOOL isAutoLogin = [EMClient sharedClient].options.isAutoLogin;
    if (!isAutoLogin) {
        // 当不是自动登录，就使用用户登录成功后，WUO公司服务端返回imUser账号登录环信
        error = [[EMClient sharedClient] loginWithUsername:self.currentloginInfo.imUser.username password:self.currentloginInfo.imUser.password];
        if (!error) {
            NSLog(@"登录成功");
            // 设置自动登录
            [[EMClient sharedClient].options setIsAutoLogin:YES];
        } else {
            NSLog(@"登录失败-%@", error.errorDescription);
        }
        
    }
    
}

#pragma mark - EMClientDelegate
/*!
 *  自动登录返回结果
 */
- (void)didAutoLoginWithError:(EMError *)aError {
    NSLog(@"%@", aError);
}

/*!
 *  SDK连接服务器的状态变化时会接收到该回调
 *
 *  有以下几种情况, 会引起该方法的调用:
 *  1. 登录成功后, 手机无法上网时, 会调用该回调
 *  2. 登录成功后, 网络状态变化时, 会调用该回调
 */
- (void)connectionStateDidChange:(EMConnectionState)aConnectionState {
    
    switch (aConnectionState) {
        case EMConnectionConnected:
            NSLog(@"已连接");
            break;
        case EMConnectionDisconnected:
            NSLog(@"未连接");
            break;
        default:
            break;
    }

}


/*!
 *  当前登录账号在其它设备登录时会接收到该回调
 */
- (void)didLoginFromOtherDevice {
    NSLog(@"当前登录账号在其它设备登录");
}

/*!
 *  当前登录账号已经被从服务器端删除时会收到该回调
 */
- (void)didRemovedFromServer {
    NSLog(@"当前登录账号已经被从服务器端删除");
}

@end
