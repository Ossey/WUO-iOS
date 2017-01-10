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
#import "XYTrendTableView.h"


@implementation XYTopicDetailController {
    
    // 话题详情页，头部的模型
    XYActivityTopicItem *_activityTopicItem;
    NSMutableArray *_trendList;
    XYTrendTableView *_tableView;
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
    
    self.view.backgroundColor = [UIColor whiteColor];
    _trendList = [NSMutableArray arrayWithCapacity:0];
    
    _tableView = [[XYTrendTableView alloc] init];
    [self.view addSubview:_tableView];
    
    // 第一次进入此页面时，请求话题详情数据，下次不管是下拉刷新还是上拉加载时，都是请求Trend
    [self loadTopicDetail];
}

- (void)loadTopicDetail {
    
    [WUOHTTPRequest find_topicDetailByID:self.item.topicId finishedCallBack:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        if (error) {
            [self xy_showMessage:@"网络请求失败"];
            return;
        }
        if ([responseObject[@"code"] integerValue] == 0) {
            XYTopicInfo *info = [XYTopicInfo topicInfoWithDict:responseObject];
            // 请求数据成功
            // 头部数据，内含第一次加载的帖子数组
            _activityTopicItem = [XYActivityTopicItem activityTopicItemWithDict:responseObject[@"datas"] info:info];
            if (responseObject[@"data"][@"trendList"] && [responseObject[@"data"][@"trendList"] count] > 0) {
                // 头像详情中有帖子数组
                for (id obj in responseObject[@"data"][@"trendList"]) {
                    if ([obj isKindOfClass:[NSDictionary class]]) {
                        // 帖子模型数
                        [_trendList addObject:[XYTopicItem topicItemWithDict:obj info:info]];
                    }
                }
            }
            
            
        }
        
    }];

}


@end
