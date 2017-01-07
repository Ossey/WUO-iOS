//
//  XYHomeContainerView.m
//  PandaTVHomeDemo
//
//  Created by mofeini on 16/12/8.
//  Copyright © 2016年 com.test.demo. All rights reserved.
//  主页子控制器view容器视图

#import "XYHomeContainerView.h"
#import "XYTrendTableView.h"

@interface XYHomeContainerView () <UICollectionViewDataSource, XYHomeContainerViewDelegate>

@property (nonatomic, strong) XYHomeContainerViewLayout *layout;

@end

@implementation XYHomeContainerView
@synthesize channelCates = _channelCates;

- (void)setChannelCates:(NSMutableArray *)channelCates {
    _channelCates = channelCates;
    
    [self reloadData];
}

- (NSMutableArray *)channelCates {
    if (_channelCates == nil) {
        _channelCates = [NSMutableArray arrayWithCapacity:0];
    }
    return _channelCates;
}

- (XYHomeContainerViewLayout *)layout {
    if (_layout == nil) {
        _layout = [[XYHomeContainerViewLayout alloc] init];
    }
    return _layout;
}

static NSString *const cellIdentifier = @"XYHomeContainerViewCell";

- (instancetype)initWithFrame:(CGRect)frame channelCates:(NSArray *)channelCates {
    
    if (self = [super initWithFrame:frame collectionViewLayout:self.layout]) {
        [self.channelCates addObjectsFromArray:channelCates];;
        self.bounces = NO;  // 弹簧
        self.pagingEnabled = YES; // 分页
        self.showsVerticalScrollIndicator = NO; // 指示器
        self.scrollsToTop = YES;
        self.delegate = self;
        self.dataSource = self;
        self.showsHorizontalScrollIndicator = NO;
        self.backgroundColor = [UIColor whiteColor];
        self.contentSize = CGSizeMake(channelCates.count * CGRectGetWidth(self.frame), 0);
        [self registerClass:[XYHomeContainerViewCell class] forCellWithReuseIdentifier:cellIdentifier];
    }
    
    return self;
}


#pragma mark - UICollectionView代理和数据源方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.channelCates.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    XYHomeContainerViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor clearColor];
    /// 取出当前点击的频道信息
//    cell.channelView.currentChannel = self.channelCates[indexPath.row];
    
    return cell;
}

#pragma mark - UIScrollView代理方法
/// scrollView减速完成的时候调用
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    // 计算索引
    NSInteger i = scrollView.contentOffset.x / CGRectGetWidth(self.frame);
    
    if (self.containerViewDelegate && [self.delegate respondsToSelector:@selector(containerView:indexAtContainerView:)]) {
        
        [self.containerViewDelegate containerView:self indexAtContainerView:i];
    }
    
    /// 发布scrollView减速完成的通知
    if (self.containerViewDelegate && [self.containerViewDelegate respondsToSelector:@selector(containerViewDidScrollDidEndDecelerating:)]) {
        [self.containerViewDelegate containerViewDidScrollDidEndDecelerating:self];
    }
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    /// 发布scrollView滚动的通知
    if (self.containerViewDelegate && [self.containerViewDelegate respondsToSelector:@selector(containerViewDidScroll:)]) {
        [self.containerViewDelegate containerViewDidScroll:self];
    }
    
}

/// 滚动完scrollView，手指离开屏幕的时候调用
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (self.containerViewDelegate && [self.containerViewDelegate respondsToSelector:@selector(containerViewDidEndDragging:willDecelerate:)]) {
        [self.containerViewDelegate containerViewDidEndDragging:self willDecelerate:decelerate];
    }
}


- (void)selectIndex:(NSInteger)index {
    [UIView animateWithDuration:0.2 animations:^{
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [self scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }];
}

@end

@implementation XYHomeContainerViewLayout

- (void)prepareLayout {
    
    [super prepareLayout];
    
    self.itemSize = CGSizeMake(CGRectGetWidth(self.collectionView.frame), CGRectGetHeight(self.collectionView.frame) + 1);
    self.minimumLineSpacing = 0;
    self.minimumInteritemSpacing = 0;
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
}

@end

@interface XYHomeContainerViewCell ()

@property (nonatomic, weak) XYTrendTableView *tableView;

@end

@implementation XYHomeContainerViewCell



- (XYTrendTableView *)tableView {
    
    if (_tableView == nil) {
        XYTrendTableView *tableView = [[XYTrendTableView alloc] init];
        [self.contentView addSubview:tableView];
        _tableView = tableView;
        
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }
    return _tableView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.tableView.hidden = NO;
    }
    
    return self;
}


- (void)dealloc {
    
    NSLog(@"%s", __func__);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
