//
//  UIView+XYExtension.h
//  
//
//  Created by mofeini on 16/9/6.
//  Copyright © 2016年 sey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (XYExtension)

@property CGFloat xy_width;

@property CGFloat xy_height;

@property CGFloat xy_x;

@property CGFloat xy_y;

@property CGFloat xy_centerX;

@property CGFloat xy_centerY;

/// 快速从xib加载第一个
+ (instancetype)xy_viewFromXib;

/**
 *  获取视图所在控制器
 *
 *  @return 返回视图所在控制器
 */

- (UIViewController *)viewController;

/**
 * 通过控制器的布局视图可以获取到控制器实例对象
 * modal的展现方式需要取到控制器的根视图
 */
- (UIViewController *)currentViewController;
@end
