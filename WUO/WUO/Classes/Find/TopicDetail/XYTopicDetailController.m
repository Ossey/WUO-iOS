//
//  XYTopicDetailController.m
//  WUO
//
//  Created by mofeini on 17/1/9.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

#import "XYTopicDetailController.h"
#import "UIViewController+XYExtension.h"
#import "WUOHTTPRequest.h"
#import "XYActivityTopicItem.h"
#import "XYTopicDetailTableView.h"
#import "XYRefreshGifHeader.h"

@implementation XYTopicDetailController {
    
    // 话题详情页，头部的模型
    XYActivityTopicItem *_activityTopicItem;
    NSMutableArray *_trendList;
    XYTopicDetailTableView *_tableView;
}

+ (void)pushWithItem:(XYActivityTopicItem *)item {
    
    XYTopicDetailController *vc = [[XYTopicDetailController alloc] init];
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
    
    self.title = @"话题详情";
    
    _trendList = [NSMutableArray arrayWithCapacity:0];
    
    _tableView = [[XYTopicDetailTableView alloc] init];
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    // 第一次进入此页面时，请求话题详情数据，下次不管是下拉刷新还是上拉加载时，都是请求Trend
    [self loadTopicHeaderDetail];
    
    // 下拉刷新时请求帖子
    _tableView.mj_header = [XYRefreshGifHeader headerWithRefreshingBlock:^{
        [self loadTopic];
    }];
    

}

- (void)loadTopicHeaderDetail {
    
    [WUOHTTPRequest find_topicDetailByID:self.item.topicId finishedCallBack:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        if (error) {
            [self xy_showMessage:@"网络请求失败"];
            [_tableView.mj_header endRefreshing];
            return;
        }
        if ([responseObject[@"code"] integerValue] == 0) {
            XYTopicInfo *info = [XYTopicInfo topicInfoWithDict:responseObject];
            // 请求数据成功
            // 头部数据，内含第一次加载的帖子数组
            _activityTopicItem = [XYActivityTopicItem activityTopicItemWithDict:responseObject[@"datas"] info:info];
            _tableView.activityTopicItem = _activityTopicItem;
            
        }
        
        [_tableView.mj_header endRefreshing];
        
    }];

}

- (void)loadTopic {
    [WUOHTTPRequest topicWithIdstamp:[NSString stringWithFormat:@"%ld", _activityTopicItem.info.idstamp] type:1 topicID:_activityTopicItem.topicId serachLabel:nil finished:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        if (error) {
            [self xy_showMessage:@"网络请求失败"];
            [_tableView.mj_header endRefreshing];
            return;
        }
        if ([responseObject[@"code"] integerValue] == 0) {
            XYTopicInfo *info = [XYTopicInfo topicInfoWithDict:responseObject];
            // 请求数据成功
            if (responseObject[@"data"] && [responseObject[@"data"] count] > 0) {
                
                // 头像详情中有帖子数组
                for (id obj in responseObject[@"data"]) {
                    if ([obj isKindOfClass:[NSDictionary class]]) {
                        // 帖子模型数
                        [_trendList addObject:[XYTopicItem topicItemWithDict:obj info:info]];
                    }
                }
            }
            
        }
        [_tableView.mj_header endRefreshing];
    }];
}

@end
