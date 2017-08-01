//
//  AppDelegate.h
//  WUO
//
//  Created by mofeini on 17/1/1.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYLoginInfo.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate> 

@property (strong, nonatomic) UIWindow *window;
@property (assign, nonatomic) BOOL isLogin;
@property (strong, nonatomic) XYLoginInfo *currentloginInfo;

@end

