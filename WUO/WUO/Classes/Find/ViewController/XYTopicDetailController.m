//
//  XYTopicDetailController.m
//  WUO
//
//  Created by mofeini on 17/1/9.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

#import "XYTopicDetailController.h"
#import "UIViewController+XYExtension.h"

@interface XYTopicDetailController ()

@end

@implementation XYTopicDetailController

+ (void)pushWithItem:(XYActivityTopicItem *)item {
    
    XYTopicDetailController *vc = [[XYTopicDetailController alloc] init];
    vc.item = item;
    // 获取当前在显示的主控制器
    UIViewController *currentMainVc = [self getCurrentViewController];
    
    // 如果是主控制器是tabBar控制器，获取其中正在显示的导航控制器
    UINavigationController *currentNav;
    if ([currentMainVc isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabBarVc = (UITabBarController *)currentMainVc;
        for (UINavigationController *nav in tabBarVc.viewControllers) {
            if (nav.visibleViewController && nav.view.window) {
                currentNav = nav;
                break;
            }
        }
    }
    [currentNav pushViewController:vc animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSLog(@"%@", self.item);
}



@end
