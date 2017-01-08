//
//  XYTrendTableView.m
//  WUO
//
//  Created by mofeini on 17/1/6.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//


//#pragma mark - XYDynamicTableViewDelegate
//- (void)dynamicTableViewDidEndDecelerating:(UIScrollView *)scrollView {
//    
//    // 发布scrollView停止减速的通知
//    NSNotificationName const XYTrendTableViewDidEndDeceleratingNote = @"XYTrendTableViewDidEndDeceleratingNote";
//    [[NSNotificationCenter defaultCenter] postNotificationName:XYTrendTableViewDidEndDeceleratingNote object:scrollView userInfo:nil];
//}
//
//- (void)dynamicTableViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
//
//        // 发布停止拖拽scrollView的通知
//    [[NSNotificationCenter defaultCenter] postNotificationName:XYTrendTableViewDidEndDraggingNote object:scrollView userInfo:@{@"isDecelerate" : @(decelerate)}];
//    
//}
//
//- (void)dynamicTableViewDidScroll:(UIScrollView *)scrollView {
//    
//    [[NSNotificationCenter defaultCenter] postNotificationName:XYTrendTableViewDidScrollNote object:scrollView userInfo:nil];
//}



#import "XYTrendTableView.h"
#import "XYRefreshGifFooter.h"
#import "XYRefreshGifHeader.h"
#import "XYDynamicViewModel.h"
#import "WUOHTTPRequest.h"
#import "XYDynamicViewCell.h"

@interface XYTrendTableView () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation XYTrendTableView {
    
    XYDynamicInfo *_dynamicInfo;
    NSMutableArray *_needLoadList;
    BOOL _scrollToToping;
    /** 将每一种标题类型的数据组作为value，标题作为key放在这个数组中, 按照当前点击的serachLabel去_dataList查找对应数据 */
    NSMutableDictionary<NSString *,NSMutableArray<XYDynamicViewModel *> *> *_dataList;
    NSMutableDictionary<NSString *, NSNumber *> *_cnameDict;
}

static NSString * const cellIdentifier = @"XYDynamicViewCell";
@synthesize serachLabel = _serachLabel;

- (instancetype)initWithFrame:(CGRect)frame dataType:(NSInteger)type
{
    self = [super initWithFrame:frame style:UITableViewStyleGrouped];
    if (self) {
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.dataSource = self;
        self.delegate = self;
        self.showsHorizontalScrollIndicator = NO;
        
        _dataList = [NSMutableDictionary dictionaryWithCapacity:0];
        _needLoadList = [[NSMutableArray alloc] init];
        _cnameDict = [NSMutableDictionary dictionaryWithCapacity:1];
        [self registerClass:[XYDynamicViewCell class] forCellReuseIdentifier:cellIdentifier];
        
        self.mj_header = [XYRefreshGifHeader headerWithRefreshingBlock:^{
            _dynamicInfo.idstamp = 0;
            [self loadData];
        }];
        
        
        self.mj_footer = [XYRefreshGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
        // 忽略多少底部
        self.mj_footer.ignoredScrollViewContentInsetBottom = -10;
//        [self.mj_header beginRefreshing];
        self.dataType = type;
        
        __weak typeof(self) weak_self = self;
        self.cnameBlock = ^(NSString *cname) {
            weak_self.serachLabel = cname;
        };
        
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
    
    self.loading = YES; // 正在加载中提示
    [WUOHTTPRequest setActivityIndicator:YES];
    
    [WUOHTTPRequest dynamicWithIdstamp:[NSString stringWithFormat:@"%ld",_dynamicInfo.idstamp] type:self.dataType serachLabel:self.serachLabel finished:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        
        if (error) {
            [self.mj_header endRefreshing];
            [self.mj_footer endRefreshing];
            [WUOHTTPRequest setActivityIndicator:NO];
            [self xy_showMessage:@"网络请求失败"];
            self.loading = NO;
            return;
        }
        
        _dynamicInfo = [XYDynamicInfo dynamicInfoWithDict:responseObject];
        
        if ([responseObject[@"code"] integerValue] == 0) {
            if ([responseObject[@"datas"] count] == 0) {
                [self xy_showMessage:@"没有更多数据了"];
            } else {
                for (id obj in responseObject[@"datas"]) {
                    if ([obj isKindOfClass:[NSDictionary class]]) {
                        
                        XYDynamicItem *item = [XYDynamicItem dynamicItemWithDict:obj info:_dynamicInfo];
                        XYDynamicViewModel *viewModel = [XYDynamicViewModel dynamicViewModelWithItem:item info:_dynamicInfo];
                        
                        // 将数据添加到对应的容器中，避免产生循环引用
                        [_dataList[self.serachLabel] addObject:viewModel];
                    }
                }
            }
        }
        
        [WUOHTTPRequest setActivityIndicator:NO];
        
        [self.mj_header endRefreshing];
        [self.mj_footer endRefreshing];
        [self reloadData];
        self.loading = NO;
    }];
}

- (void)drawCell:(XYDynamicViewCell *)cell withIndexPath:(NSIndexPath *)indexPath{
    
//    NSLog(@"%@", indexPath);
    if (_dataList[self.serachLabel].count == 0 || indexPath.row > _dataList[self.serachLabel].count - 1) {
        return;
    }
    XYDynamicViewModel *viewModel = [_dataList[self.serachLabel] objectAtIndex:indexPath.row];
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



#pragma mark - <UITableViewDataSource, UITableViewDelegate>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _dataList[self.serachLabel].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XYDynamicViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    [self drawCell:cell withIndexPath:indexPath];
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat cellHeight = 0.0;
    if (_dataList[self.serachLabel].count) {
        
        NSArray *datas = _dataList[self.serachLabel];
#warning TODO 目前存在的问题1： cell循环利用了，每个子标题对应的数据，来回滑动有错乱的问题
        // 导致的问题2：cell的indexPath、row超出了数据源的长度，取值时就会引发崩溃，先解决此问题，再解决问题1
        if (indexPath.row < datas.count - 1) {
            
            XYDynamicViewModel *viewModel = datas[indexPath.row];
            cellHeight = viewModel.cellHeight;
        }
    }
    
    return cellHeight;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"%@", NSStringFromCGRect([tableView dequeueReusableCellWithIdentifier:cellIdentifier].frame));
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat height = 0.0;
    
    if (self.dynamicDelegate && [self.dynamicDelegate respondsToSelector:@selector(dynamicTableView:heightForHeaderInSection:)]) {
        height = [self.dynamicDelegate dynamicTableView:self heightForHeaderInSection:section];
    }
    return height;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
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
            if (indexPath.row+3<_dataList[self.serachLabel].count) {
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
    
//    NSLog(@"contentOffset--%@", NSStringFromCGPoint(scrollView.contentOffset));
}

/// 触摸scrollView并拖拽画面，再松开时，触发该函数
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (self.dynamicDelegate && [self.dynamicDelegate respondsToSelector:@selector(dynamicTableViewDidEndDragging:willDecelerate:)]) {
        [self.dynamicDelegate dynamicTableViewDidEndDragging:self willDecelerate:decelerate];
    }
    
    // 当没有产生减速效果时，不会调用scrollView的scrollViewDidEndDecelerating方法，这里就需要记录最终偏移量
    if (!decelerate) {
        // 当标题栏在顶部固定的时候，才去记录偏移量
//        if (self.contentOffset.y > kTopicViewHeight + kAdvertViewHeight + kHeaderFooterViewInsetMargin - kNavigationBarHeight) {
            // 记录停止拖拽时rendTableView的偏移量
            XYDynamicViewModel *viewModel = _dataList[self.serachLabel].firstObject;
            viewModel.previousContentOffset = scrollView.contentOffset;
            
//        }
    }
}

/// scrollView产生减速效果，在减速结束后调用
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.dynamicDelegate && [self.dynamicDelegate respondsToSelector:@selector(dynamicTableViewDidEndDecelerating:)]) {
        [self.dynamicDelegate dynamicTableViewDidEndDecelerating:scrollView];
    }
    
    // 当标题栏在顶部固定的时候，才去记录偏移量
//    if (self.contentOffset.y > kTopicViewHeight + kAdvertViewHeight + kHeaderFooterViewInsetMargin - kNavigationBarHeight) {
        // 记录停止拖拽时rendTableView的偏移量
        XYDynamicViewModel *viewModel = _dataList[self.serachLabel].firstObject;
        viewModel.previousContentOffset = scrollView.contentOffset;

//    }
    
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
            XYDynamicViewCell *cell = (XYDynamicViewCell *)temp;
            [cell draw];
        }
    }
}


/// 点击标题按钮时调用
- (void)setSerachLabel:(NSString *)serachLabel {
    
    if ([_serachLabel isEqualToString:serachLabel]) {
        return;
    }
    _serachLabel = serachLabel;
    
    // 创建数据源容器：根据用户选择的标题信息，创建对应的容器
    if (_dataList.count == 0) {
        // 不包含就创建一个容器存放数据，然后再将容器添加到大数组dataList中
        NSMutableArray *arrM = [NSMutableArray arrayWithCapacity:0];
        [_dataList setValue:arrM forKey:serachLabel];
        
    } else {
        // 判断当前请求的数据有没有存放它的容器，如果没有就创建一个
        if (![_dataList.allKeys containsObject:serachLabel]) {
            // 不包含就创建一个容器存放数据，然后再将容器添加到大数组dataList中
            NSMutableArray *arrM = [NSMutableArray arrayWithCapacity:0];
            [_dataList setValue:arrM forKey:serachLabel];
        }
    }

    // 判断用户是否是第一次点击serachLabel标题栏对应的按钮
    if (![_cnameDict objectForKey:serachLabel]) {
        // 从key取出的是空的，说明是第一次被点击serachLabel对应的按钮，记录第一次被点击了，1是第一次被点击，2是被点击多次了
        [_cnameDict setValue:@1 forKey:serachLabel];
    }
    
    // 直接调beginRefreshing，每次点击标题按钮都会让tableView回到顶部，体验不好的感觉
    //    [self.mj_header beginRefreshing];
    // 每次点击标题按钮时等于刷新数据，需要重置idstamp，不然某些界面因参数问题，是无法获取到完整数据
    _dynamicInfo.idstamp = 0;
    [self loadDataFromNetwork];
    
    // 取出模型，第一个模型保存了偏移量
    XYDynamicViewModel *viewModel = _dataList[serachLabel].firstObject;
    // 当前点击标题按钮如果第一次点击时，第一次被点击的时候，而且标题栏已经在导航条下面固定时，点击其他标题按钮时，让子标题对应的cell，从标题栏下面开始显示，也就是说，第一次被点击的时候，用户并未滑动当前标题对应的cell，就从第一个开始显示
    if ([[_cnameDict objectForKey:serachLabel] integerValue] == 1) {
        
        if (self.contentOffset.y > kTopicViewHeight + kAdvertViewHeight + kHeaderFooterViewInsetMargin - kNavigationBarHeight) {
            // 由于所有的子标题对应的数据源都是在一个tableView上展示的，这样每次切换数据源时再切回去时，用户上一次查看的页面被刷新了，数据也就从头开始了，目的是让tableView滚动到用户上一次查看的位置
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                
                [self setContentOffset:CGPointMake(0, kTopicViewHeight + kAdvertViewHeight +    kHeaderFooterViewInsetMargin - kNavigationBarHeight) animated:YES];
            });
            
        } else {
            if (viewModel.previousContentOffset.y > kTopicViewHeight + kAdvertViewHeight + kHeaderFooterViewInsetMargin - kNavigationBarHeight) {
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    
                    [self setContentOffset:viewModel.previousContentOffset animated:YES];
                });
            }
        }
        
        // 第一次被点击后，记录下, 告诉下次就属于多次点击
        [_cnameDict setValue:@2 forKey:serachLabel];
        return;
    }
    
    if ([[_cnameDict objectForKey:serachLabel] integerValue] == 2) {
        
        if (self.contentOffset.y > kTopicViewHeight + kAdvertViewHeight + kHeaderFooterViewInsetMargin - kNavigationBarHeight) {
            if (viewModel.previousContentOffset.y == 0) {
                return;
            }
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                
                [self setContentOffset:viewModel.previousContentOffset animated:YES];
            });
        } else {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                
                [self setContentOffset:viewModel.previousContentOffset animated:YES];
            });
        
        }
    }
    
    NSLog(@"%ld", [[_cnameDict objectForKey:serachLabel] integerValue]);
    
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

