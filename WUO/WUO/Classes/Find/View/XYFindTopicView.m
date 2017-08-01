//
//  XYFindTopicView.m
//  WUO
//
//  Created by mofeini on 17/1/5.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

#import "XYFindTopicView.h"
#import "XYActivityTopicItem.h"
#import <UIImageView+WebCache.h>
#import "XYActiveTopicDetailController.h"

#define titleBtnHeight 30
#define leftMargin  8
#define topMargin 10

@interface XYFindTopicView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UIButton *titleBtn;
@property (nonatomic, strong) UIImageView *indicatorView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;

@end

@implementation XYFindTopicView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupUI];
    }
    return self;
}

static NSString * const cellIdentifier = @"XYFindTopicViewCell";

- (void)setupUI {
    self.backgroundColor = [UIColor whiteColor];
    _titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_titleBtn setImage:[UIImage imageNamed:@"Find_topicIcon"] forState:UIControlStateNormal];
    [_titleBtn setTitle:@"活动专题" forState:UIControlStateNormal];
    [_titleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_titleBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    
    [self addSubview:_titleBtn];
    
    _indicatorView = [[UIImageView alloc] init];
    _indicatorView.image = [UIImage imageNamed:@"accessry"];
    [self addSubview:_indicatorView];
    
    _layout = [[UICollectionViewFlowLayout alloc] init];
    _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_layout];
    [self addSubview:_collectionView];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    [_collectionView registerClass:[XYFindTopicViewCell class] forCellWithReuseIdentifier:cellIdentifier];
    _collectionView.contentInset = UIEdgeInsetsMake(0, leftMargin, 0, 0);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_titleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).mas_offset(leftMargin);
        make.top.equalTo(self).mas_offset(topMargin);
        make.height.equalTo(@titleBtnHeight);
    }];
    
    [_indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(_titleBtn);
        make.width.equalTo(_indicatorView.mas_height);
        make.right.equalTo(self).mas_offset(-leftMargin);
        make.left.equalTo(_titleBtn.mas_right);
    }];
    
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(_titleBtn.mas_bottom).mas_offset(topMargin);
        make.right.equalTo(self);
        make.bottom.equalTo(self).mas_offset(-topMargin);
    }];
    
    [_titleBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -(CGRectGetWidth(_titleBtn.frame) * 0.78), 0, 0)];
    [_titleBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -(CGRectGetWidth(_titleBtn.frame) * 0.78) + titleBtnHeight, 0, 0)];
    
    CGFloat w = kScreenW * 0.5 - 50;
    CGFloat h = CGRectGetHeight(_collectionView.frame);
    _layout.itemSize = CGSizeMake(w, h);
}

- (void)setTopicItemList:(NSArray<XYActivityTopicItem *> *)topicItemList {
    _topicItemList = topicItemList;
    
    [self.collectionView reloadData];
}


#pragma mark - <UICollectionViewDelegate, UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.topicItemList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    XYFindTopicViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    cell.topicItem = self.topicItemList[indexPath.row];
    
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    [XYActiveTopicDetailController pushWithItem:self.topicItemList[indexPath.row]];
}

@end

#define topicLabelHeight 30
@implementation XYFindTopicViewCell {
    UIImageView *_imageView;
    UILabel *_topicNameLabel;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_imageView];
        
        _topicNameLabel = [[UILabel alloc] init];
        _topicNameLabel.textColor = kColorTitleText;
        _topicNameLabel.textAlignment = NSTextAlignmentCenter;
        _topicNameLabel.font = kFontWithSize(13);
        [self.contentView addSubview:_topicNameLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_topicNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.height.equalTo(@topicLabelHeight);
    }];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.contentView);
        make.bottom.equalTo(_topicNameLabel.mas_top).mas_offset(5);
    }];
}


- (void)setTopicItem:(XYActivityTopicItem *)topicItem {
    _topicItem = topicItem;
    
    [_imageView sd_setImageWithURL:topicItem.logoFullURL];
    
    _topicNameLabel.text = topicItem.Title;
}

@end
