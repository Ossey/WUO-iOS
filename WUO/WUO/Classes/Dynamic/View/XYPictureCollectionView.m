//
//  XYPictureCollectionView.m
//  WUO
//
//  Created by mofeini on 17/1/3.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

#import "XYPictureCollectionView.h"
#import "XYDynamicItem.h"
#import <UIImageView+WebCache.h>

@interface XYPictureCollectionView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@end

@implementation XYPictureCollectionView

static NSString * const cellIdentifier = @"XYPictureCollectionViewCell";

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.dataSource = self;
    self.delegate = self;
    self.scrollsToTop = NO;
    [self registerClass:[XYPictureCollectionViewCell class] forCellWithReuseIdentifier:cellIdentifier];
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.scrollEnabled = NO;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self setup];
        
    }
    return self;
}

- (void)setDynamicItem:(XYDynamicItem *)dynamicItem {
    
    _dynamicItem = dynamicItem;
    
    [self reloadData];
}


#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.dynamicItem.imgList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    XYPictureCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    cell.imgItem = self.dynamicItem.imgList[indexPath.row];
    
    return cell;
}


@end

@interface XYPictureCollectionViewCell () {
    
    UIImageView *_imageView;
}

@end

@implementation XYPictureCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        _imageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_imageView];
        _imageView.contentMode = UIViewContentModeScaleToFill;
        _imageView.clipsToBounds = YES;
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.contentView);
        }];
    }
    
    return self;
}

- (void)setImgItem:(XYDynamicImgItem *)imgItem {
    
    _imgItem = imgItem;
    
    [_imageView sd_setImageWithURL:self.imgItem.imgFullURL];
}

@end

@implementation XYPictureCollectionViewLayout

- (void)prepareLayout {
    
    [super prepareLayout];

    self.minimumInteritemSpacing = 0;
    self.minimumLineSpacing = 5;
}

@end
