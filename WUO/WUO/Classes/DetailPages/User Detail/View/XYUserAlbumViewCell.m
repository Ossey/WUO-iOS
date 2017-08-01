//
//  XYUserAlbumViewCell.m
//  WUO
//
//  Created by mofeini on 17/1/12.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

#import "XYUserAlbumViewCell.h"
#import <UIImageView+WebCache.h>
#import "XYUserImgItem.h"
#import "XYImageViewer.h"

@interface XYUserAlbumViewCell () <UICollectionViewDelegate, UICollectionViewDataSource>

@end

@implementation XYUserAlbumViewCell {
    
    UICollectionView *_collectionView;
    /** 将数据源中的所有模型，转换为图片的URL字符串保存数组中 */
    NSMutableArray<NSString *> *_imageURLStrList;
}

static NSString * const cellIdentifier = @"XYUserAlbumViewCell";
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _imageURLStrList = [NSMutableArray arrayWithCapacity:0];
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(kSIZE_ALBUM_ITEM_W, kSIZE_ALBUM_ITEM_H);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [self.contentView addSubview:_collectionView];
        _collectionView.scrollEnabled = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        
        [_collectionView registerClass:[XYUserAlbumCollectionViewCell class] forCellWithReuseIdentifier:cellIdentifier];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return self;
}

- (void)setAlbumList:(NSArray *)albumList {
    _albumList = albumList;
    [_collectionView reloadData];
    
    [[[NSOperationQueue alloc] init] addOperationWithBlock:^{
        NSMutableArray *tempArrM = [NSMutableArray arrayWithCapacity:0];
        for (XYUserImgItem *imgItem in self.albumList) {
            [tempArrM addObject:imgItem.imgFullURL.absoluteString];
        }
        _imageURLStrList = [tempArrM mutableCopy];
        tempArrM = nil;
        NSLog(@"%@", [NSThread currentThread]);
    }];
}

#pragma mark - <UICollectionViewDelegate, UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _albumList.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    XYUserAlbumCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    cell.imgItem = _albumList[indexPath.row];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    XYUserAlbumCollectionViewCell *cell = (XYUserAlbumCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [[XYImageViewer prepareImageURLList:_imageURLStrList pageTextList:nil endView:^UIView *(NSIndexPath *indexPath) {
        return [collectionView cellForItemAtIndexPath:indexPath];
    }] show:cell currentIndex:indexPath.row];

}


@end

@implementation XYUserAlbumCollectionViewCell {
    UIImageView *_imageView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _imageView = [UIImageView new];
        _imageView.backgroundColor = kColorLightGray;
        [self.contentView addSubview:_imageView];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }
    
    return self;
}

- (void)setImgItem:(XYUserImgItem *)imgItem {
    _imgItem = imgItem;
    
    [_imageView sd_setImageWithURL:imgItem.imgFullURL];
}

@end
