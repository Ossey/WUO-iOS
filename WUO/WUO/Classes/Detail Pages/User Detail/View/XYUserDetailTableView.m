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
@end

@implementation XYUserDetailTableView {
    NSInteger _idStamp;
    XYUserDetailHeaderView *_headerView;
    XYUserDetailRequestType _requestType;
    NSMutableArray *_needLoadList;
    BOOL _scrollToToping;
    NSMutableDictionary<NSNumber *,NSMutableArray<XYTopicViewModel *> *> *_dataList;
    NSMutableArray *_photoList;
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
        _photoList = [NSMutableArray arrayWithCapacity:0];
        _page = 1;
        _requestType = XYUserDetailRequestTypeInfo;
        
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
            _idStamp = 0;
        }];
        
        self.mj_footer = [XYRefreshGifFooter footerWithRefreshingBlock:^{
            
        }];
        
    }
    return self;
}

- (void)setUserInfo:(XYUserInfo *)userInfo {
    _userInfo = userInfo;
    _headerView.userInfo = userInfo;
    
    
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
                self.userInfo = [XYUserInfo userInfoWithDict:responseObject[@"userInfo"] responseInfo:info];
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
            return;
        }

        if ([responseObject[@"code"] integerValue] == 0 && [responseObject isKindOfClass:[NSDictionary class]]) {
            XYHTTPResponseInfo *info = [XYHTTPResponseInfo responseInfoWithDict:responseObject];
            if (responseObject[@"datas"] && [responseObject[@"datas"] isKindOfClass:[NSArray class]]) {
                for (id obj in responseObject[@"datas"]) {
                    if ([obj isKindOfClass:[NSDictionary class]]) {
                        
                       [_photoList addObject:[XYUserImgItem userImgItemWithDict:obj responseInfo:info]];
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
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    switch (_requestType) {
        case XYUserDetailRequestTypeTopic:
            cell = [tableView dequeueReusableCellWithIdentifier:topicCellIdentifier forIndexPath:indexPath];
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
        default:
            break;
    }
    return height;
}

#pragma mark - XYCateTitleViewDelegate
- (void)cateTitleView:(XYCateTitleView *)view didSelectedItem:(NSInteger)index {
   
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

@end
