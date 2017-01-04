//
//  XYFindViewController.m
//  WUO
//
//  Created by mofeini on 17/1/1.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

#import "XYFindViewController.h"

#define tableHeaderHeight 200

@interface XYFindViewController () <UITableViewDataSource, UITableViewDelegate> {
    
    CGRect _firstCellFrame;
}
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation XYFindViewController

static NSString * const cellIdentifier = @"UITableViewCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = kColor(238, 238, 238, 1.0);
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
    UIView *headerView = [UIView new];
    headerView.backgroundColor = [UIColor blueColor];
    headerView.xy_height = tableHeaderHeight;
    self.tableView.tableHeaderView = headerView;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [self.view addSubview:_tableView];
    }
    
    return _tableView;
}

#pragma mark - <UITableViewDataSource, UITableViewDelegate>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if (indexPath.row == 0) {
        _firstCellFrame = cell.frame;
    }
    
    return cell;
    
}
@end
