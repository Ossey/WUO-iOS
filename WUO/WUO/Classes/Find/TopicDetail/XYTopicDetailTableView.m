//
//  XYTopicDetailTableView.m
//  WUO
//
//  Created by mofeini on 17/1/10.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

#import "XYTopicDetailTableView.h"
#import "XYTopicDetailHeaderView.h"
#import "XYTopicViewCell.h"
#import "XYActivityTopicItem.h"

@interface XYTopicDetailTableView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) XYTopicDetailHeaderView *headView;

@end

@implementation XYTopicDetailTableView

static NSString * const cellIdentifier = @"XYTopicViewCell";
static NSString * const headerIdentifier = @"XYTopicDetailHeaderView";
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:UITableViewStyleGrouped]) {
        
        self.tableHeaderView = self.headView;
        self.delegate = self;
        self.dataSource = self;
        [self registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
      
        
    }
    return self;
}

- (XYTopicDetailHeaderView *)headView {
    if (_headView == nil) {
        _headView = [[XYTopicDetailHeaderView alloc] initWithReuseIdentifier:cellIdentifier];
    }
    
    return _headView;
}




- (void)setActivityTopicItem:(XYActivityTopicItem *)activityTopicItem {
    
    _activityTopicItem = activityTopicItem;
    // 注意: 要先调用下topicDetailHeaderHeight的get，内部的子控件frame都是通过此方法计算的，不然传过去的模型的frame没有值的
    _headView.xy_height = activityTopicItem.topicDetailHeaderHeight;
    self.headView.item = activityTopicItem;
    
    [self reloadData];
}

#pragma mark - <UITableViewDelegate, UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    return cell;
}


@end
