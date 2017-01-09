//
//  UIViewController+XYExtension.m
//  MiaoLive
//
//  Created by mofeini on 16/11/21.
//  Copyright © 2016年 com.test.demo. All rights reserved.
//

#import "UIViewController+XYExtension.h"
#import "UIImageView+XYExtension.h"
#import <objc/runtime.h>
#import <Masonry.h>

static char const *gifViewKey = "gifViewKey";

@implementation UIViewController (XYExtension)

- (void)setGifView:(UIImageView *)gifView {

    objc_setAssociatedObject(self, &gifViewKey, gifView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImageView *)gifView {

    return objc_getAssociatedObject(self, &gifViewKey);
}

- (BOOL)isEmptyArray:(NSArray *)array {

    /**
     isKindOfClass来确定一个对象是否是一个类的成员，或者是派生自该类的成员
     isMemberOfClass只能确定一个对象是否是当前类的成员
     */
    if ([array isKindOfClass:[NSArray class]] && array.count) {
        return NO;
    } else {
        return YES;
    }
}

- (void)showGifLoding:(NSArray *)images inView:(UIView *)view {

    if (!images.count) {
        images = @[[UIImage imageNamed:@"hold1_60x72"], [UIImage imageNamed:@"hold2_60x72"], [UIImage imageNamed:@"hold3_60x72"]];
    }
    
    UIImageView *gifView = [[UIImageView alloc] init];
    if (!view) {
        view = self.view;
    }
    [view addSubview:gifView];
    [gifView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(@0);
        make.width.equalTo(@60);
        make.height.equalTo(@70);
    }];
    
    self.gifView = gifView;
    
    [gifView playGifAnim:images];
}

// 取消GIF加载动画
- (void)hideGufLoding
{
    [self.gifView stopGifAnim];
    self.gifView = nil;
}


/**
 * @explain 获取当前屏幕显示的主控制器
 *
 */
+ (UIViewController *)getCurrentViewController {
    
    UIViewController *currentVc = nil;
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for (UIWindow *tempWindow in windows) {
            if (tempWindow.windowLevel == UIWindowLevelNormal) {
                window = tempWindow;
                break;
            }
        }
    }
    
    UIView *frontView = [window.subviews objectAtIndex:0];
    id nextRsponder = frontView.nextResponder;
    if ([nextRsponder isKindOfClass:[UIViewController class]]) {
        currentVc = nextRsponder;
    } else {
        currentVc = window.rootViewController;
    }
    
    return currentVc;
}

@end
