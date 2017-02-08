//
//  MainTabBarController.m
//  WUO
//
//  Created by mofeini on 17/1/1.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

#import "MainTabBarController.h"
#import "XYFindViewController.h"
#import "XYMineViewController.h"
#import "XYComposeViewController.h"
#import "XYDynamicViewController.h"
#import "MainNavigationController.h"
#import "MainTabBar.h"
#import "XYCustomNavController.h"
#import "WUO-Swift.h"
#import "XYBlurEffectView.h"

#define tabBarHeight CGRectGetHeight(self.tabBar.bounds)
#define standOutHeight 12.0f // 中间突出部分的高度


@interface MainTabBarController () <XYBlurEffectViewDelegate>
{

}
@end

@implementation MainTabBarController

+ (void)initialize {
    if (self == [MainTabBarController class]) {
        UITabBar *tabBar = [UITabBar appearanceWhenContainedInInstancesOfClasses:@[self]];
        [tabBar setShadowImage:[UIImage new]];
        [tabBar setBackgroundImage:[UIImage new]];
        
        UITabBarItem *tabBarItem = [UITabBarItem appearanceWhenContainedInInstancesOfClasses:@[self]];
        NSDictionary *textAttributes = @{NSForegroundColorAttributeName : kTabBarItemTextColor_Sel};
        [tabBarItem setTitleTextAttributes:textAttributes forState:UIControlStateSelected];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupChildViewController:[XYDynamicViewController new]];
    [self setupChildViewController:[XYFindViewController new]];
//    [self setupChildViewController:[XYComposeViewController new]];
    [self setupChildViewController:[XYInvestViewController new]];
    [self setupChildViewController:[XYMineViewController new]];
    
    [self setupTabBar];
    
}

- (void)setupTabBar {

    MainTabBar *tabBar = [MainTabBar new];
    [self setValue:tabBar forKey:@"tabBar"];
    
    //改变tabBar的背景颜色
    [self.tabBar insertSubview:[self drawTabbarBgImageView] atIndex:0];
    self.tabBar.opaque = YES;
    self.selectedIndex = 0;
    NSArray *itemName = @[@"动态",@"发现", @"投资", @"我"];
    NSArray *defaultImage = @[@"tabbar_meTabbarItem",  @"tabbar_findTabbarItem",  @"tabbar_messageTabbarItem", @"tabbar_mineTabbarItem"];
    NSArray *selectImage = @[@"tabbar_meTabbarItemSEL", @"tabbar_findTabbarItemSEL",  @"tabbar_messageTabbarItemSEL", @"tabbar_mineTabbarItemSEL"];
    for(int i = 0 ; i < itemName.count; i++)
    {
        UITabBarItem *tabBarItem = (UITabBarItem *)self.tabBar.items[i];
        
//        if (i == 2) {
//            [tabBarItem setImageInsets:UIEdgeInsetsMake(-standOutHeight, 0, standOutHeight, 0)];
//        } else {
//        
//        }
        tabBarItem.image = [[UIImage imageNamed:defaultImage[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        tabBarItem.selectedImage = [[UIImage imageNamed:selectImage[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [tabBarItem setTitle:itemName[i]];
    }
    
    // 点击compose发布时，先弹出XYBlurEffect页面，用户选择完发布的类型，再跳转到对应的发布界面：（图文）、（视频）
    __block XYBlurEffectView *blurEffectView = nil;
    __weak typeof(self) weakSelf = self;
    [tabBar setCmposeClickBlock:^{
        XYBlurItem *item1 = [XYBlurItem blurItemWithImageNamed:@"message_call_connect" title:@"图文"];
        XYBlurItem *item2 = [XYBlurItem blurItemWithImageNamed:@"message_call_connect" title:@"视频"];
        blurEffectView = [XYBlurEffectView showWithMenuItemList:@[item1, item2]];
        blurEffectView.delegate = weakSelf;
    }];
    
}

- (void)setupChildViewController:(UIViewController *)vc  {

    UINavigationController *nav = nil;
    if ([vc isKindOfClass:[XYProfileBaseController class]]) {
        nav = [[XYCustomNavController alloc] initWithRootViewController:vc];
    } else {
        nav = [[MainNavigationController alloc] initWithRootViewController:vc];
    }
    
    [self addChildViewController:nav];
    
}

// 画背景的方法，返回 Tabbar的背景
- (UIImageView *)drawTabbarBgImageView {
    
    CGFloat radius = 30;// 圆半径
    CGFloat allFloat= (pow(radius, 2)-pow((radius-standOutHeight), 2));// standOutHeight 突出高度 12
    CGFloat ww = sqrtf(allFloat);
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, -standOutHeight,kScreenW , tabBarHeight + standOutHeight)];
    CGSize size = imageView.frame.size;
    CAShapeLayer *layer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(size.width/2 - ww, standOutHeight)];
    CGFloat angleH = 0.5*((radius-standOutHeight)/radius);
    CGFloat startAngle = (1+angleH)*((float)M_PI); // 开始弧度
    CGFloat endAngle = (2-angleH)*((float)M_PI);//结束弧度
    // 开始画弧：CGPointMake：弧的圆心  radius：弧半径 startAngle：开始弧度 endAngle：介绍弧度 clockwise：YES为顺时针，No为逆时针
    [path addArcWithCenter:CGPointMake((size.width)/2, radius) radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
    // 开始画弧以外的部分
    [path addLineToPoint:CGPointMake(size.width/2+ww, standOutHeight)];
    [path addLineToPoint:CGPointMake(size.width, standOutHeight)];
    [path addLineToPoint:CGPointMake(size.width,size.height)];
    [path addLineToPoint:CGPointMake(0,size.height)];
    [path addLineToPoint:CGPointMake(0,standOutHeight)];
    [path addLineToPoint:CGPointMake(size.width/2-ww, standOutHeight)];
    layer.path = path.CGPath;
    layer.fillColor = [UIColor whiteColor].CGColor;// 整个背景的颜色
    layer.strokeColor = [UIColor colorWithWhite:0.765 alpha:1.000].CGColor;//边框线条的颜色
    layer.lineWidth = 0.5;//边框线条的宽
    // 在要画背景的view上 addSublayer:
    [imageView.layer addSublayer:layer];
    return imageView;
}

#pragma mark - XYBlurEffectViewDelegate
- (void)blurEffectView:(XYBlurEffectView *)view didSelectItemWithType:(XYBlurEffectItemType)type {
    XYComposeViewController *composeVc = nil;
    switch (type) {
        case XYBlurEffectItemTypeComposeImageOrText:
            [XYBlurEffectView dismiss];
            composeVc = [[XYComposeViewController alloc] init];
            [self presentViewController:composeVc animated:YES completion:nil];
            break;
        case XYBlurEffectItemTypeComposeVideo:
            
            break;
            
        default:
            
            break;
    }
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}

@end
