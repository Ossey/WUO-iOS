//
//  XYDynamicTableView.m
//  WUO
//
//  Created by mofeini on 17/1/3.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

#import "XYDynamicTableView.h"
#import "XYRefreshGifFooter.h"
#import "XYRefreshGifHeader.h"
#import "XYTopicViewModel.h"
#import "WUOHTTPRequest.h"
#import "XYTopicViewCell.h"

@interface XYDynamicTableView () <UITableViewDelegate, UITableViewDataSource, XYTopicViewCellDelegate>

@property (nonatomic, strong) XYHTTPResponseInfo *dynamicInfo;

@end

@implementation XYDynamicTableView {
        
    NSMutableArray<XYTopicViewModel *> *_dynamicList;
    NSMutableArray *_needLoadList;
    BOOL _scrollToToping;
}

static NSString * const cellIdentifier = @"XYTopicViewCell";
@synthesize serachLabel = _serachLabel;

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    
    if (self = [super initWithFrame:frame style:style]) {
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.dataSource = self;
        self.delegate = self;
        self.showsHorizontalScrollIndicator = NO;
        
        _dynamicList = [NSMutableArray arrayWithCapacity:0];
        _needLoadList = [[NSMutableArray alloc] init];
        
        [self registerClass:[XYTopicViewCell class] forCellReuseIdentifier:cellIdentifier];
        
        self.mj_header = [XYRefreshGifHeader headerWithRefreshingBlock:^{
            _dynamicInfo.idstamp = 0;
            // 当下拉刷新时，移除数据，不然idstamp = 0时，又会将数据重新添加到数组中
            [_dynamicList removeAllObjects];
            [self loadData];
        }];
        
        
        self.mj_footer = [XYRefreshGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
        
        [self.mj_header beginRefreshing];
        
        // 当点击再次刷新时调用
        [self gzwLoading:^{
            [self loadData];
        }];
    }
    return self;
}

- (void)loadData {
    [self loadDataFromNetwork];
}

- (void)loadDataFromNetwork {
    
    self.loading = YES;
    
    [WUOHTTPRequest setActivityIndicator:YES];
    
    NSLog(@"%ld", (long)_dynamicInfo.idstamp);
    [WUOHTTPRequest topicWithIdstamp:[NSString stringWithFormat:@"%ld",(long)_dynamicInfo.idstamp] type:self.dataType serachLabel:self.serachLabel finished:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        
        if (error) {
            [self.mj_header endRefreshing];
            [self.mj_footer endRefreshing];
            [WUOHTTPRequest setActivityIndicator:NO];
            [self xy_showMessage:@"网络请求失败"];
            self.loading = NO;
            return;
        }
        
        if ([responseObject[@"code"] integerValue] == 0) {
            if ([responseObject[@"datas"] count] == 0) {
                [self xy_showMessage:@"没有更多数据了"];
            } else {
                
                // 当有数据时，才更新dynamic，避免无数据时idstamp为空，就导致下次请求数据时，又重新开始请求了
                _dynamicInfo = [XYHTTPResponseInfo responseInfoWithDict:responseObject];
                for (id obj in responseObject[@"datas"]) {
                    if ([obj isKindOfClass:[NSDictionary class]]) {
                        
                        XYTopicItem *item = [XYTopicItem topicItemWithDict:obj info:_dynamicInfo];
                        XYTopicViewModel *viewModel = [XYTopicViewModel topicViewModelWithTopic:item info:_dynamicInfo];
                        [_dynamicList addObject:viewModel];
                    }
                }
                
                [self reloadData];
                self.loading = NO;
            }
        }
        
        [WUOHTTPRequest setActivityIndicator:NO];
        [self.mj_header endRefreshing];
        [self.mj_footer endRefreshing];

        
    }];
}

- (void)drawCell:(XYTopicViewCell *)cell withIndexPath:(NSIndexPath *)indexPath{
    XYTopicViewModel *viewModel = [_dynamicList objectAtIndex:indexPath.row];
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
    [cell draw];
}

#pragma mark - <XYTopicViewCellDelegate>
- (void)topicViewCellDidSelectAvatarView:(XYTopicViewCell *)cell item:(XYTopicItem *)item {
    
    if (self.dynamicDelegate && [self.dynamicDelegate respondsToSelector:@selector(dynamicTableView:didSelectAvatarViewAtIndexPath: item:)]) {
        NSIndexPath *indexPath = [self indexPathForCell:cell];
        [self.dynamicDelegate dynamicTableView:self didSelectAvatarViewAtIndexPath:indexPath item:item];
    }
}

#pragma mark - <UITableViewDataSource, UITableViewDelegate>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _dynamicList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XYTopicViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    [self drawCell:cell withIndexPath:indexPath];
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    XYTopicViewModel *viewModel = _dynamicList[indexPath.row];
    return viewModel.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"%@", [tableView dequeueReusableCellWithIdentifier:cellIdentifier]);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat height = 0.0;
    if (self.dynamicDelegate && [self.dynamicDelegate respondsToSelector:@selector(dynamicTableView:heightForHeaderInSection:)]) {
        height = [self.dynamicDelegate dynamicTableView:self heightForHeaderInSection:section];
    }
    return height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = nil;
    if (self.dynamicDelegate && [self.dynamicDelegate respondsToSelector:@selector(dynamicTableView:viewForHeaderInSection:)]) {
        view = [self.dynamicDelegate dynamicTableView:self viewForHeaderInSection:section];
    }
    return view;
}


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
            if (indexPath.row+3<_dynamicList.count) {
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
    
    if (self.dynamicDelegate && [self.dynamicDelegate respondsToSelector:@selector(dynamicTableViewDidScroll:)]) {
        [self.dynamicDelegate dynamicTableViewDidScroll:self];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (self.dynamicDelegate && [self.dynamicDelegate respondsToSelector:@selector(dynamicTableViewDidEndDragging:willDecelerate:)]) {
        [self.dynamicDelegate dynamicTableViewDidEndDragging:self willDecelerate:decelerate];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.dynamicDelegate && [self.dynamicDelegate respondsToSelector:@selector(dynamicTableViewDidEndDecelerating:)]) {
        [self.dynamicDelegate dynamicTableViewDidEndDecelerating:scrollView];
    }
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
            XYTopicViewCell *cell = (XYTopicViewCell *)temp;
            [cell draw];
        }
    }
}

- (void)setDataType:(NSInteger)type serachLabel:(NSString *)serachLabel {
    
    if (self.dataType == type && [self.serachLabel isEqualToString:serachLabel]) {
        return;
    }
    
    self.dataType = type;
    self.serachLabel = serachLabel;
    // 当type或serachLabel发生改变时，重新加载网络
    [self loadDataFromNetwork];
    
}

- (void)setSerachLabel:(NSString *)serachLabel {
    if ([_serachLabel isEqualToString:serachLabel]) {
        return;
    }
    _serachLabel = serachLabel;
    [self loadDataFromNetwork];
}

- (NSInteger)dataType {
    
    return _dataType ?: 1;
}

- (NSString *)serachLabel {
    return _serachLabel ?: @"";
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    NSLog(@"%s", __func__);
}

@end
