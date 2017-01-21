//
//  XYPictureCollectionView.m
//  WUO
//
//  Created by mofeini on 17/1/3.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

#import "XYPictureCollectionView.h"
#import "XYTrendItem.h"
#import <UIImageView+WebCache.h>
#import "XYImageViewer.h"

@interface XYPictureCollectionView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@end

@implementation XYPictureCollectionView

static NSString * const cellIdentifier = @"XYPictureCollectionViewCell";


- (instancetype)init {
    return [self initWithFrame:CGRectZero collectionViewLayout:[XYPictureCollectionViewLayout new]];
}

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        [self setup];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        
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

- (void)setImgList:(NSArray *)imgList {
    _imgList = imgList;

    [self reloadData];
}
- (NSArray<NSString *> *)imageUrls {
    
    NSMutableArray<NSString *> *tempArrM = [NSMutableArray arrayWithCapacity:1];
    for (XYTrendImgItem *imgItem in self.imgList) {
        [tempArrM addObject:imgItem.imgFullURL.absoluteString];
    }
    return [tempArrM mutableCopy];
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.imgList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    XYPictureCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];

    cell.imgItem = self.imgList[indexPath.row];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize size = CGSizeZero;
    
    if (self.picDataSource && [self.picDataSource respondsToSelector:@selector(pictureCollectionView:layout:sizeForItemAtIndexPath:)]) {
        size = [self.picDataSource pictureCollectionView:collectionView layout:collectionViewLayout sizeForItemAtIndexPath:indexPath];
    }
    
    if (self.sizeForItemAtIndexPath) {
        size = self.sizeForItemAtIndexPath(indexPath, (XYPictureCollectionViewLayout *)collectionViewLayout, collectionView);
    }
    
    return size;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    XYPictureCollectionViewCell *cell = (XYPictureCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    [[XYImageViewer shareInstance] prepareImageURLStrList:self.imageUrls endView:^UIView *(NSIndexPath *indexPath) {
        return [collectionView cellForItemAtIndexPath:indexPath];
    }];
    
    [[XYImageViewer shareInstance] show:cell currentImgIndex:indexPath.row];
    
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
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        self.backgroundColor = kColorLightGray;
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.contentView);
        }];
    }
    return self;
}

- (void)setImgItem:(XYTrendImgItem *)imgItem {
    
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
