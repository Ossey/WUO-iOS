//
//  XYMineViewController.m
//  WUO
//
//  Created by mofeini on 17/1/1.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

#import "XYMineViewController.h"
#import "XYSettingViewController.h"

@interface XYMineViewController ()

@end

@implementation XYMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.xy_topBar.hidden = YES;
    
    UIButton *settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [settingBtn setTitle:@"设置" forState:UIControlStateNormal];
    [self.view addSubview:settingBtn];
    [settingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.view).mas_offset(64);
    }];
    [settingBtn addTarget:self action:@selector(jumoToSetting) forControlEvents:UIControlEventTouchUpInside];
    [settingBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [settingBtn sizeToFit];
    
}

- (void)jumoToSetting {
    
    XYSettingViewController *vc = [XYSettingViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}



@end
