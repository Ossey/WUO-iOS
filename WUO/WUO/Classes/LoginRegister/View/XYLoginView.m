//
//  XYLoginView.m
//  WUO
//
//  Created by mofeini on 17/1/2.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

#import "XYLoginView.h"
#import "WUOHTTPRequest.h"
#import "AppDelegate.h"
#import "MainTabBarController.h"

@interface XYLoginView ()
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTF;
@property (weak, nonatomic) IBOutlet UITextField *pwdTF;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end

@implementation XYLoginView

+ (instancetype)xy_viewFromXib {
    
    return [[NSBundle mainBundle] loadNibNamed:@"XYLoginRegisterView" owner:nil options:nil][1];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.loginBtn.layer.cornerRadius = 5;
    [self.loginBtn.layer setMasksToBounds:YES];
    
    [self.phoneNumTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.pwdTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}


- (IBAction)loginBtnClick:(id)sender {
    
    if (self.phoneNumTF.text.length == 0 && self.pwdTF.text.length == 0) {
        return;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(loginView:loginAccount:)]) {
        [self.delegate loginView:self loginAccount:sender];
    }
    
    [WUOHTTPRequest setActivityIndicator:YES];
    
    [WUOHTTPRequest loginWithAccount:self.phoneNumTF.text pwd:self.pwdTF.text finished:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        
        [WUOHTTPRequest setActivityIndicator:NO];
        
        if (error) {
            NSLog(@"%@", error.localizedDescription);
            return;
        }
        // 写入本地
        NSDictionary *responseDict = responseObject;
        [responseDict writeToFile:kLoginInfoPath atomically:YES];
        
        if ([responseObject[@"code"] integerValue] == 0) {
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                delegate.isLogin = YES;
                
                [self clear];
            });
        }
        
        [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"code"] forKey:XYUserLoginStatuKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self xy_showMessage:[NSString stringWithFormat:@"登录%@", responseObject[@"codeMsg"]]];
    }];
    
}

- (IBAction)forgetPwd:(id)sender {
    
    if (self.delegate &&[self.delegate respondsToSelector:@selector(loginView:forgetPwd:)]) {
        [self.delegate loginView:self forgetPwd:sender];
    }
}

- (void)clear {
    
    [super removeFromSuperview];
}

#pragma mark - Events
- (void)textFieldDidChange:(UITextField *)tf {
    
    int length = [self convertToInt:tf.text];
    
    if (tf == self.phoneNumTF) {
        // 限制电话号码输入的长度为11位
        if (length >= 11) {
            
            tf.text = [tf.text substringToIndex:11];
        }
        
    } else {
        // 限制密码输入的长度为20位
        if (length >= 20) {
            tf.text = [tf.text substringToIndex:20];
        }
    }
}

// 判断中英混合的的字符串长度
- (int)convertToInt:(NSString *)string {
    
    int strlength = 0;
    for (int i=0; i< string.length; i++) {
        int a = [string characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff) {
            // 当输入的文字是中文时,中文2位
            strlength += 2;
        } else {
            strlength += 1;
        }
    }
    return strlength;
}


@end
