//
//  XYUserAlbumViewCell.h
//  WUO
//
//  Created by mofeini on 17/1/12.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XYUserAlbumCollectionView, XYUserImgItem;

@interface XYUserAlbumViewCell : UITableViewCell 

@property (nonatomic, strong) NSArray<XYUserImgItem *> *albumList;

@end



@interface XYUserAlbumCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) XYUserImgItem *imgItem;

@end
