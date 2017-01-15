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
#import "ChatViewController.h"

@interface XYUserDetailController ()
@property (nonatomic, strong) XYUserInfo *userInfo;
@end

@implementation XYUserDetailController {
    XYUserDetailTableView *_tableView;
    
}

//- (instancetype)initWithItem:(XYTopicItem *)item {
//    if (self = [super init]) {
//        self.item = item;
//    }
//    return self;
//}

- (instancetype)initWithUid:(NSInteger)uid username:(NSString *)name {
    if (self = [super init]) {
        self.uid = uid;
        self.username = name;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _tableView = [[XYUserDetailTableView alloc] init];
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
//    _tableView.backgroundColor = kTableViewBgColor;
    
    self.xy_topBar.backgroundColor = [UIColor whiteColor];
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setImage:[UIImage imageNamed:@"Mine_SiXinImage"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(jumpToChat) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn sizeToFit];

    // 根据当前控制器所在当行控制器是不是XYCustomNavController判断，导航标题该显示在哪
    if ([self.navigationController isKindOfClass:NSClassFromString(@"XYCustomNavController")]) {
        self.xy_title = self.username;
        [self xy_setBackBarTitle:nil titleColor:nil image:[UIImage imageNamed:@"Login_backSel"] forState:UIControlStateNormal];
        self.xy_rightButton = rightBtn;
        // tableView设置偏移量
        self.automaticallyAdjustsScrollViewInsets = NO;
        _tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
        
        [self.navigationController.navigationBar setHidden:YES];
    } else {
        self.title = self.username;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
        

    }
    
    [self loadUserInfo];
    
    
    
    
}


// 请求用户信息
- (void)loadUserInfo {
    
    _tableView.loading = YES;
    [WUOHTTPRequest setActivityIndicator:YES];
    __weak typeof(self) weakSelf = self;
    [WUOHTTPRequest userDetail_getUserInfoWithtargetUid:self.uid finishedCallBack:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
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
- (void)jumpToChat {
    
    // 进入聊天室，与当前用户聊天
    ChatViewController *vc = [[ChatViewController alloc] initWithConversationChatter:[NSString stringWithFormat:@"%ld", self.uid] conversationType:EMConversationTypeChat];
    vc.user = self.userInfo;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)dealloc {

    _tableView.delegate = nil;
    _tableView.userInfo = nil;
    [_tableView removeFromSuperview];
    _tableView = nil;
    _userInfo = nil;
    
    
    NSLog(@"%s", __func__);
}

@end
