//
//  MainTabBar.m
//  WUO
//
//  Created by mofeini on 17/1/1.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

#import "MainTabBar.h"

@interface MainTabBar ()

@property (nonatomic, weak) UIControl *previousClickBarButton;
@property (nonatomic, weak) UIButton *composeBtn;

@end

@implementation MainTabBar

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    NSInteger count = self.items.count + 1;
    CGFloat buttonW = CGRectGetWidth(self.frame) / count;
    CGFloat buttonH = CGRectGetHeight(self.frame);
    CGFloat buttonX = 0;
    
    NSInteger i = 0;
    for (UIControl *tabBarButton in self.subviews) {
        
        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            
            if (i == 2) {
                
                i += 1;
            }
            
            if (i == 0 && self.previousClickBarButton == nil) {
                
                self.previousClickBarButton = tabBarButton;
            }
            
            [tabBarButton addTarget:self action:@selector(tabBarClick:) forControlEvents:UIControlEventTouchUpInside];
            
            buttonX = i * buttonW;
            
            tabBarButton.frame = CGRectMake(buttonX, 0, buttonW, buttonH);
            
            i++;
        }
        
    }
    
    self.composeBtn.center = CGPointMake(CGRectGetWidth(self.frame) * 0.5, CGRectGetHeight(self.frame) * 0.5 + -15);
    
}

- (void)tabBarClick:(UIControl *)tabBarButton {
    
    // 当上一次点击按钮也是同一个按钮时做刷新操作
    if (self.previousClickBarButton == tabBarButton) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:XYTabBarButtonDidRepeatClickNotification object:nil];
    }
    
    self.previousClickBarButton = tabBarButton;
    
}

- (UIButton *)composeBtn {
    
    if (_composeBtn == nil) {
        
        UIButton *composeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [composeBtn setBackgroundImage:[UIImage imageNamed:@"tabbar_sendMsgTabbarItemSEL"] forState:UIControlStateNormal];
        [composeBtn setBackgroundImage:[UIImage imageNamed:@"tabbar_sendMsgTabbarItemSEL"] forState:UIControlStateHighlighted];

        CGRect frame = composeBtn.frame;
        frame.size.width = 60;
        frame.size.height = 60;
        composeBtn.frame = frame;
        
        [composeBtn addTarget:self action:@selector(composeBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        _composeBtn = composeBtn;
        
        [self addSubview:composeBtn];
    }
    
    return _composeBtn;
}


- (void)composeBtnClick {
    
    // modal到发布控制器
//    XYPubishViewController *pubishVc = [[XYPubishViewController alloc] init];
//    [app.keyWindow.rootViewController presentViewController:pubishVc animated:YES completion:nil];
    
}

@end
