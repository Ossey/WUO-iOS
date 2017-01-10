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
#import "XYTopicDetailSelectView.h"

@interface XYTopicDetailTableView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) XYTopicDetailHeaderView *headView;
@property (nonatomic, strong) XYTopicDetailSelectView *selectView;
@property (nonatomic, strong) NSMutableArray *_trendList;

@end

@implementation XYTopicDetailTableView

static NSString * const cellIdentifier = @"XYTopicViewCell";
static NSString * const selectViewIdentifier = @"XYTopicDetailHeaderView";
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:UITableViewStylePlain]) {
        
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.showsHorizontalScrollIndicator = NO;
        self.tableHeaderView = self.headView;
        self.delegate = self;
        self.dataSource = self;
        [self registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
        [self registerClass:[XYTopicDetailSelectView class] forHeaderFooterViewReuseIdentifier:selectViewIdentifier];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(trendListChange:) name:XYTrendListChangeNote object:nil];
    }
    return self;
}

- (XYTopicDetailHeaderView *)headView {
    if (_headView == nil) {
        _headView = [XYTopicDetailHeaderView new];
    }
    
    return _headView;
}


//// 数据改变时，更新cell
//- (void)trendListChange:(NSNotification *)note {
//    
//    NSArray *arr = (NSArray *)note.object;
//    NSLog(@"%@", arr);
//}

/// 数据改变时，更新头部
- (void)setActivityTopicItem:(XYActivityTopicItem *)activityTopicItem {
    
    _activityTopicItem = activityTopicItem;
    // 注意: 要先调用下topicDetailHeaderHeight的get，内部的子控件frame都是通过此方法计算的，不然传过去的模型的frame没有值的
    _headView.xy_height = activityTopicItem.topicDetailHeaderHeight;
    self.headView.item = activityTopicItem;
    
    // 当有数据时才去设置selectView
    NSDictionary *dict1 = @{@"labelName": @"最 新"};
    NSDictionary *dict2 = @{@"labelName": @"榜 单"};
    NSArray<NSDictionary *> *labelArr = @[dict1, dict2];
    self.selectView.trendLabelView.channelCates = [labelArr mutableCopy];
    
    [self reloadData];
}

#pragma mark - <UITableViewDelegate, UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 18;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kTrendLabelViewHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    XYTopicDetailSelectView *selectView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:selectViewIdentifier];
    self.selectView = selectView;
    return selectView;
}

@end
