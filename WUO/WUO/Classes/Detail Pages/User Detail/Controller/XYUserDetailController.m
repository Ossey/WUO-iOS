//
//  XYUserDetailController.m
//  WUO
//
//  Created by mofeini on 17/1/11.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

#warning TODO 目前待解决的问题：循环引用了😢

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
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setImage:[UIImage imageNamed:@"Nav_message"] forState:UIControlStateNormal];
    [rightBtn sizeToFit];

    // 根据当前控制器所在当行控制器是不是XYCustomNavController判断，导航标题该显示在哪
    if ([self.navigationController isKindOfClass:NSClassFromString(@"XYCustomNavController")]) {
        self.xy_title = self.item.name;
        [self xy_setBackBarTitle:nil titleColor:nil image:[UIImage imageNamed:@"Login_backSel"] forState:UIControlStateNormal];
        self.xy_rightButton = rightBtn;
        
    } else {
        self.title = self.item.name;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
//        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Nav_message"].xy_originalMode style:UIBarButtonItemStylePlain target:self action:@selector(meaasgeClick)];
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
    __weak typeof(self) weakSelf = self;
    [WUOHTTPRequest userDetail_getUserInfoWithtargetUid:self.item.uid finishedCallBack:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"%@", error.localizedDescription);
            [weakSelf xy_showMessage:@"网络请求失败"];
            [WUOHTTPRequest setActivityIndicator:NO];
            _tableView.loading = NO;
            return;
        }
        
        if ([responseObject[@"code"] integerValue] == 0) {
            XYHTTPResponseInfo *info = [XYHTTPResponseInfo responseInfoWithDict:responseObject];
            if (responseObject[@"userInfo"] && [responseObject[@"userInfo"] isKindOfClass:[NSDictionary class]]) {
                weakSelf.userInfo = [XYUserInfo userInfoWithDict:responseObject[@"userInfo"] responseInfo:info];
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

#pragma mark - Eevent 
- (void)chatEvent {
    
}


- (void)dealloc {

    _tableView.delegate = nil;
    _tableView.userInfo = nil;
    [_tableView removeFromSuperview];
    _tableView = nil;
    self.item = nil;
    _userInfo = nil;
    
    
    NSLog(@"%s", __func__);
}

@end
