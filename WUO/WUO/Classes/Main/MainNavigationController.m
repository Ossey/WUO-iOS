//
//  MainNavigationController.m
//  WUO
//
//  Created by mofeini on 17/1/1.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

#import "MainNavigationController.h"

@interface MainNavigationController () <UIGestureRecognizerDelegate, UINavigationControllerDelegate>

@end

@implementation MainNavigationController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    __weak typeof(self) weakSelf = self;
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = weakSelf;
        self.delegate = weakSelf;
    }
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if (self.childViewControllers.count > 0) {
        [viewController setHidesBottomBarWhenPushed:YES];
        
        // 自定义导航条左侧返回按钮
        UIButton *backBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [backBarButton setImage:[UIImage imageNamed:@"Login_backSel"].xy_originalMode forState:UIControlStateNormal];
        backBarButton.contentEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
        [backBarButton sizeToFit];
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBarButton];
        
        // 如果自定义返回按钮后,
        if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.interactivePopGestureRecognizer.enabled = NO;
        }
        
    }
    
    [super pushViewController:viewController animated:animated];
}

- (void)backBarButton {
    
    // 判断两种情况: push 和 present
    if ([self isPresent]) {
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }else {
        [[self navigationController] popViewControllerAnimated:YES];
    }
    
}

- (BOOL)isPresent {
    
    BOOL isPresent;
    
    NSArray *viewcontrollers = self.viewControllers;
    
    if (viewcontrollers.count > 1) {
        if ([viewcontrollers objectAtIndex:viewcontrollers.count - 1] == self) {
            
            isPresent = NO; //push方式
        }
    }
    else{
        isPresent = YES;  // modal方式
    }
    
    return isPresent;
}



#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if (navigationController.childViewControllers.count == 1) {
        self.interactivePopGestureRecognizer.enabled = NO;
    } else {
        self.interactivePopGestureRecognizer.enabled = YES;
    }
}

@end
