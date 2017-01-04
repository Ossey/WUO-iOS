//
//  XYDynamicViewController.m
//  WUO
//
//  Created by mofeini on 17/1/1.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

#import "XYDynamicViewController.h"
#import "XYDynamicTableView.h"

@interface XYDynamicViewController ()

@property (nonatomic, strong) XYDynamicTableView *tableView;

@end

@implementation XYDynamicViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = kColor(238, 238, 238, 1.0);
}


- (XYDynamicTableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[XYDynamicTableView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:_tableView];
    }
    
    return _tableView;
}

@end
