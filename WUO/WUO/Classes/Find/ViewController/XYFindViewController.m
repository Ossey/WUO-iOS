//
//  XYFindViewController.m
//  WUO
//
//  Created by mofeini on 17/1/1.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

#import "XYFindViewController.h"
#import "WUOHTTPRequest.h"
#import "XYAdvertItem.h"
#import "XYAdvertView.h"
#import "XYTrendLabelItem.h"
#import "XYTrendTableView.h"
#import "XYTopicViewCell.h"
#import "WUOFindHeaderView.h"
#import "XYActivityTopicItem.h"

@interface XYFindViewController () <XYTrendTableViewDelegate, UIScrollViewDelegate, XYCateTitleViewDelegate>
@property (nonatomic, strong) XYTrendTableView *tableView;
@property (nonatomic, strong) XYAdvertView *advertView;
@property (nonatomic, strong) WUOFindHeaderView *headerFooterView;
@property (nonatomic, strong) XYTrendLabelView *trendLabelView;
@end

@implementation XYFindViewController {
    
    NSArray *_advertItems;
    NSMutableArray *_trendLabelList;
    /** scroolView的y值上次偏移量 ，当完成一次滚动后，此属性会记录这次的偏移量*/
    CGFloat _scrollViewPreviousOffsetY;
    /** tableView的y值上次偏移量 ，当完成一次滚动后，此属性会记录这次的偏移量*/
    CGFloat _trendTableViewPreviousOffsetY;
    NSMutableArray<XYActivityTopicItem *> *_topicList;
}

static NSString * const cellIdentifier = @"UITableViewCell";
static NSString *const headerFooterViewIdentifier = @"WUOFindHeaderView";
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _scrollViewPreviousOffsetY = kScrollVoewOriginalOffsetY;
    _trendTableViewPreviousOffsetY = kTrendTableViewOriginalOffsetY;
    
    _trendLabelList = [NSMutableArray arrayWithCapacity:5];
    _topicList = [NSMutableArray arrayWithCapacity:1];
    
    
    self.xy_topBar.backgroundColor = [UIColor clearColor];
    self.shadowLineView.backgroundColor = [UIColor clearColor];
    
    self.xy_title = @"发现";
    self.xy_titleColor = [UIColor clearColor];
    
    /* 出现的问题1:直接[[UITableView alloc] init]创建tableView时，然后代码设置约束时，设置contentInset后，第一个进入此界面时，tableView的contentInset无效，滚动tableView后contentInset才有效果，会导致tableView向上窜以下；
        解决方法:  创建tableView时，给tableView传入self.view.bounds，再设置约束，问题解决
     */
    _tableView = [[XYTrendTableView alloc] initWithFrame:CGRectZero dataType:2];
    _tableView.dynamicDelegate = self;
    [self.view addSubview:_tableView];
    _tableView.backgroundColor = kTableViewBgColor;
    
    _advertView = [XYAdvertView new];
    _advertView.xy_height = kAdvertViewHeight;
    _tableView.tableHeaderView = _advertView;
    
    [_tableView registerClass:[WUOFindHeaderView class] forHeaderFooterViewReuseIdentifier:@"UITableViewHeaderFooterView"];
    
    [self makeConstraints];
    
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    //当调用contentInset会自动调用scrollViewDidScroll
//    [_tableView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
   // 设置滚动条指示器
//    [_tableView setScrollIndicatorInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    
    [self loadDataFromNewwork];

}



#pragma mark - 数据请求
- (void)loadDataFromNewwork {
    
    // 广告
    [self loadAdvert];
    // 标题栏
    [self loadHotTrendLabel];
    // 活动话题
    [self loadAllTopicData];
}

- (void)loadHotTrendLabel {
    
    [WUOHTTPRequest setActivityIndicator:YES];
    [WUOHTTPRequest find_hotTrendLabelWithFinishedCallBack:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        
        if (error) {
            NSLog(@"%@", error.localizedDescription);
            
            [WUOHTTPRequest setActivityIndicator:NO];
            return;
        }
        
        if (responseObject[@"datas"] && [responseObject[@"datas"] isKindOfClass:[NSArray class]]) {
            [_headerFooterView setTrendLabelList:[responseObject[@"datas"] mutableCopy]];
        }
        [WUOHTTPRequest setActivityIndicator:NO];
    }];
}

- (void)loadAdvert {
    [WUOHTTPRequest setActivityIndicator:YES];
    [WUOHTTPRequest find_advertWithFinishedCallBack:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        
        if (error) {
            NSLog(@"%@", error.localizedDescription);
            
            [WUOHTTPRequest setActivityIndicator:NO];
            return;
        }
        
        if ([responseObject[@"code"] integerValue] == 0) {
            NSMutableArray *temArryM = [NSMutableArray arrayWithCapacity:3];
            // 获取数据成功
            for (id obj in responseObject[@"datas"]) {
                if ([obj isKindOfClass:[NSDictionary class]]) {
                    [temArryM addObject:[XYAdvertItem advertItemWithDict:obj]];
                }
            }
            _advertItems = [temArryM mutableCopy];
            temArryM = nil;
            _advertView.advertItems = _advertItems;

        }
        
        [WUOHTTPRequest setActivityIndicator:NO];
    }];
}

- (void)loadAllTopicData {

    [WUOHTTPRequest find_allTopicWithFinishedCallBack:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"%@", error.localizedDescription);
            return;
        }
        
        if ([responseObject[@"code"] intValue] == 0 && [responseObject[@"datas"] isKindOfClass:[NSArray class]]) {
            if ([responseObject[@"datas"] count] != 0) {
                for (id obj in responseObject[@"datas"]) {
                    if ([obj isKindOfClass:[NSDictionary class]]) {
                        XYTopicInfo *info = [XYTopicInfo topicInfoWithDict:responseObject];
                        XYActivityTopicItem *item = [XYActivityTopicItem activityTopicItemWithDict:obj info:info];
                        [_topicList addObject:item];
                    }
                }
                self.headerFooterView.topicView.topicItemList = [_topicList mutableCopy];
            }
        }
    }];
}

#pragma mark - 子控件约束
- (void)makeConstraints {
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - XYTrendTableViewDelegate
- (void)dynamicTableViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView.contentOffset.y > kAdvertViewHeight + kTopicViewHeight + kHeaderFooterViewInsetMargin  - kNavigationBarHeight) {
        if ([_trendLabelView.superview isKindOfClass:NSClassFromString(@"_UITableViewHeaderFooterContentView")]) {
            [_trendLabelView removeFromSuperview];
            
            [self.view addSubview:_trendLabelView];
            
            [_trendLabelView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.view).mas_offset(64);
                make.height.equalTo(@kTrendLabelViewHeight);
                make.left.right.equalTo(self.view);
            }];
        }
        
    } else {
        if (![_trendLabelView.superview isKindOfClass:NSClassFromString(@"_UITableViewHeaderFooterContentView")]) {
            [_trendLabelView removeFromSuperview];
            [_headerFooterView.contentView addSubview:_trendLabelView];

            [_trendLabelView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.bottom.right.equalTo(_headerFooterView.contentView);
                make.height.mas_equalTo(kTrendLabelViewHeight);
                make.top.equalTo(_headerFooterView.topicView.mas_bottom).mas_offset(kHeaderFooterViewInsetMargin);
            }];
            
        }

    }
    
    // 找最大值
    CGFloat alpha = scrollView.contentOffset.y * 1 / ((kAdvertViewHeight + kTopicViewHeight - kNavigationBarHeight) * 1.0);
    if (alpha >= 1) {
        alpha = 0.99;
    }
    
    self.xy_titleColor = [UIColor colorWithWhite:0 alpha:alpha];
    self.xy_topBar.backgroundColor = [UIColor colorWithWhite:1 alpha:alpha];
    
}

//// 触摸dynamicTableView并拖拽画面，再松开时，触发该函数
//- (void)dynamicTableViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
//    // 当没有产生减速效果时，不会调用scrollView的scrollViewDidEndDecelerating方法，这里就需要记录最终偏移量
//    if (!decelerate) {
//        // 记录停止拖拽时rendTableView的偏移量
//        _trendTableViewPreviousOffsetY = scrollView.contentOffset.y;
//        // 还原scrollVew上次偏移量
//        _scrollViewPreviousOffsetY = kScrollVoewOriginalOffsetY;
//    }
//}
//
//// dynamicTableView产生减速效果，在减速结束后调用
//- (void)dynamicTableViewDidEndDecelerating:(UIScrollView *)scrollView {
//    // 记录停止拖拽时rendTableView的偏移量
//    _trendTableViewPreviousOffsetY = scrollView.contentOffset.y;
////    NSLog(@"_trendTableViewPreviousOffsetY==%f", _trendTableViewPreviousOffsetY);
//    // 还原scrollVew上次偏移量
//    _scrollViewPreviousOffsetY = kScrollVoewOriginalOffsetY;
//}
//
- (UIView *)dynamicTableView:(XYTrendTableView *)dynamicTableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return self.headerFooterView;
    }
    return nil;
}

- (CGFloat)dynamicTableView:(XYTrendTableView *)dynamicTableView heightForHeaderInSection:(NSInteger)section {
    CGFloat height = 0.0;
    if (section == 0) {
        height = kTopicViewHeight + kHeaderFooterViewInsetMargin + kTrendLabelViewHeight;
    }
    return height;
}

- (WUOFindHeaderView *)headerFooterView {
    if (_headerFooterView == nil) {
        _headerFooterView = [[WUOFindHeaderView alloc] initWithReuseIdentifier:headerFooterViewIdentifier];
        _trendLabelView = [_headerFooterView.trendLabelView copy];
        _headerFooterView.trendLabelView.delegate = self;
    }
    return _headerFooterView;
}

#pragma mark - XYCateTitleViewDelegate

- (void)cateTitleView:(XYCateTitleView *)view didSelectedItem:(NSInteger)index {
    
}


- (void)cateTitleView:(XYCateTitleView *)view didSelectedItem:(UIButton *)btn cname:(NSString *)cname {
    
    if (_tableView.cnameBlock) {
        
        _tableView.cnameBlock(cname);
    }
   
}


- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
