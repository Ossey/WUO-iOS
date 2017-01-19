//
//  XYActiveTopicDetailController.m
//  WUO
//
//  Created by mofeini on 17/1/9.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

#import "XYActiveTopicDetailController.h"
#import "UIViewController+XYExtension.h"
#import "XYActiveTopicDetailTableView.h"
#import "WUOHTTPRequest.h"
#import "XYActivityTopicItem.h"
#import "XYUserDetailController.h"
#import "WUO-Swift.h"

@interface XYActiveTopicDetailController () <XYActiveTopicTableViewDelegate>

@end

@implementation XYActiveTopicDetailController {
    
    XYActiveTopicDetailTableView *_tableView;
    
}

+ (void)pushWithItem:(XYActivityTopicItem *)item {
    
    XYActiveTopicDetailController *vc = [[XYActiveTopicDetailController alloc] init];
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
    
    self.xy_title = @"话题详情";
    self.xy_topBar.backgroundColor = [UIColor whiteColor];
    [self xy_setBackBarTitle:nil titleColor:nil image:[UIImage imageNamed:@"Login_backSel"] forState:UIControlStateNormal];
    
    _tableView = [[XYActiveTopicDetailTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.activeTopicTableViewdelegate = self;
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    // 请求话题详情页,只需要进入页面时请求一次
    [self loadTopicHeaderDetail];
    
    // 请求失败时回调
    [_tableView gzwLoading:^{
        [self loadTopicHeaderDetail];
    }];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    _tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
}


- (void)loadTopicHeaderDetail {
    
    _tableView.loading = YES; // 正在加载中提示
    [WUOHTTPRequest setActivityIndicator:YES];
    
    [WUOHTTPRequest find_topicDetailByID:self.item.topicId finishedCallBack:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        // 检测登录及在线状态, -2 为登录失败
        [WUOHTTPRequest  checkLoginStatusFromResponseCode:[responseObject[@"code"] integerValue]];
        
        if (error) {
            [self xy_showMessage:@"网络请求失败"];
            _tableView.loading = NO;
            [WUOHTTPRequest setActivityIndicator:NO];
            return;
        }
        if ([responseObject[@"code"] integerValue] == 0) {
            XYHTTPResponseInfo *info = [XYHTTPResponseInfo responseInfoWithDict:responseObject];
            // 请求数据成功
            // 头部数据，内含第一次加载的帖子数组
            _tableView.activityTopicItem = [XYActivityTopicItem activitytrendItemWithDict:responseObject[@"datas"] info:info];
            
        }
        _tableView.loading = NO;
        [WUOHTTPRequest setActivityIndicator:NO];
    }];
    
}

#pragma mark - XYActiveTopicTableViewDelegate
- (void)activeTopicDetailTableView:(XYActiveTopicDetailTableView *)tableView didSelectAvatarViewAtIndexPath:(NSIndexPath *)indexPath item:(XYTrendItem *)item {
    
    XYUserDetailController *vc = [[XYUserDetailController alloc] initWithUid:item.uid username:item.name];
    [self.navigationController pushViewController:vc animated:YES];

}

- (void)activeTopicDetailTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath item:(XYTrendItem *)item {
    
    XYTrendDetailController *vc = [[XYTrendDetailController alloc] initWithTrendItem:item];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)dealloc {
    _tableView.activeTopicTableViewdelegate = nil;
    [_tableView removeFromSuperview];
    _tableView = nil;
    NSLog(@"%s", __func__);
    
}


@end
