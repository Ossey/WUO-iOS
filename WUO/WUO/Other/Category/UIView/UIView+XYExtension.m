//
//  UIView+Frame.m
//  
//
//  Created by mofeini on 16/9/6.
//  Copyright © 2016年 sey. All rights reserved.
//

#import "UIView+XYExtension.h"

@implementation UIView (XYExtension)

- (void)setXy_width:(CGFloat)xy_width {

    CGRect rect = self.frame;
    
    rect.size.width = xy_width;
    
    self.frame = rect;
}

- (CGFloat)xy_width {

    return self.frame.size.width;
}

- (void)setXy_height:(CGFloat)xy_height {

    CGRect rect = self.frame;
    
    rect.size.height = xy_height;
    
    self.frame = rect;
}

- (CGFloat)xy_height {

    return self.frame.size.height;
}

- (void)setXy_x:(CGFloat)xy_x {

    CGRect rect = self.frame;
    
    rect.origin.x = xy_x;
    
    self.frame = rect;
}

- (CGFloat)xy_x {

    return self.frame.origin.x;
}

- (void)setXy_y:(CGFloat)xy_y {

    CGRect rect = self.frame;
    
    rect.origin.y = xy_y;
    
    self.frame = rect;
}

- (CGFloat)xy_y {

    return self.frame.origin.y;
}

- (void)setXy_centerX:(CGFloat)xy_centerX {

    CGPoint point = self.center;
    
    point.x = xy_centerX;
    
    self.center = point;
}

- (CGFloat)xy_centerX {

    return self.center.x;
}

- (void)setXy_centerY:(CGFloat)xy_centerY {

    CGPoint point = self.center;
    
    point.y = xy_centerY;
    
    self.center = point;
}

- (CGFloat)xy_centerY {
    
    return self.center.y;
}

// 快速从xib加载第一个
+ (instancetype)xy_viewFromXib {

    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
}

/**
 *  获取视图所在控制器
 *
 *  @return 返回视图所在控制器
 */

- (UIViewController *)viewController {
    
    
    for (UIView *next = [self superview]; next; next = next.superview) {
        
        UIResponder* nextResponder = [next nextResponder];
        
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

/// 这个方法通过响应者链条获取view所在的控制器
- (UIViewController *)parentController
{
    UIResponder *responder = [self nextResponder];
    while (responder) {
        if ([responder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)responder;
        }
        responder = [responder nextResponder];
    }
    return nil;
}

/**
 通过控制器的布局视图可以获取到控制器实例对象
 modal的展现方式需要取到控制器的根视图
 */

+ (UIViewController *)currentViewController {
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    // modal展现方式的底层视图不同
    // 取到第一层时，取到的是UITransitionView，通过这个view拿不到控制器
    UIView *firstView = [keyWindow.subviews firstObject];
    UIView *secondView = [firstView.subviews firstObject];
    UIViewController *vc = [secondView parentController];
    if ([vc isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tab = (UITabBarController *)vc;
        if ([tab.selectedViewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController *nav = (UINavigationController *)tab.selectedViewController;
            return [nav.viewControllers lastObject];
        } else {
            return tab.selectedViewController;
        }
    } else if ([vc isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nav = (UINavigationController *)vc;
        return [nav.viewControllers lastObject];
    } else {
        return vc;
    }
    return nil;
}



@end
