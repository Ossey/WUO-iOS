//
//  XYLaunchView.m
//  WUO
//
//  Created by mofeini on 17/1/2.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

#import "XYLaunchView.h"

#define btnPadding 10
#define btnMiddleMargin 50
#define btnWidth (CGRectGetWidth([UIScreen mainScreen].bounds) - btnPadding * 2 - btnMiddleMargin) * 0.5
#define selfHeight 40
#define selfBottomMargin -60

@interface XYLaunchView () {
    
    UIButton *_registerBtn;
    UIButton *_loginBtn;
}

@end

@implementation XYLaunchView


+ (void)launchView:(UIView *)superView loginRegisterCallBack:(void(^)(XYLaunchViewType type))callBack {
    
    XYLaunchView *launchView = nil;
    
    if (superView && [superView isKindOfClass:[UIView class]]) {
        
        launchView = [[self alloc] init];
        [superView addSubview:launchView];
        launchView.backgroundColor = kColor(0, 0, 0, 0);
        
        [launchView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(superView);
            make.bottom.mas_equalTo(superView).mas_offset(selfBottomMargin);
            make.height.mas_equalTo(selfHeight);
        }];
        
        launchView.loginRegisterCallBack = callBack;
    }
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _registerBtn = registerBtn;
        
        [registerBtn setTitle:@"注册" forState:UIControlStateNormal];
        [registerBtn setTitleColor:kColor(255, 255, 255, 1.0) forState:UIControlStateNormal];
        [registerBtn setBackgroundColor:kColor(0, 0, 0, 0.25)];
        registerBtn.layer.cornerRadius = 5;
        [registerBtn.layer setMasksToBounds:YES];
        [self addSubview:registerBtn];
        registerBtn.tag = XYLaunchViewTypeRegister;
        [registerBtn addTarget:self action:@selector(loginRegisterBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).mas_offset(btnPadding);
            make.top.bottom.mas_equalTo(self);
            make.width.mas_equalTo(btnWidth);
        }];
        
        UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _loginBtn = loginBtn;
        [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        [loginBtn setTitleColor:kColor(0, 0, 0, 1.0) forState:UIControlStateNormal];
        [loginBtn setBackgroundColor:kColor(230, 230, 230, 0.25)];
        loginBtn.layer.cornerRadius = 5;
        [loginBtn.layer setMasksToBounds:YES];
        [self addSubview:loginBtn];
        loginBtn.tag = XYLaunchViewTypeLogin;
        [loginBtn addTarget:self action:@selector(loginRegisterBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self).mas_offset(-btnPadding);
            make.top.bottom.mas_equalTo(self);
            make.width.mas_equalTo(btnWidth);
        }];

    }
    
    return self;
}

- (void)loginRegisterBtnClick:(UIButton *)btn {
    
    if (self.loginRegisterCallBack) {
        self.loginRegisterCallBack(btn.tag);
    }
}


- (void)dealloc {
    
    NSLog(@"%s", __func__);
}


@end
