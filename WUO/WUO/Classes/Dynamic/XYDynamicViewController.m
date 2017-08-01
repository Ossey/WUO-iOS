//
//  XYDynamicViewController.m
//  WUO
//
//  Created by mofeini on 17/1/1.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

#import "XYDynamicViewController.h"
#import "XYDynamicTableView.h"
#import "XYUserDetailController.h"
#import "XYTrendItem.h"
#import "WUO-Swift.h"

@interface XYDynamicViewController () <XYDynamicTableViewDelegate>

@property (nonatomic, strong) XYDynamicTableView *tableView;

@end

@implementation XYDynamicViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = kTableViewBgColor;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Nav_Home_goldCoin_new"].xy_originalMode style:UIBarButtonItemStylePlain target:self action:@selector(goldCoinClick)];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Home_Icon"]];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Nav_message"].xy_originalMode style:UIBarButtonItemStylePlain target:self action:@selector(jumpToConversationList)];
}



- (XYDynamicTableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[XYDynamicTableView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:_tableView];
    }
    
    return _tableView;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    _tableView.dynamicDelegate = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _tableView.dynamicDelegate = self;
}


#pragma mark - <XYDynamicTableViewDelegate>
- (void)dynamicTableView:(XYDynamicTableView *)tableView didSelectAvatarViewAtIndexPath:(NSIndexPath *)indexPath item:(XYTrendItem *)item {
    
    XYUserDetailController *vc = [[XYUserDetailController alloc] initWithUid:item.uid username:item.name];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)dynamicTableView:(XYDynamicTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath item:(XYTrendItem *)item {
    // 跳转到 trend 详情页
    XYTrendDetailController *vc = [[XYTrendDetailController alloc] initWithTrendItem:item];
    [self.navigationController pushViewController:vc animated:YES];

}



#pragma mark - Events 
- (void)goldCoinClick {
    
    
}

// 跳转到会话列表控制器
- (void)jumpToConversationList {
    
    
}


- (void)dealloc {
    [_tableView removeFromSuperview];
    _tableView = nil;
    NSLog(@"%s", __func__);
    
}
@end
