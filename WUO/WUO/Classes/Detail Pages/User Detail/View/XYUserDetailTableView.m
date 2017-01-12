//
//  XYUserDetailTableView.m
//  WUO
//
//  Created by mofeini on 17/1/12.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

#import "XYUserDetailTableView.h"
#import "XYUserDetailHeaderView.h"
#import "XYActiveTopicDetailSelectView.h"
#import "XYTopicViewCell.h"

@interface XYUserDetailTableView () <UITableViewDelegate, UITableViewDataSource, XYCateTitleViewDelegate>
@property (nonatomic, strong) XYActiveTopicDetailSelectView *selectView;
@end

@implementation XYUserDetailTableView {
    XYUserDetailHeaderView *_headerView;
    
}

static NSString * const cellIdentifier = @"XYTopicViewCell";
static NSString * const selectViewIdentifier = @"XYActiveTopicDetailController";
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
        
        _headerView = [XYUserDetailHeaderView new];
        _headerView.xy_height = SIZE_USER_DETAIL_HEADERVIEW_H;
        self.tableHeaderView = _headerView;
        
        self.delegate = self;
        self.dataSource = self;
        [self registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
        [self registerClass:[XYActiveTopicDetailSelectView class] forHeaderFooterViewReuseIdentifier:selectViewIdentifier];
        
        // 当有数据时才去设置selectView
        NSDictionary *dict1 = @{@"labelName": @"主页"};
        NSDictionary *dict2 = @{@"labelName": @"作品"};
        NSDictionary *dict3 = @{@"labelName": @"展示"};
        NSArray<NSDictionary *> *labelArr = @[dict1, dict2, dict3];
        self.selectView.trendLabelView.channelCates = [labelArr mutableCopy];
        self.selectView.trendLabelView.delegate = self;
    }
    return self;
}

- (void)setUserInfo:(XYUserInfo *)userInfo {
    _userInfo = userInfo;
    _headerView.userInfo = userInfo;
}

#pragma mark - <UITableViewDelegate, UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kTrendLabelViewHeight;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    self.selectView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:selectViewIdentifier];
    return self.selectView;
}

#pragma mark - XYCateTitleViewDelegate
- (void)cateTitleView:(XYCateTitleView *)view didSelectedItem:(NSInteger)index {
   
}

@end
