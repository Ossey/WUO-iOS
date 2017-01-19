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
#import "XYTrendViewCell.h"
#import "XYRefreshGifHeader.h"
#import "XYRefreshGifFooter.h"
#import "WUOHTTPRequest.h"
#import "XYUserInfo.h"
#import "XYTrendViewModel.h"
#import "XYUserHomePageView.h"
#import "XYUserAlbumViewCell.h"

typedef NS_ENUM(NSInteger, XYUserDetailRequestType) {
    XYUserDetailRequestTypeInfo = 0,  // 请求用户信息
    XYUserDetailRequestTypeTopic,     // 请求用户作品
    XYUserDetailRequestTypeAlbum      // 请求相册
};

@interface XYUserDetailTableView () <UITableViewDelegate, UITableViewDataSource, XYCateTitleViewDelegate, XYTrendViewCellDelegate>
@property (nonatomic, strong) XYActiveTopicDetailSelectView *selectView;
@property (nonatomic, strong) XYUserHomePageView *pageView;
@property (nonatomic, assign) XYUserDetailRequestType requestType;
@end

@implementation XYUserDetailTableView {
    NSInteger _idStamp;
    XYUserDetailHeaderView *_headerView;
    NSMutableArray *_needLoadList;
    BOOL _scrollToToping;
    NSMutableDictionary<NSNumber *,NSMutableArray<NSObject *> *> *_dataList;
    NSInteger _page;
    NSMutableArray<XYUserImgItem *> *_albumList;
    /** 是不是第一次进入请求userInfo数据 */
    bool _isFristRequestUserInfo;
}

static NSString * const infoCellIdentifier = @"XYUserHomePageView";
static NSString * const topicCellIdentifier = @"XYTrendViewCell";
static NSString * const albumCellIdentifier = @"XYUserAlubmViewCell";
static NSString * const selectViewIdentifier = @"XYActiveTopicDetailSelectView";
static NSString * const pageViewIdentifier = @"pageViewIdentifier";
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:UITableViewStylePlain]) {
        
        _albumList = [NSMutableArray arrayWithCapacity:0];
        _dataList = [NSMutableDictionary dictionaryWithCapacity:0];
        _needLoadList = [NSMutableArray arrayWithCapacity:3];
        _page = 0;
        self.requestType = XYUserDetailRequestTypeTopic;
        
        _headerView = [XYUserDetailHeaderView new];
        _headerView.xy_height = kSIZE_USER_DETAIL_HEADERVIEW_H;
        self.tableHeaderView = _headerView;
        
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.showsHorizontalScrollIndicator = NO;
        self.delegate = self;
        self.dataSource = self;
        [self registerClass:[XYUserHomePageView class] forCellReuseIdentifier:infoCellIdentifier];
        [self registerClass:[XYTrendViewCell class] forCellReuseIdentifier:topicCellIdentifier];
        [self registerClass:[XYUserAlbumViewCell class] forCellReuseIdentifier:albumCellIdentifier];
        
        [self registerClass:[XYActiveTopicDetailSelectView class] forHeaderFooterViewReuseIdentifier:selectViewIdentifier];
        
        self.mj_header = [XYRefreshGifHeader headerWithRefreshingBlock:^{
            [self loadNewData];
        }];
        
        __block XYTrendViewModel *viewModel;
        self.mj_footer = [XYRefreshGifFooter footerWithRefreshingBlock:^{
            switch (self.requestType) {
                case XYUserDetailRequestTypeTopic:
                     viewModel = (XYTrendViewModel *)_dataList[@(XYUserDetailRequestTypeTopic)].lastObject;
                    _idStamp = viewModel.info.idstamp;
                    [self loadUserTopic];
                    break;
                case XYUserDetailRequestTypeAlbum:
                    _page++;
                    [self loadUserAlbum];
                    break;
                default:
                    break;
            }
            
            
        }];
        
    }
    return self;
}

- (void)loadNewData {
    switch (self.requestType) {
        case XYUserDetailRequestTypeAlbum:
            _page = 1;
            [_albumList removeAllObjects];
            [self loadUserAlbum];
            break;
        case XYUserDetailRequestTypeTopic:
            _idStamp = 0;
            [_dataList[@(XYUserDetailRequestTypeTopic)] removeAllObjects];
            [self loadUserTopic];
            break;
        case XYUserDetailRequestTypeInfo:
            [_dataList[@(XYUserDetailRequestTypeInfo)] removeAllObjects];
            [self loadUserInfo];
            break;
        default:
            break;
    }

}

- (void)setUserInfo:(XYUserInfo *)userInfo {
    _userInfo = userInfo;
    _headerView.userInfo = userInfo;
    _isFristRequestUserInfo = YES;
    
    if (_isFristRequestUserInfo == YES) {
        
        [self loadUserTopic];
        _isFristRequestUserInfo = NO;
    }
}

#pragma mark - 数据请求
// 请求用户信息
- (void)loadUserInfo {
    
    [WUOHTTPRequest setActivityIndicator:YES];
    
    [WUOHTTPRequest userDetail_getUserInfoWithtargetUid:self.userInfo.uid finishedCallBack:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"%@", error.localizedDescription);
            [self xy_showMessage:@"网络请求失败"];
            [WUOHTTPRequest setActivityIndicator:NO];
            return;
        }
        
        if ([responseObject[@"code"] integerValue] == 0) {
            XYHTTPResponseInfo *info = [XYHTTPResponseInfo responseInfoWithDict:responseObject];
            if (responseObject[@"userInfo"] && [responseObject[@"userInfo"] isKindOfClass:[NSDictionary class]]) {
                [_dataList[@(self.requestType)] addObject:[XYUserInfo userInfoWithDict:responseObject[@"userInfo"] responseInfo:info]];
            }
        }
        
        [WUOHTTPRequest setActivityIndicator:NO];
        [self.mj_header endRefreshing];
        [self reloadData];
    }];
    
}

// 请求相册
- (void)loadUserAlbum {
    
    [WUOHTTPRequest setActivityIndicator:YES];
    [WUOHTTPRequest userDetail_getUserAlbumWithPage:_page targetUid:self.userInfo.uid finishedCallBack:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"%@", error.localizedDescription);
            [self xy_showMessage:@"网络请求失败"];
            [WUOHTTPRequest setActivityIndicator:NO];
            [self.mj_footer endRefreshing];
            [self.mj_header endRefreshing];
            _page--;
            return;
        }
        
        if ([responseObject[@"code"] integerValue] == 0 && [responseObject isKindOfClass:[NSDictionary class]]) {
            XYHTTPResponseInfo *info = [XYHTTPResponseInfo responseInfoWithDict:responseObject];
            if (responseObject[@"datas"] && [responseObject[@"datas"] count]) {
                if ([responseObject[@"datas"] isKindOfClass:[NSArray class]]) {
                    for (id obj in responseObject[@"datas"]) {
                        if ([obj isKindOfClass:[NSDictionary class]]) {
                            
                            [_albumList addObject:[XYUserImgItem imgItemWithDict:obj responseInfo:info]];
                        }
                    }
                    
                }
                self.mj_footer.hidden = NO;
                
            } else {
                [self xy_showMessage:@"没有更多相片了"];
                self.mj_footer.hidden = YES;
            }
        }
        [self reloadData];
        [self.mj_footer endRefreshing];
        [self.mj_header endRefreshing];
        [WUOHTTPRequest setActivityIndicator:NO];
    }];
}

// 请求用户作品
- (void)loadUserTopic {
    
    [WUOHTTPRequest setActivityIndicator:YES];
    [WUOHTTPRequest userDetail_getUserTopicByUid:self.userInfo.uid idstamp:[NSString stringWithFormat:@"%ld", (long)_idStamp] finishedCallBack:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"%@", error.localizedDescription);
            [self xy_showMessage:@"网络请求失败"];
            [WUOHTTPRequest setActivityIndicator:NO];
            [self.mj_footer endRefreshing];
            [self.mj_header endRefreshing];
            return;
        }
        
        if ([responseObject[@"code"] integerValue] == 0 && [responseObject isKindOfClass:[NSDictionary class]]) {
            XYHTTPResponseInfo *info = [XYHTTPResponseInfo responseInfoWithDict:responseObject];
            if (responseObject[@"datas"] && [responseObject[@"datas"] count]) {
                if ([responseObject[@"datas"] isKindOfClass:[NSArray class]]) {
                    for (id obj in responseObject[@"datas"]) {
                        if ([obj isKindOfClass:[NSDictionary class]]) {
                            XYTrendViewModel *viewModel = [XYTrendViewModel trendViewModelWithTrend:[XYTrendItem trendItemWithDict:obj info:info] info:info];
                            [_dataList[[NSNumber numberWithInteger:XYUserDetailRequestTypeTopic]] addObject:viewModel];
                        }
                    }
                    self.mj_footer.hidden = NO;
                }
            } else {
                self.mj_footer.hidden = YES;
            }
        }
        
        [self.mj_footer endRefreshing];
        [self.mj_header endRefreshing];
        [WUOHTTPRequest setActivityIndicator:NO];
        [self reloadData];
    }];
}



#pragma mark - <UITableViewDelegate, UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _dataList[@(self.requestType)].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    switch (_requestType) {
        case XYUserDetailRequestTypeTopic:
            cell = (XYTrendViewCell *)[tableView dequeueReusableCellWithIdentifier:topicCellIdentifier forIndexPath:indexPath];
            [self drawCell:(XYTrendViewCell *)cell withIndexPath:indexPath];
            [((XYTrendViewCell *)cell) setDelegate:self];
            break;
            
        case XYUserDetailRequestTypeInfo:
            cell = [tableView dequeueReusableCellWithIdentifier:infoCellIdentifier forIndexPath:indexPath];
            ((XYUserHomePageView *)cell).userInfo = (XYUserInfo *)_dataList[@(self.requestType)].firstObject;
            break;
            
        case XYUserDetailRequestTypeAlbum:
            cell = [tableView dequeueReusableCellWithIdentifier:albumCellIdentifier forIndexPath:indexPath];
            ((XYUserAlbumViewCell *)cell).albumList = (NSMutableArray *)_dataList[@(XYUserDetailRequestTypeAlbum)].firstObject;
            break;
            
        default:
            break;
    }
 
    return cell;
}

#pragma mark -
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kTrendLabelViewHeight;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return self.selectView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger albumRow;
    CGFloat height = 0;
    switch (_requestType) {
        case XYUserDetailRequestTypeInfo:
            height = kSIZE_USER_DETAIL_HOMEPAGE_H;
            break;
            
        case XYUserDetailRequestTypeAlbum:
            // 高度为collectionViewCell的行数 * cell的高度
            // 行数的计算：每行两个item，根据数据源计算 相片的个数 % 2 ,如果除2为基数，也算一行
            // 不过，可以通过修改一次请求的数据解决
            if (_albumList.count % 2 == 0) {
                albumRow = _albumList.count * 0.5;
            } else {
                albumRow = (_albumList.count+1) * 0.5;
            }

            height = albumRow * kSIZE_ALBUM_ITEM_H;
            break;
            
        case XYUserDetailRequestTypeTopic:
            if (_dataList[@(self.requestType)].count) {
                
                NSArray *datas = _dataList[@(self.requestType)];
                if (indexPath.row < datas.count) {
                    
                    XYTrendViewModel *viewModel = datas[indexPath.row];
                    height = viewModel.cellHeight;
                }
            }
            
        default:
            break;
    }
    return height;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (self.requestType == XYUserDetailRequestTypeTopic) {
        
        [_needLoadList removeAllObjects];
    }
}

/// 按需加载 - 如果目标行与当前行相差超过指定行数，只在目标滚动范围的前后指定3行加载。
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    if (self.requestType == XYUserDetailRequestTypeTopic) {
        NSIndexPath *ip = [self indexPathForRowAtPoint:CGPointMake(0, targetContentOffset->y)];
        NSIndexPath *cip = [[self indexPathsForVisibleRows] firstObject];
        NSInteger skipCount = 8;
        if (labs(cip.row-ip.row)>skipCount) {
            NSArray *temp = [self indexPathsForRowsInRect:CGRectMake(0, targetContentOffset->y, self.xy_width, self.xy_height)];
            NSMutableArray *arr = [NSMutableArray arrayWithArray:temp];
            if (velocity.y<0) {
                NSIndexPath *indexPath = [temp lastObject];
                if (indexPath.row+3<_dataList[@(self.requestType)].count) {
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
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView{
    if (self.requestType == XYUserDetailRequestTypeTopic) {
        
        _scrollToToping = YES;
    }
    return YES;
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    if (self.requestType == XYUserDetailRequestTypeTopic) {
        _scrollToToping = NO;
        [self loadContent];
    }
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView{
    if (self.requestType == XYUserDetailRequestTypeTopic) {
        _scrollToToping = NO;
        [self loadContent];
    }

}




#pragma mark - 绘制cell
- (void)drawCell:(XYTrendViewCell *)cell withIndexPath:(NSIndexPath *)indexPath{
    
    // 防止数据错乱时，引发数组越界问题崩溃  , 数据重复请求并添加，导致数据越界问题已经解决，所以不需要在这判断了
    if (_dataList[@(self.requestType)].count == 0 || indexPath.row > _dataList[@(self.requestType)].count - 1) {
        return;
    }
    XYTrendViewModel *viewModel = (XYTrendViewModel *)[_dataList[@(self.requestType)] objectAtIndex:indexPath.row];
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
    if (self.requestType == XYUserDetailRequestTypeTopic) {
        if (!_scrollToToping) {
            [_needLoadList removeAllObjects];
            [self loadContent];
        }
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


#pragma mark - XYCateTitleViewDelegate
- (void)cateTitleView:(XYCateTitleView *)view didSelectedItem:(NSInteger)index {
   
    self.requestType = index;
}

- (XYActiveTopicDetailSelectView *)selectView {
    if (_selectView == nil) {
        self.selectView = [self dequeueReusableHeaderFooterViewWithIdentifier:selectViewIdentifier];
        // 当有数据时才去设置selectView
        NSDictionary *dict1 = @{@"labelName": @"主页"};
        NSDictionary *dict2 = @{@"labelName": @"作品"};
        NSDictionary *dict3 = @{@"labelName": @"相册"};
        NSArray<NSDictionary *> *labelArr = @[dict1, dict2, dict3];
        self.selectView.trendLabelView.channelCates = [labelArr mutableCopy];
        self.selectView.trendLabelView.backgroundColor = [UIColor whiteColor];
        self.selectView.trendLabelView.selectedIndex = XYUserDetailRequestTypeTopic; // 默认选中第一个按钮
        self.selectView.trendLabelView.delegate = self;
        self.selectView.trendLabelView.itemScale = 0.0;

    }
    return _selectView;
}

- (void)setRequestType:(XYUserDetailRequestType)requestType {
    
    if (_requestType == requestType) {
        return;
    }
    _requestType = requestType;
    
    // 创建数据源容器：根据用户选择的标题信息，创建对应的容器
    if (_dataList.count == 0) {
        // 不包含就创建一个容器存放数据，然后再将容器添加到大数组dataList中
        NSMutableArray *arrM = [NSMutableArray arrayWithCapacity:0];
        [_dataList setObject:arrM forKey:@(requestType)];
        
    } else {
        // 判断当前请求的数据有没有存放它的容器，如果没有就创建一个
        if (![_dataList.allKeys containsObject:@(requestType)]) {
            // 不包含就创建一个容器存放数据，然后再将容器添加到大数组dataList中
            NSMutableArray *arrM = [NSMutableArray arrayWithCapacity:0];
            [_dataList setObject:arrM forKey:@(requestType)];
            
            if (requestType == XYUserDetailRequestTypeAlbum) {
                [_dataList[@(XYUserDetailRequestTypeAlbum)] addObject:_albumList];
            }
        }
    }
    
    _idStamp = 0;
    
    
    [self loadNewData];
    if (requestType == XYUserDetailRequestTypeInfo) {
        self.mj_footer.hidden = YES;
    } else {
        self.mj_footer.hidden = NO;
    }
}
- (void)dealloc {
    
    [super removeFromSuperview];
    [_dataList removeAllObjects];
    [_needLoadList removeAllObjects];
    _needLoadList = nil;
    _dataList = nil;
    NSLog(@"%s", __func__);
}



@end
