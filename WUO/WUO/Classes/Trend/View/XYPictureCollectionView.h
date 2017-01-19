//
//  XYPictureCollectionView.h
//  WUO
//
//  Created by mofeini on 17/1/3.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef CGSize(^SizeForItemAtIndexPath)(NSIndexPath *indexPath, UICollectionViewFlowLayout *layout, UICollectionView *collectionView);

@class XYTrendItem, XYTrendImgItem;

@protocol XYPictureCollectionViewDataSource <UICollectionViewDataSource>

- (CGSize)pictureCollectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;

@end


@interface XYPictureCollectionView : UICollectionView

@property (nonatomic, strong) XYTrendItem *item;
@property (nonatomic, weak) id<XYPictureCollectionViewDataSource> picDataSource;

@property (nonatomic, copy) SizeForItemAtIndexPath sizeForItemAtIndexPath;

@end


@interface XYPictureCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) XYTrendImgItem *imgItem;


@end

@interface XYPictureCollectionViewLayout : UICollectionViewFlowLayout

@end
