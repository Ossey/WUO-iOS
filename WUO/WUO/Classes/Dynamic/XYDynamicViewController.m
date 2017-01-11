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

@interface XYDynamicViewController () <XYDynamicTableViewDelegate>

@property (nonatomic, strong) XYDynamicTableView *tableView;

@end

@implementation XYDynamicViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = kTableViewBgColor;
    self.tableView.dynamicDelegate = self;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Nav_Home_goldCoin_new"].xy_originalMode style:UIBarButtonItemStylePlain target:self action:@selector(goldCoinClick)];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Home_Icon"]];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Nav_message"].xy_originalMode style:UIBarButtonItemStylePlain target:self action:@selector(meaasgeClick)];
    
}


- (XYDynamicTableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[XYDynamicTableView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:_tableView];
    }
    
    return _tableView;
}

#pragma mark - <XYDynamicTableViewDelegate>
- (void)dynamicTableView:(XYDynamicTableView *)tableView didSelectAvatarViewAtIndexPath:(NSIndexPath *)indexPath {
    
    XYUserDetailController *vc = [XYUserDetailController new];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Events 
- (void)goldCoinClick {
    
    
}

- (void)meaasgeClick {
    
    
}


- (void)dealloc {
    
    
}
@end
