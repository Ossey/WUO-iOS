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
#import "ESPictureBrowser.h"

@interface XYPictureCollectionView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, ESPictureBrowserDelegate>

@property (nonatomic, strong, nullable)UIView *currentView;
@property (nonatomic, strong, nullable)NSArray *currentArray;
/** 此数组中缓存的imageView是为了传给ESPictureBrowser 用来展示图片的 */
@property (nonatomic, strong) NSMutableArray<UIImageView *> *imageViews;
@end

@implementation XYPictureCollectionView

static NSString * const cellIdentifier = @"XYPictureCollectionViewCell";

- (NSMutableArray<UIImageView *> *)imageViews {
    
    if (_imageViews == nil) {
        _imageViews = [NSMutableArray arrayWithCapacity:1];
    }
    return _imageViews;
}

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
    
    for (NSInteger i = 0; i < dynamicItem.imgList.count; ++i) {
        UIImageView *imageView = [[UIImageView alloc] init];
        [self.imageViews addObject:imageView];
    }
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

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    ESPictureBrowser *browser = [[ESPictureBrowser alloc] init];
    [browser setDelegate:self];
    [browser setLongPressBlock:^(NSInteger index) {
        NSLog(@"%zd", index);
    }];
    [browser showFromView:cell picturesCount:self.dynamicItem.imgList.count currentPictureIndex:indexPath.row];
    
}


#pragma mark - ESPictureBrowserDelegate


/**
 获取对应索引的视图
 
 @param pictureBrowser 图片浏览器
 @param index          索引
 
 @return 视图
 */
- (UIView *)pictureView:(ESPictureBrowser *)pictureBrowser viewForIndex:(NSInteger)index {
    return [self.imageViews objectAtIndex:index];
}

/**
 获取对应索引的图片大小
 
 @param pictureBrowser 图片浏览器
 @param index          索引
 
 @return 图片大小
 */
- (CGSize)pictureView:(ESPictureBrowser *)pictureBrowser imageSizeForIndex:(NSInteger)index {
    
    XYDynamicImgItem *model = self.dynamicItem.imgList[index];

    return model.imgSize;
}

/**
 获取对应索引默认图片，可以是占位图片，可以是缩略图
 
 @param pictureBrowser 图片浏览器
 @param index          索引
 
 @return 图片
 */
- (UIImage *)pictureView:(ESPictureBrowser *)pictureBrowser defaultImageForIndex:(NSInteger)index {
    UIImage *image;
    UIImageView *imageView =  [self.imageViews objectAtIndex:index];
    if (imageView.subviews.count == 1) {
        image = imageView.image;
    }else {
        image = imageView.image;
    }
    return image;
}

/**
 获取对应索引的高质量图片地址字符串
 
 @param pictureBrowser 图片浏览器
 @param index          索引
 
 @return 图片的 url 字符串
 */
- (NSString *)pictureView:(ESPictureBrowser *)pictureBrowser highQualityUrlStringForIndex:(NSInteger)index {
    
    XYDynamicImgItem *model = self.dynamicItem.imgList[index];
    return model.imgFullURL.absoluteString;
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
