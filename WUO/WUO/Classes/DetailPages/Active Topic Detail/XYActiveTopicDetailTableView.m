//
//  XYActiveTopicDetailTableView.m
//  WUO
//
//  Created by mofeini on 17/1/10.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

#import "XYActiveTopicDetailTableView.h"
#import "XYActiveTopicDetailHeaderView.h"
#import "XYTrendViewCell.h"
#import "XYActivityTopicItem.h"
#import "XYActiveTopicDetailSelectView.h"
#import "XYRefreshGifHeader.h"
#import "XYRefreshGifFooter.h"
#import "WUOHTTPRequest.h"
#import "XYTrendViewModel.h"

/**
 根据topicID type idStamp参数请求帖子数据 当type是1时请求 最新 ，当type是0时请求 榜单
 注意：默认进入页面时请求到的头部数据中的帖子是 榜单 的 ，也就是进入页面时默认选中 榜单 按钮
 */

typedef NS_ENUM(NSInteger, XYTopicType) {
    XYTopicTypeNew = 1,         // 请求最新数据
    XYTopicTypeNewRanklist = 0  // 请求排行榜数据
};

@interface XYActiveTopicDetailTableView () <UITableViewDelegate, UITableViewDataSource, XYCateTitleViewDelegate, XYTrendViewCellDelegate>

@property (nonatomic, strong) XYActiveTopicDetailHeaderView *headView;
@property (nonatomic, strong) XYActiveTopicDetailSelectView *selectView;
@property (nonatomic, assign) XYTopicType currentType;

@end
// 榜单的排名
//static NSInteger rangking = 0;

@implementation XYActiveTopicDetailTableView {
    NSInteger _idStamp;
    BOOL _isFirst;
    NSMutableArray *_needLoadList;
    BOOL _scrollToToping;
    /** 将每一种标题类型的数据数组作为value，标题作为key放在这个数组中, 按照当前XYTopicType去_dataList查找对应数据，防止数据错乱 */
    NSMutableDictionary<NSNumber *,NSMutableArray<XYTrendViewModel *> *> *_dataList;
    NSMutableDictionary<NSNumber *, NSNumber *> *_cnameDict;
    
}

static NSString * const cellIdentifier = @"XYTrendViewCell";
static NSString * const selectViewIdentifier = @"XYActiveTopicDetailSelectView";
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
        
        _dataList = [NSMutableDictionary dictionaryWithCapacity:0];
        _needLoadList = [NSMutableArray arrayWithCapacity:3];
        _cnameDict = [NSMutableDictionary dictionaryWithCapacity:1];
        _isFirst = YES;
        
        self.backgroundColor = kTableViewBgColor;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.showsHorizontalScrollIndicator = NO;
        self.tableHeaderView = self.headView;
        self.delegate = self;
        self.dataSource = self;
        [self registerClass:[XYTrendViewCell class] forCellReuseIdentifier:cellIdentifier];
        [self registerClass:[XYActiveTopicDetailSelectView class] forHeaderFooterViewReuseIdentifier:selectViewIdentifier];
        
        
        // 下拉刷新时请求帖子时_idStamp必须 为空 才能请求到新数据
        self.mj_header = [XYRefreshGifHeader headerWithRefreshingBlock:^{
            _idStamp = 0;
            [_dataList[@(self.currentType)] removeAllObjects];
            [self loadTopic];
        }];
        
        self.mj_footer = [XYRefreshGifFooter footerWithRefreshingBlock:^{
            _idStamp = _dataList[@(self.currentType)].lastObject.info.idstamp;
            [self loadTopic];
        }];
    }
    return self;
}


#pragma mark - 数据请求

- (void)loadTopic {
    
    [WUOHTTPRequest setActivityIndicator:YES];
    
    NSLog(@"%ld--%ld--%ld", _activityTopicItem.topicId , _idStamp, self.currentType);
    
    [WUOHTTPRequest find_getTrendByTopicId:_activityTopicItem.topicId idstamp:[NSString stringWithFormat:@"%ld", _idStamp] type:self.currentType finishedCallBack:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        
        // 检测登录及在线状态, -2 为登录失败
        [WUOHTTPRequest  checkLoginStatusFromResponseCode:[responseObject[@"code"] integerValue]];
        
        if (error) {
            [self xy_showMessage:@"网络请求失败"];
            [self.mj_header endRefreshing];
            [self.mj_footer endRefreshing];
            [WUOHTTPRequest setActivityIndicator:NO];
            return;
        }
        
        if ([responseObject[@"code"] integerValue] == 0) {
            if ([responseObject[@"datas"] count] == 0) {
                [self xy_showMessage:@"没有更多数据了"];
                
            } else {
                XYHTTPResponseInfo *info = [XYHTTPResponseInfo responseInfoWithDict:responseObject];
                _activityTopicItem.info = info;
                // 请求数据成功
                if (responseObject[@"datas"] && [responseObject[@"datas"] count] > 0) {
                    
                    // 头像详情中有帖子数组
                    for (id obj in responseObject[@"datas"]) {
                        if ([obj isKindOfClass:[NSDictionary class]]) {
                            XYTrendItem *item = [XYTrendItem trendItemWithDict:obj info:info];
                            
                            // 帖子模型数
                            [_dataList[@(self.currentType)] addObject:[XYTrendViewModel trendViewModelWithTrend:item info:info]];
                        }
                    }
                }
                
            }
        }
        
        [self processingModel:^{
            [self reloadData];
            [WUOHTTPRequest setActivityIndicator:NO];
            [self.mj_footer endRefreshing];
            [self.mj_header endRefreshing];
        }];
    }];
    
}

/// 对模型进行处理 -- 为榜单前10个模型扩展排名属性
- (void)processingModel:(void(^)())block {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
    
        // 榜单数据
        if (self.currentType == XYTopicTypeNewRanklist) {
            NSInteger i = 0;
            BOOL flag = YES;
            while (flag) {
                if (i>_dataList[@(self.currentType)].count-1 || _dataList[@(self.currentType)].count == 0) {
                    flag = NO;
                    break;
                } else {
                    XYTrendViewModel *viewModel = _dataList[@(self.currentType)][i];
                    viewModel.item.ranking = [NSString stringWithFormat:@"    NO.%ld", i+1];
                    if (i == 9) {
                        flag = NO;
                        break;
                    }
                    i++;
                }
            }
            // 要回到主线程中刷新数据源，不然会引发莫名其妙的更新榜单不显示的问题
             [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                 if (block) {
                     block();
                 }
             }];

            // 其他请求，也要回到主线程中
        } else  {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                if (block) {
                    block();
                }
            }];
        }
    });
}

#pragma mark - XYTrendViewCellDelegate 
- (void)topicViewCellDidSelectAvatarView:(XYTrendViewCell *)cell item:(XYTrendItem *)item {
    if (self.activeTopicTableViewdelegate && [self.activeTopicTableViewdelegate respondsToSelector:@selector(activeTopicDetailTableView:didSelectAvatarViewAtIndexPath:item:)]) {
        
        NSIndexPath *indexPath = [self indexPathForCell:cell];
        [self.activeTopicTableViewdelegate activeTopicDetailTableView:self didSelectAvatarViewAtIndexPath:indexPath item:item];
    }
}

- (void)topicViewCell:(XYTrendViewCell *)celll didSelectPraiseBtn:(UIButton *)btn item:(XYTrendItem *)item {
    // 点赞时，发送网络请求，并更新按钮的状态为选中状态，且按钮不再接受点击事件
    [WUOHTTPRequest updateTrendPraiseToUid:item.uid tid:item.tid finishedCallBack:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        if (error) {
            [self xy_showMessage:@"点赞失败哦"];
            return;
        }

        
        if ([responseObject[@"code"] integerValue] == 0) {
            // 点赞成功，修改按钮的状态状态为select
            item.isPraise = YES;
            item.praiseCount+=1;
            [self reloadData];
        }
    }];
    
    
}

#pragma mark - <UITableViewDelegate, UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _dataList[@(self.currentType)].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XYTrendViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    [self drawCell:cell withIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kTrendLabelViewHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    self.selectView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:selectViewIdentifier];
    return self.selectView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat cellHeight = 0.0;
    if (_dataList[@(self.currentType)].count) {
        
        NSArray *datas = _dataList[@(self.currentType)];
        if (indexPath.row < datas.count) {
            
            XYTrendViewModel *viewModel = datas[indexPath.row];
            cellHeight = viewModel.cellHeight;
        }
    }
    
    return cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.activeTopicTableViewdelegate && [self.activeTopicTableViewdelegate respondsToSelector:@selector(activeTopicDetailTableView:didSelectRowAtIndexPath:item:)]) {
        
        XYTrendViewModel *viewModel = [_dataList[@(self.currentType)] objectAtIndex:indexPath.row];
        [self.activeTopicTableViewdelegate activeTopicDetailTableView:self didSelectRowAtIndexPath:indexPath item:viewModel.item];
    }
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [_needLoadList removeAllObjects];
}

/// 按需加载 - 如果目标行与当前行相差超过指定行数，只在目标滚动范围的前后指定3行加载。
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    NSIndexPath *ip = [self indexPathForRowAtPoint:CGPointMake(0, targetContentOffset->y)];
    NSIndexPath *cip = [[self indexPathsForVisibleRows] firstObject];
    NSInteger skipCount = 8;
    if (labs(cip.row-ip.row)>skipCount) {
        NSArray *temp = [self indexPathsForRowsInRect:CGRectMake(0, targetContentOffset->y, self.xy_width, self.xy_height)];
        NSMutableArray *arr = [NSMutableArray arrayWithArray:temp];
        if (velocity.y<0) {
            NSIndexPath *indexPath = [temp lastObject];
            if (indexPath.row+3<_dataList[@(self.currentType)].count) {
                [arr addObject:[NSIndexPath indexPathForRow:indexPath.row+1 inSection:0]];
                [arr addObject:[NSIndexPath indexPathForRow:indexPath.row+2 inSection:0]];
                [arr addObject:[NSIndexPath indexPathForRow:indexPath.row+3 inSection:0]];
            }
        } else {
            NSIndexPath *indexPath = [temp firstObject];
            if (indexPath.row>3) {
                [arr addObject:[NSIndexPath indexPathForRow:indexPath.row-3 inSection:0]];
                [arr addObject:[NSIndexPath indexPathForRow:indexPath.row-2 inSection:0]];
                [arr addObject:[NSIndexPath indexPathForRow:indexPath.row-1 inSection:0]];
            }
        }
        [_needLoadList addObjectsFromArray:arr];
    }
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView{
    _scrollToToping = YES;
    return YES;
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    _scrollToToping = NO;
    [self loadContent];
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView{
    _scrollToToping = NO;
    [self loadContent];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    // 注意：这里默认的的偏移量是-64，越往上滑动scrollView偏移量越大，反之越小
    if (scrollView.contentOffset.y > self.headView.xy_height - kNavigationBarHeight) {
        self.selectView.trendLabelView.separatorBackgroundColor = [UIColor colorWithRed:140 / 255.0 green:140 / 255.0 blue:140 / 255.0 alpha:0.6];
        self.selectView.trendLabelView.backgroundColor = [UIColor whiteColor];
        
    } else {
        self.selectView.trendLabelView.separatorBackgroundColor = [UIColor clearColor];
        self.selectView.trendLabelView.backgroundColor = kColorGlobalCell;
    }
}

#pragma mark - XYCateTitleViewDelegate
- (void)cateTitleView:(XYCateTitleView *)view didSelectedItem:(NSInteger)index {
    NSInteger tempIndex;
    if (index == 0) {
        tempIndex = 1;
    } else if (index == 1) {
        tempIndex = 0;
    }
    self.currentType = tempIndex;
}


#pragma mark - 绘制cell
- (void)drawCell:(XYTrendViewCell *)cell withIndexPath:(NSIndexPath *)indexPath{
    
    // 防止数据错乱时，引发数组越界问题崩溃  , 数据重复请求并添加，导致数据越界问题已经解决，所以不需要在这判断了
    if (_dataList[@(self.currentType)].count == 0 || indexPath.row > _dataList[@(self.currentType)].count - 1) {
        return;
    }
    XYTrendViewModel *viewModel = [_dataList[@(self.currentType)] objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell clear];
    cell.viewModel = viewModel;
    if (_needLoadList.count>0 && [_needLoadList indexOfObject:indexPath] == NSNotFound) {
        [cell clear];
        return;
    }
    if (_scrollToToping) {
        return;
    }
    // 让cell绘制主要的控件
    [cell draw];
}

/// 用户触摸时第一时间加载内容
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    if (!_scrollToToping) {
        [_needLoadList removeAllObjects];
        [self loadContent];
    }
    return [super hitTest:point withEvent:event];
}

- (void)loadContent {
    if (_scrollToToping) {
        return;
    }
    if (self.indexPathsForVisibleRows.count<=0) {
        return;
    }
    if (self.visibleCells && self.visibleCells.count > 0 ) {
        for (id temp in [self.visibleCells copy]) {
            XYTrendViewCell *cell = (XYTrendViewCell *)temp;
            [cell draw];
        }
    }
}

#pragma mark - set \ get
- (void)setCurrentType:(XYTopicType)currentType {
    
    if (_currentType == currentType) {
        return;
    }
    _currentType = currentType;
    
    // 创建数据源容器：根据用户选择的标题信息，创建对应的容器
    if (_dataList.count == 0) {
        // 不包含就创建一个容器存放数据，然后再将容器添加到大数组dataList中
        NSMutableArray *arrM = [NSMutableArray arrayWithCapacity:0];
        [_dataList setObject:arrM forKey:@(currentType)];
        
    } else {
        // 判断当前请求的数据有没有存放它的容器，如果没有就创建一个
        if (![_dataList.allKeys containsObject:@(currentType)]) {
            // 不包含就创建一个容器存放数据，然后再将容器添加到大数组dataList中
            NSMutableArray *arrM = [NSMutableArray arrayWithCapacity:0];
            [_dataList setObject:arrM forKey:@(currentType)];
        }
    }
    
    // 判断用户是否是第一次点击serachLabel标题栏对应的按钮，当字典_cnameDict中所有的key不包含当前的子标题，就是没被点击过
    if (![_cnameDict.allKeys containsObject:@(currentType)]) {
        // 从key取出的是空的，说明是第一次被点击serachLabel对应的按钮，记录第一次被点击了，1是第一次被点击，2是被点击多次了
        [_cnameDict setObject:@1 forKey:@(currentType)];
    }
    
    // 当当前数据源中没有数据时，再去服务器请求数据，不然就只刷新数据源即可
    if (_dataList[@(currentType)].count == 0) {
        _idStamp = 0;
        [self loadTopic];
    } else {
        [self reloadData];
    }

}

- (XYActiveTopicDetailHeaderView *)headView {
    if (_headView == nil) {
        _headView = [XYActiveTopicDetailHeaderView new];
    }
    
    return _headView;
}

/// 数据改变时，更新头部
- (void)setActivityTopicItem:(XYActivityTopicItem *)activityTopicItem {
    
    _activityTopicItem = activityTopicItem;
    if (_isFirst) {
        // 注意: 要先调用下topicDetailHeaderHeight的get，内部的子控件frame都是通过此方法计算的，不然传过去的模型的frame没有值的
        _headView.xy_height = activityTopicItem.topicDetailHeaderHeight;
        self.headView.item = activityTopicItem;
        
        // 将第一次请求到的帖子数据添加到 当前类型的 数据源中
        _dataList[@(self.currentType)] = [activityTopicItem.trendList mutableCopy];
        
        // 当有数据时才去设置selectView
        NSDictionary *dict1 = @{@"labelName": @"最 新"};
        NSDictionary *dict2 = @{@"labelName": @"榜 单"};
        NSArray<NSDictionary *> *labelArr = @[dict1, dict2];
        self.selectView.trendLabelView.channelCates = [labelArr mutableCopy];
        self.selectView.trendLabelView.selectedIndex = 1; // 默认选中第一个按钮
        self.selectView.trendLabelView.delegate = self;
        _isFirst = NO;
    }
    
    [self processingModel:^{
        
        [self reloadData];
    }];
}


- (XYHTTPResponseInfo *)dynamicInfo {
    // 防止数据错乱，每次请求时，去对应子标题的数据源中取info
    if (_dataList[@(self.currentType)].count) {
        // 每次取最后一个info，保证是服务器最新返回的info
        return _dataList[@(self.currentType)].lastObject.info;
    } else {
        return nil;
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_dataList removeAllObjects];
    [_cnameDict removeAllObjects];
    [_needLoadList removeAllObjects];
    _needLoadList = nil;
    _dataList = nil;
    _cnameDict = nil;
    NSLog(@"%s", __func__);
}

@end
