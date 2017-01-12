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

@interface XYUserAlbumViewCell () <UICollectionViewDelegate, UICollectionViewDataSource>

@end

@implementation XYUserAlbumViewCell {
    
    UICollectionView *_collectionView;
}

static NSString * const cellIdentifier = @"XYUserAlbumViewCell";
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(SIZE_ALBUM_ITEM_W, SIZE_ALBUM_ITEM_H);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [self.contentView addSubview:_collectionView];
        _collectionView.scrollEnabled = NO;
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
    NSLog(@"%@", albumList);
    [_collectionView reloadData];
}

#pragma mark - <UICollectionViewDelegate, UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _albumList.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    XYUserAlbumCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
//    cell.backgroundColor = kRandomColor;
    
    cell.imgItem = _albumList[indexPath.row];
    
    return cell;
}


@end

@implementation XYUserAlbumCollectionViewCell {
    UIImageView *_imageView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _imageView = [UIImageView new];
        [self.contentView addSubview:_imageView];
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
