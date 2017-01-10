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
#import "XYRefreshGifHeader.h"
#import "XYRefreshGifFooter.h"
#import "WUOHTTPRequest.h"
#import "XYDynamicViewModel.h"

@interface XYTopicDetailTableView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) XYTopicDetailHeaderView *headView;
@property (nonatomic, strong) XYTopicDetailSelectView *selectView;
@property (nonatomic, strong) NSMutableArray<XYDynamicViewModel *> *trendList;
@end

@implementation XYTopicDetailTableView {
    NSInteger _idStamp;
    BOOL _isFirst;
    NSMutableArray *_needLoadList;
    BOOL _scrollToToping;
    /** 将每一种标题类型的数据数组作为value，标题作为key放在这个数组中, 按照当前点击的serachLabel去_dataList查找对应数据，防止数据错乱 */
    NSMutableDictionary<NSString *,NSMutableArray<XYDynamicViewModel *> *> *_dataList;
    NSMutableDictionary<NSString *, NSNumber *> *_cnameDict;
}

@synthesize trendList = _trendList;
static NSString * const cellIdentifier = @"XYTopicViewCell";
static NSString * const selectViewIdentifier = @"XYTopicDetailHeaderView";
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:UITableViewStylePlain]) {
        
        _needLoadList = [NSMutableArray arrayWithCapacity:3];
        _isFirst = YES;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.showsHorizontalScrollIndicator = NO;
        self.tableHeaderView = self.headView;
        self.delegate = self;
        self.dataSource = self;
        [self registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
        [self registerClass:[XYTopicDetailSelectView class] forHeaderFooterViewReuseIdentifier:selectViewIdentifier];
        
         _trendList = [NSMutableArray<XYDynamicViewModel *> arrayWithCapacity:0];
    
        
        // 下拉刷新时请求帖子时_idStamp必须 为空 才能请求到新数据
        self.mj_header = [XYRefreshGifHeader headerWithRefreshingBlock:^{
            _idStamp = 0;
            [_trendList removeAllObjects];
            [self loadTopic];
        }];
        
        self.mj_footer = [XYRefreshGifFooter footerWithRefreshingBlock:^{
            _idStamp = _activityTopicItem.info.idstamp;
        }];
    }
    return self;
}


- (void)loadTopic {
    
    [WUOHTTPRequest setActivityIndicator:YES];
    
    [WUOHTTPRequest topicWithIdstamp:[NSString stringWithFormat:@"%ld", _idStamp] type:1 topicID:_activityTopicItem.topicId serachLabel:nil finished:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        if (error) {
            [self xy_showMessage:@"网络请求失败"];
            [self.mj_header endRefreshing];
            [self.mj_footer endRefreshing];
            [WUOHTTPRequest setActivityIndicator:NO];
            return;
        }
        if ([responseObject[@"code"] integerValue] == 0) {
            XYTopicInfo *info = [XYTopicInfo topicInfoWithDict:responseObject];
            _activityTopicItem.info = info;
            // 请求数据成功
            if (responseObject[@"data"] && [responseObject[@"data"] count] > 0) {
                
                // 头像详情中有帖子数组
                for (id obj in responseObject[@"data"]) {
                    if ([obj isKindOfClass:[NSDictionary class]]) {
                        // 帖子模型数
                        [self.trendList addObject:[XYDynamicViewModel dynamicViewModelWithItem:[XYTopicItem topicItemWithDict:obj info:info] info:info]];
                    }
                }
                [self reloadData];
            }
            
        }
        [WUOHTTPRequest setActivityIndicator:NO];
        [self.mj_footer endRefreshing];
        [self.mj_header endRefreshing];
    }];
}



#pragma mark - <UITableViewDelegate, UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.trendList.count;
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


#pragma mark - set \ get
- (XYTopicDetailHeaderView *)headView {
    if (_headView == nil) {
        _headView = [XYTopicDetailHeaderView new];
    }
    
    return _headView;
}


// 数据源发送改变时更新cell
- (void)setTrendList:(NSMutableArray *)trendList {
    _trendList = [trendList mutableCopy];
    
    NSLog(@"%@", trendList);
    [self reloadData];
}

/// 数据改变时，更新头部
- (void)setActivityTopicItem:(XYActivityTopicItem *)activityTopicItem {
    
    _activityTopicItem = activityTopicItem;
    if (_isFirst) {
        // 注意: 要先调用下topicDetailHeaderHeight的get，内部的子控件frame都是通过此方法计算的，不然传过去的模型的frame没有值的
        _headView.xy_height = activityTopicItem.topicDetailHeaderHeight;
        self.headView.item = activityTopicItem;
        
        // 将第一次请求到的帖子数据添加到数据源中
        self.trendList = [activityTopicItem.trendList mutableCopy];
        
        // 当有数据时才去设置selectView
        NSDictionary *dict1 = @{@"labelName": @"最 新"};
        NSDictionary *dict2 = @{@"labelName": @"榜 单"};
        NSArray<NSDictionary *> *labelArr = @[dict1, dict2];
        self.selectView.trendLabelView.channelCates = [labelArr mutableCopy];
        _isFirst = NO;
    }
    
}

- (NSMutableArray<XYDynamicViewModel *> *)trendList {
    if (_trendList == nil) {
        _trendList = [NSMutableArray arrayWithCapacity:0];
    }
    return _trendList;
}

@end
