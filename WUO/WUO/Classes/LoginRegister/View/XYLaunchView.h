//
//  XYLaunchView.h
//  WUO
//
//  Created by mofeini on 17/1/2.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, XYLaunchViewType) {
    
    XYLaunchViewTypeRegister = 1,
    XYLaunchViewTypeLogin,
};

@interface XYLaunchView : UIView

@property (nonatomic, copy)void (^loginRegisterCallBack)(XYLaunchViewType type);

+ (void)launchView:(UIView *)superView loginRegisterCallBack:(void(^)(XYLaunchViewType type))callBack;
@end
