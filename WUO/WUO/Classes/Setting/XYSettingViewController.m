//
//  XYSettingViewController.m
//  WUO
//
//  Created by mofeini on 17/1/16.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

#import "XYSettingViewController.h"
#import "XYLaunchPlayerController.h"
#import "AppDelegate.h"

@interface XYSettingViewController ()

@end

@implementation XYSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view);
        make.height.equalTo(@35);
        make.left.right.equalTo(self.view);
    }];
    btn.backgroundColor = [UIColor blueColor];
    [btn addTarget:self action:@selector(loginOut) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"退出登录" forState:UIControlStateNormal];
    
}


/// 退出登录
- (void)loginOut {
    
    
    // 用户没有登录
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.isLogin = NO;
    
    // 主动退出登录：调用 SDK 的退出接口；
    EMError *error = [[EMClient sharedClient] logout:YES];
    if (!error) {
        NSLog(@"您的账号退出成功");
    }

    
    [[NSUserDefaults standardUserDefaults] setObject:@-2 forKey:XYUserLoginStatuKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}



@end
