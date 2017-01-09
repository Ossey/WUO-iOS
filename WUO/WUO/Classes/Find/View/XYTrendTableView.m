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

@property (nonatomic, strong) XYDynamicInfo *dynamicInfo;

@end

@implementation XYTrendTableView {
    
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
            [_dataList[self.serachLabel] removeAllObjects];
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
#warning TODO 已解决此问题 此处下拉加载时有问题： 切换页面后，再切换回来 self.dynamicInfo.idstamp为0了
    
    NSLog(@"%@--%ld", self.dynamicInfo, self.dynamicInfo.idstamp);
    
    [WUOHTTPRequest dynamicWithIdstamp:[NSString stringWithFormat:@"%ld",self.dynamicInfo.idstamp] type:self.dataType serachLabel:self.serachLabel finished:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        
        if (error) {
            [self.mj_header endRefreshing];
            [self.mj_footer endRefreshing];
            [WUOHTTPRequest setActivityIndicator:NO];
            [self xy_showMessage:@"网络请求失败"];
            self.loading = NO;
            return;
        }
        
//        if ([responseObject[@"code"] integerValue] == 0 && [responseObject isKindOfClass:[NSDictionary class]]) {
//            // code==0 请求数据成功
//            
//             // 字段中如果包含idstamp ，说明下次还有新的数据，如果不包含，说明下次没有数据
//            if ([[responseObject allKeys] containsObject:@"idstamp"]) {
//                NSLog(@"%ld---%ld", self.dynamicInfo.idstamp, [responseObject[@"idstamp"] integerValue]);
//                // 当上次的idstamp与本地的相同时，说明下次没有数据了，如果再请求数据就重复了
//                if (self.dynamicInfo.idstamp == [responseObject[@"idstamp"] integerValue]) {
//                    [self xy_showMessage:@"没有更多数据了"];
//                    
//                } else {
//                    XYDynamicInfo *info = [XYDynamicInfo dynamicInfoWithDict:responseObject];
//                    
//                    for (id obj in responseObject[@"datas"]) {
//                        if ([obj isKindOfClass:[NSDictionary class]]) {
//                            
//                            XYDynamicItem *item = [XYDynamicItem dynamicItemWithDict:obj info:info];
//                            XYDynamicViewModel *viewModel = [XYDynamicViewModel dynamicViewModelWithItem:item info:info];
//                            
//                            // 将数据添加到对应的容器中，避免被循环利用，数据错乱
//                            [_dataList[self.serachLabel] addObject:viewModel];
//                        }
//                    }
//                }
//               
//                [self reloadData];
//                self.loading = NO;
//            }
//        }
        
        if ([responseObject[@"code"] integerValue] == 0) { // code 为0 说明 请求数据成功
            if ([responseObject[@"datas"] count] == 0) {  // datas 字段是数据 如果数组数量有值，说明有数据
                [self xy_showMessage:@"没有更多数据了"];
                /**
                 问题1.：当没有数据的时候，再次上拉拉加载更多时，数据重复
                 原因：当没有数据时服务器未返回idstamp， 即使为空数据时，idstamp也未返回，此时我更新idstamp字段为空，当idstamp为空意味着下次请求数据为获取最新的数据，所以导致下次又重新请求新的数据了，
                 解决方法：所以服务器返回的空，我不要更新dynamicInfo模型就好了
                 问题2：当上拉当前子标题数据源后，再去加载其他的标题数据源，再切换回来时，当前标题的数据源，数据又被加载了一次，存在重复了
                 问题3: 下拉加载时有问题： 切换页面后，再切换回来 self.dynamicInfo.idstamp为0了
                 原因：经打印内存地址，发现self.dynamicInfo取的确实是self.serachLabel标题对应的info，最关键的错误是，我在每次开始刷新时:self.dynamicInfo.idstamp = 0;当为0时再加载数据又重新开始请求新的的数据了导致数据重复问题；
                 解决方法：不手动更新self.dynamicInfo.idstamp即解决此问题，其实不需要这样，因为我是从_dataList[self.serachLabel]中取info的，当_dataList为空的时候，dynamicInfo为nil，idstamp就为0了
                 问题4：切换子标题数据源时，cell的高度不能及时更新
                 问题5：除了动漫界面外，其他数据下拉刷新时还是重复的
                 原因：问题出在dynamicInfo取值get方法中，每次获取的self.dynamicInfo都是相同的，所以当请求到新的数据时，让self.dynamicInfo更新，使用set方法更新，所以还是重复请求数据, _dataList[self.serachLabel][0].info这里每次更新数据时，第0个模型始终不会改变的，所以取出的info还是同一个info
                解决方法：由于数组添加数据是往后面添加的，第0个元素一直不会改变，所以每次取info时，取最后一个info就可动态获取info的idstamp了，这样请求的数据就不会重复了
                 */
                
            } else {
                
                XYDynamicInfo *info = [XYDynamicInfo dynamicInfoWithDict:responseObject];
                for (id obj in responseObject[@"datas"]) {
                    if ([obj isKindOfClass:[NSDictionary class]]) {
                        
                        XYDynamicItem *item = [XYDynamicItem dynamicItemWithDict:obj info:info];
                        XYDynamicViewModel *viewModel = [XYDynamicViewModel dynamicViewModelWithItem:item info:info];
                        
                        // 将数据添加到对应的容器中，避免被循环利用，数据错乱
                        [_dataList[self.serachLabel] addObject:viewModel];
                    }
                }
            }
            [self reloadData];
            self.loading = NO;
        }
        
        [WUOHTTPRequest setActivityIndicator:NO];
        [self.mj_header endRefreshing];
        [self.mj_footer endRefreshing];
        
    }];
}

- (void)drawCell:(XYDynamicViewCell *)cell withIndexPath:(NSIndexPath *)indexPath{
    
    //    NSLog(@"%@", indexPath);
    // 防止数据错乱时，引发数组越界问题崩溃
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
    // 让cell绘制主要的控件
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
#warning TODO 目前存在的问题1： 上拉拉时数据存在重复，每个子标题对应的数据，来回滑动有错乱的问题
        // 问题1原因：点击子标题按钮时可获取对应的字段去服务器请求数据，而上拉时并不知道字段，问题1已解决
        // 导致的问题2：cell的indexPath、row超出了数据源的长度，取值时就会引发崩溃，先解决此问题，再解决问题1
        // 问题4：切换子标题数据源时，cell的高度不能及时更新
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
//    _dynamicInfo.idstamp = 0;
//    self.dynamicInfo.idstamp = 0;
    [self loadDataFromNetwork];
//    
//    // 取出模型，第一个模型保存了偏移量
//    XYDynamicViewModel *viewModel = _dataList[serachLabel].firstObject;
//    // 当前点击标题按钮如果第一次点击时，第一次被点击的时候，而且标题栏已经在导航条下面固定时，点击其他标题按钮时，让子标题对应的cell，从标题栏下面开始显示，也就是说，第一次被点击的时候，用户并未滑动当前标题对应的cell，就从第一个开始显示
//    if ([[_cnameDict objectForKey:serachLabel] integerValue] == 1) {
//        
//        if (self.contentOffset.y > kTopicViewHeight + kAdvertViewHeight + kHeaderFooterViewInsetMargin - kNavigationBarHeight) {
//            // 由于所有的子标题对应的数据源都是在一个tableView上展示的，这样每次切换数据源时再切回去时，用户上一次查看的页面被刷新了，数据也就从头开始了，目的是让tableView滚动到用户上一次查看的位置
//            dispatch_async(dispatch_get_global_queue(0, 0), ^{
//                
//                [self setContentOffset:CGPointMake(0, kTopicViewHeight + kAdvertViewHeight +    kHeaderFooterViewInsetMargin - kNavigationBarHeight) animated:YES];
//            });
//            
//        } else {
//            if (viewModel.previousContentOffset.y > kTopicViewHeight + kAdvertViewHeight + kHeaderFooterViewInsetMargin - kNavigationBarHeight) {
//                dispatch_async(dispatch_get_global_queue(0, 0), ^{
//                    
//                    [self setContentOffset:viewModel.previousContentOffset animated:YES];
//                });
//            }
//        }
//        
//        // 第一次被点击后，记录下, 告诉下次就属于多次点击
//        [_cnameDict setValue:@2 forKey:serachLabel];
//        return;
//    }
//    
//    if ([[_cnameDict objectForKey:serachLabel] integerValue] == 2) {
//        
//        if (self.contentOffset.y > kTopicViewHeight + kAdvertViewHeight + kHeaderFooterViewInsetMargin - kNavigationBarHeight) {
//            if (viewModel.previousContentOffset.y == 0) {
//                return;
//            }
//            dispatch_async(dispatch_get_global_queue(0, 0), ^{
//                
//                [self setContentOffset:viewModel.previousContentOffset animated:YES];
//            });
//        } else {
//            dispatch_async(dispatch_get_global_queue(0, 0), ^{
//                
//                [self setContentOffset:viewModel.previousContentOffset animated:YES];
//            });
//        
//        }
//    }
//    
//    NSLog(@"%ld", [[_cnameDict objectForKey:serachLabel] integerValue]);
//    
}

- (XYDynamicInfo *)dynamicInfo {
    // 防止数据错乱，每次请求时，去对应子标题的数据源中取info
    if (_dataList[self.serachLabel].count) {
        return _dataList[self.serachLabel].lastObject.info;
    } else {
        return nil;
    }
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

