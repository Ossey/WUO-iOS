//
//  XYLoginView.h
//  WUO
//
//  Created by mofeini on 17/1/2.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XYLoginView;
@protocol XYLoginViewDelegate <NSObject>

@optional
- (void)loginView:(XYLoginView *)loginView loginAccount:(UIButton *)btn;
- (void)loginView:(XYLoginView *)loginView forgetPwd:(UIButton *)btn;

@end

@interface XYLoginView : UIView

@property (nonatomic, weak, readonly) UITextField *phoneNumTF;
@property (nonatomic, weak, readonly) UITextField *pwdTF;
@property (nonatomic, weak) id<XYLoginViewDelegate> delegate;

@end
