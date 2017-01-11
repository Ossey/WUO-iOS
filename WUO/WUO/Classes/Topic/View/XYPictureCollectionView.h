//
//  XYPictureCollectionView.h
//  WUO
//
//  Created by mofeini on 17/1/3.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XYTopicItem, XYDynamicImgItem;
@interface XYPictureCollectionView : UICollectionView

@property (nonatomic, strong) XYTopicItem *dynamicItem;

@end


@interface XYPictureCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) XYDynamicImgItem *imgItem;


@end

@interface XYPictureCollectionViewLayout : UICollectionViewFlowLayout

@end