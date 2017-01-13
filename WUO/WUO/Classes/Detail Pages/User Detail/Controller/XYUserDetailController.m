//
//  XYUserDetailController.m
//  WUO
//
//  Created by mofeini on 17/1/11.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

#import "XYUserDetailController.h"
#import "XYUserDetailTableView.h"
#import "WUOHTTPRequest.h"
#import "XYUserInfo.h"
#import "XYTopicViewModel.h"

@interface XYUserDetailController ()
@property (nonatomic, strong) XYUserInfo *userInfo;
@end

@implementation XYUserDetailController {
    XYUserDetailTableView *_tableView;
    
}

- (instancetype)initWithItem:(XYTopicItem *)item {
    if (self = [super init]) {
        self.item = item;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView.backgroundColor = kTableViewBgColor;
    
    self.xy_topBar.backgroundColor = [UIColor whiteColor];
    
    // 根据当前控制器所在当行控制器是不是XYCustomNavController判断，导航标题该显示在哪
    if ([self.navigationController isKindOfClass:NSClassFromString(@"XYCustomNavController")]) {
        self.xy_title = self.item.name;
        [self xy_setBackBarTitle:nil titleColor:nil image:[UIImage imageNamed:@"Login_backSel"] forState:UIControlStateNormal];
    } else {
        self.title = self.item.name;
    }
    
    [self loadUserInfo];
    
    
    _tableView = [[XYUserDetailTableView alloc] init];
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
}


// 请求用户信息
- (void)loadUserInfo {
    
    _tableView.loading = YES;
    [WUOHTTPRequest setActivityIndicator:YES];
    
    [WUOHTTPRequest userDetail_getUserInfoWithtargetUid:self.item.uid finishedCallBack:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"%@", error.localizedDescription);
            [self xy_showMessage:@"网络请求失败"];
            [WUOHTTPRequest setActivityIndicator:NO];
            _tableView.loading = NO;
            return;
        }
        
        if ([responseObject[@"code"] integerValue] == 0) {
            XYHTTPResponseInfo *info = [XYHTTPResponseInfo responseInfoWithDict:responseObject];
            if (responseObject[@"userInfo"] && [responseObject[@"userInfo"] isKindOfClass:[NSDictionary class]]) {
                self.userInfo = [XYUserInfo userInfoWithDict:responseObject[@"userInfo"] responseInfo:info];
            }
        }
        
        [WUOHTTPRequest setActivityIndicator:NO];
        _tableView.loading = NO;
    }];

}

- (void)setUserInfo:(XYUserInfo *)userInfo {
    _userInfo = userInfo;
    _tableView.userInfo = userInfo;
}


- (void)dealloc {
    
    [_tableView removeFromSuperview];
    _tableView = nil;
    
    NSLog(@"%s", __func__);
}

@end
