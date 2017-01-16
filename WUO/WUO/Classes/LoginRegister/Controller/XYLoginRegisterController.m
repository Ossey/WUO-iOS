//
//  XYLoginRegisterController.m
//  WUO
//
//  Created by mofeini on 17/1/2.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

#import "XYLoginRegisterController.h"
#import "XYThirdPartyLoginView.h"
#import "XYLoginView.h"
#import <UMSocialCore/UMSocialCore.h>
#import "XYLoginInfo.h"
#import "WUOHTTPRequest.h"
#import "AppDelegate.h"

#define loginViewHeight 220
#define registerViewHeight 250


@interface XYLoginRegisterController () <UIScrollViewDelegate>

@property (nonatomic, assign) XYLoginRegisterType type;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) XYThirdPartyLoginView *thirdPartyLoginView;
@property (nonatomic, strong) XYLoginView *loginView;
@end

@implementation XYLoginRegisterController

- (instancetype)initWithType:(XYLoginRegisterType)type {
    
    if (self = [super init]) {
        
        self.type = type;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

- (void)setupUI {

    [self setupNavBar];

    [self.thirdPartyLoginView setThirdPartyLoginBlock:^(XYThirdPartyLoginType type) {
        NSLog(@"%lu", type);
    }];
    
    if (_type == XYLoginRegisterTypeRegister) {
        
        self.xy_title = @"注册";
        
    } else if (XYLoginRegisterTypeLogin) {
        self.xy_title = @"登录";
        
        self.loginView.hidden = NO;
    }
    
    __weak typeof(self) weakSelf = self;
    [self.thirdPartyLoginView setThirdPartyLoginBlock:^(XYThirdPartyLoginType type) {
        switch (type) {
            case XYThirdPartyLoginTypeSina:
                [weakSelf getAuthWithUserInfoFromSina];
                break;
            case XYThirdPartyLoginTypeWeChat:
                [weakSelf getAuthWithUserInfoFromWechat];
                break;
                
            case XYThirdPartyLoginTypeQQ:
                [weakSelf getAuthWithUserInfoFromQQ];
                break;
                
            default:
                break;
        }
    }];
}

- (void)setupNavBar {
    
    self.xy_topBar.backgroundColor = [UIColor whiteColor];
    self.shadowLineView.backgroundColor = [UIColor whiteColor];
    
    [self xy_setBackBarTitle:nil titleColor:nil image:[UIImage imageNamed:@"Login_backSel"] forState:UIControlStateNormal];

}




- (UIScrollView *)scrollView {
    
    if (_scrollView == nil) {
        
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        // alwaysBounceVertical默认值为NO，如果该值设为YES，并且bounces也设置为YES，那么，即使设置的contentSize比scrollView的size小，那么也是可以拖动的
        _scrollView.alwaysBounceVertical = YES;
        // 键盘的消失模式 UIScrollViewKeyboardDismissModeOnDrag: 拖动scrollView时键盘消失
        _scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _scrollView.bounces = YES;
        _scrollView.delegate = self;
        [self.view addSubview:_scrollView];
    }
    
    return _scrollView;
}

- (XYThirdPartyLoginView *)thirdPartyLoginView {
    
    if (_thirdPartyLoginView == nil) {
        _thirdPartyLoginView = [XYThirdPartyLoginView xy_viewFromXib];
        _thirdPartyLoginView.frame = CGRectMake(0, loginViewHeight + kNavigationBarHeight, CGRectGetWidth(self.scrollView.frame), 80);
        [self.scrollView addSubview:_thirdPartyLoginView];
    }
    
    return _thirdPartyLoginView;
}

- (XYLoginView *)loginView {
    
    if (_loginView == nil) {
        
        _loginView = [XYLoginView xy_viewFromXib];
        _loginView.frame = CGRectMake(0, kNavigationBarHeight, CGRectGetWidth(self.scrollView.frame), loginViewHeight);
        [self.scrollView addSubview:_loginView];
    }
    
    return _loginView;
}

#pragma mark - 友盟第三方登录相关

// 获取第三方登录信息
- (void)getUserInfoForPlatform:(UMSocialPlatformType)platformType
{
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:platformType currentViewController:self completion:^(id result, NSError *error) {
        
        UMSocialUserInfoResponse *resp = result;
        
        // 第三方登录数据(为空表示平台未提供)
        // 授权数据
        NSLog(@" uid: %@", resp.uid);
        NSLog(@" openid: %@", resp.openid);
        NSLog(@" accessToken: %@", resp.accessToken);
        NSLog(@" refreshToken: %@", resp.refreshToken);
        NSLog(@" expiration: %@", resp.expiration);
        
        // 用户数据
        NSLog(@" name: %@", resp.name);
        NSLog(@" iconurl: %@", resp.iconurl);
        NSLog(@" gender: %@", resp.gender);
        
        // 第三方平台SDK原始数据
        NSLog(@" originalResponse: %@", resp.originalResponse);
        
        // 获取授权成功后，给服务器发送请求登录的信息
        [self requestLoginBy:resp];
    }];
}

// 新浪微博 授权并获取用户信息(获取uid、access token及用户名等)
- (void)getAuthWithUserInfoFromSina
{
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_Sina currentViewController:nil completion:^(id result, NSError *error) {
        if (error) {
           [self xy_showMessage:[NSString stringWithFormat:@"新浪授权失败, %@", error]];
        } else {
            UMSocialUserInfoResponse *resp = result;
            
            // 授权信息
            NSLog(@"Sina uid: %@", resp.uid);
            NSLog(@"Sina accessToken: %@", resp.accessToken);
            NSLog(@"Sina refreshToken: %@", resp.refreshToken);
            NSLog(@"Sina expiration: %@", resp.expiration);
            
            // 用户信息
            NSLog(@"Sina name: %@", resp.name);
            NSLog(@"Sina iconurl: %@", resp.iconurl);
            NSLog(@"Sina gender: %@", resp.gender);
            
            // 第三方平台SDK源数据
            NSLog(@"Sina originalResponse: %@", resp.originalResponse);
            
            // 获取授权成功后，给服务器发送请求登录的信息
            [self requestLoginBy:resp];
        }
    }];
}

// QQ 授权并获取用户信息(获取uid、access token及用户名等)
- (void)getAuthWithUserInfoFromQQ
{
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_QQ currentViewController:nil completion:^(id result, NSError *error) {
        if (error) {
            [self xy_showMessage:[NSString stringWithFormat:@"QQ授权失败, %@", error]];
        } else {
            UMSocialUserInfoResponse *resp = result;
            
//            // 授权信息
//            NSLog(@"QQ uid: %@", resp.uid);
//            NSLog(@"QQ openid: %@", resp.openid);
//            NSLog(@"QQ accessToken: %@", resp.accessToken);
//            NSLog(@"QQ expiration: %@", resp.expiration);
//            
//            // 用户信息
//            NSLog(@"QQ name: %@", resp.name);
//            NSLog(@"QQ iconurl: %@", resp.iconurl);
//            NSLog(@"QQ gender: %@", resp.gender);
//            
//            // 第三方平台SDK源数据
//            NSLog(@"QQ originalResponse: %@", resp.originalResponse);
            
            // 获取授权成功后，给服务器发送请求登录的信息
            [self requestLoginBy:resp];
            
        }
    }];
}

// 第三方授权成功，给服务器发送请求登录
- (void)requestLoginBy:(UMSocialUserInfoResponse *)resp {
    [WUOHTTPRequest loginByOpenPlatformDeviceToken:resp.accessToken head:resp.iconurl name:resp.name openPlatform:@"QQ" openPlatformId:resp.openid osVersion:@"4.2.2" phoneModel:@"iPhone" finished:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        
        if (error) {
            [self xy_showMessage:@"第三方登录失败"];
            return;
        }
        if ([responseObject[@"code"] integerValue] == 0) {
            // 登录成功，切换根控制器\写入本地
            [self loginSuccessByResponseObj:responseObject];
        }
        
    }];
}

// 第三方登录成功 切换根控制器 登录信息写入本地
- (void)loginSuccessByResponseObj:(id)responseObject {
    NSDictionary *responseDict = responseObject;
    [responseDict writeToFile:kLoginInfoPath atomically:YES];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        delegate.isLogin = YES;
    });
    
    [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"code"] forKey:XYUserLoginStatuKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self xy_showMessage:[NSString stringWithFormat:@"登录%@", responseObject[@"codeMsg"]]];
}

// 微信 授权并获取用户信息(获取uid、access token及用户名等)
// 注意这里的uid为unionID

- (void)getAuthWithUserInfoFromWechat
{
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:nil completion:^(id result, NSError *error) {
        if (error) {
            NSLog(@"%@", error);
            [self xy_showMessage:[NSString stringWithFormat:@"微信授权失败, %@", error]];
        } else {
            UMSocialUserInfoResponse *resp = result;
            
            // 授权信息
            NSLog(@"Wechat uid: %@", resp.uid);
            NSLog(@"Wechat openid: %@", resp.openid);
            NSLog(@"Wechat accessToken: %@", resp.accessToken);
            NSLog(@"Wechat refreshToken: %@", resp.refreshToken);
            NSLog(@"Wechat expiration: %@", resp.expiration);
            
            // 用户信息
            NSLog(@"Wechat name: %@", resp.name);
            NSLog(@"Wechat iconurl: %@", resp.iconurl);
            NSLog(@"Wechat gender: %@", resp.gender);
            
            // 第三方平台SDK源数据
            NSLog(@"Wechat originalResponse: %@", resp.originalResponse);
        }
    }];
}




@end
