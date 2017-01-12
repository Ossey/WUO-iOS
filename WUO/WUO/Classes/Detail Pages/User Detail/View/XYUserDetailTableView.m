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
#import "XYRefreshGifHeader.h"
#import "XYRefreshGifFooter.h"
#import "WUOHTTPRequest.h"
#import "XYUserInfo.h"
#import "XYTopicViewModel.h"
#import "XYUserHomePageView.h"
#import "XYUserAlbumViewCell.h"

typedef NS_ENUM(NSInteger, XYUserDetailRequestType) {
    XYUserDetailRequestTypeInfo = 0,  // 请求用户信息
    XYUserDetailRequestTypeTopic,     // 请求用户作品
    XYUserDetailRequestTypeAlbum      // 请求相册
};

@interface XYUserDetailTableView () <UITableViewDelegate, UITableViewDataSource, XYCateTitleViewDelegate>
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
}

static NSString * const infoCellIdentifier = @"XYUserHomePageView";
static NSString * const topicCellIdentifier = @"XYTopicViewCell";
static NSString * const albumCellIdentifier = @"XYUserAlubmViewCell";
static NSString * const selectViewIdentifier = @"XYActiveTopicDetailSelectView";
static NSString * const pageViewIdentifier = @"pageViewIdentifier";
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:UITableViewStylePlain]) {
        
        _dataList = [NSMutableDictionary dictionaryWithCapacity:0];
        _needLoadList = [NSMutableArray arrayWithCapacity:3];
        _page = 1;
        self.requestType = XYUserDetailRequestTypeTopic;
        
        _headerView = [XYUserDetailHeaderView new];
        _headerView.xy_height = SIZE_USER_DETAIL_HEADERVIEW_H;
        self.tableHeaderView = _headerView;
        
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.showsHorizontalScrollIndicator = NO;
        self.delegate = self;
        self.dataSource = self;
        [self registerClass:[XYUserHomePageView class] forCellReuseIdentifier:infoCellIdentifier];
        [self registerClass:[XYTopicViewCell class] forCellReuseIdentifier:topicCellIdentifier];
        [self registerClass:[XYUserAlbumViewCell class] forCellReuseIdentifier:albumCellIdentifier];
        
        [self registerClass:[XYActiveTopicDetailSelectView class] forHeaderFooterViewReuseIdentifier:selectViewIdentifier];
        
        
        self.mj_header = [XYRefreshGifHeader headerWithRefreshingBlock:^{
            switch (self.requestType) {
                case XYUserDetailRequestTypeAlbum:
                    [self loadUserAlbum];
                    break;
                case XYUserDetailRequestTypeTopic:
                    _idStamp = 0;
                    [self loadUserTopic];
                    break;
                case XYUserDetailRequestTypeInfo:
                    [_dataList[@(XYUserDetailRequestTypeInfo)] removeAllObjects];
                    [self loadUserInfo];
                    break;
                default:
                    break;
            }
        }];
        
        self.mj_footer = [XYRefreshGifFooter footerWithRefreshingBlock:^{
            switch (self.requestType) {
                case XYUserDetailRequestTypeTopic:
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

- (void)setUserInfo:(XYUserInfo *)userInfo {
    _userInfo = userInfo;
    _headerView.userInfo = userInfo;
    
    [self loadUserTopic];
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
                            
                            [_dataList[@(self.requestType)] addObject:[XYUserImgItem userImgItemWithDict:obj responseInfo:info]];
                        }
                    }
                }
                
            } else {
                [self xy_showMessage:@"没有更多相片了"];
                _page--;
            }
        }
        
        [self.mj_footer endRefreshing];
        [self.mj_header endRefreshing];
        [self reloadData];
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
            if (responseObject[@"datas"] && [responseObject[@"datas"] isKindOfClass:[NSArray class]]) {
                for (id obj in responseObject[@"datas"]) {
                    if ([obj isKindOfClass:[NSDictionary class]]) {
                       XYTopicViewModel *viewModel = [XYTopicViewModel topicViewModelWithTopic:[XYTopicItem topicItemWithDict:obj info:info] info:info];
                        [_dataList[[NSNumber numberWithInteger:XYUserDetailRequestTypeTopic]] addObject:viewModel];
                    }
                }
            }
        }
        
        [self.mj_footer endRefreshing];
        [self.mj_header endRefreshing];
        [self reloadData];
        [WUOHTTPRequest setActivityIndicator:NO];
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
            cell = [tableView dequeueReusableCellWithIdentifier:topicCellIdentifier forIndexPath:indexPath];
            [self drawCell:(XYTopicViewCell *)cell withIndexPath:indexPath];
            break;
            
        case XYUserDetailRequestTypeInfo:
            cell = [tableView dequeueReusableCellWithIdentifier:infoCellIdentifier forIndexPath:indexPath];
            break;
            
        case XYUserDetailRequestTypeAlbum:
            cell = [tableView dequeueReusableCellWithIdentifier:albumCellIdentifier forIndexPath:indexPath];
            break;
            
        default:
            break;
    }
 
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kTrendLabelViewHeight;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return self.selectView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    CGFloat height = 0;
    switch (_requestType) {
        case XYUserDetailRequestTypeInfo:
            height = 400;
            break;
            
        case XYUserDetailRequestTypeAlbum:
            // 高度为collectionViewCell的行数 * cell的高度
            // 行数的计算：每行两个item，根据数据源计算 相片的个数 / 2 ,如果除2为计数，也算一行
            height = 10 * SIZE_ALBUM_ITEM_H;
            break;
            
        case XYUserDetailRequestTypeTopic:
            if (_dataList[@(self.requestType)].count) {
                
                NSArray *datas = _dataList[@(self.requestType)];
                if (indexPath.row < datas.count) {
                    
                    XYTopicViewModel *viewModel = datas[indexPath.row];
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
- (void)drawCell:(XYTopicViewCell *)cell withIndexPath:(NSIndexPath *)indexPath{
    
    // 防止数据错乱时，引发数组越界问题崩溃  , 数据重复请求并添加，导致数据越界问题已经解决，所以不需要在这判断了
    if (_dataList[@(self.requestType)].count == 0 || indexPath.row > _dataList[@(self.requestType)].count - 1) {
        return;
    }
    XYTopicViewModel *viewModel = (XYTopicViewModel *)[_dataList[@(self.requestType)] objectAtIndex:indexPath.row];
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
            XYTopicViewCell *cell = (XYTopicViewCell *)temp;
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
        }
    }
    
    _idStamp = 0;
    
    [self.mj_header beginRefreshing];
}


@end
