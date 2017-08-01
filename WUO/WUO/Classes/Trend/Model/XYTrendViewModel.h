//
//  XYTrendViewModel.h
//  WUO
//
//  Created by mofeini on 17/1/3.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYHTTPResponseInfo.h"
#import "XYTrendItem.h"


@interface XYTrendViewModel : NSObject

@property (nonatomic, strong) XYHTTPResponseInfo *info;
@property (nonatomic, strong) XYTrendItem *item;

@property (nonatomic, assign) CGRect cellBounds;
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) CGRect title_labelFrame;
@property (nonatomic, assign) CGRect contentLableFrame;
@property (nonatomic, assign) CGRect picCollectionViewFrame;
@property (nonatomic, assign) CGRect readCountBtnFrame;
@property (nonatomic, assign) CGRect toolViewFrame;
@property (nonatomic, assign) CGRect nameLabelFrame;
@property (nonatomic, assign) CGRect jobLabelFrame;
@property (nonatomic, assign) CGRect videoImgViewFrame;
@property (nonatomic, assign) CGRect rankingFrame;
@property (nonatomic, assign) CGRect headerFrame;
@property (nonatomic, assign) CGRect investBtnFrame;

@property (nonatomic, assign) CGFloat contentWidth;
@property (nonatomic, assign) CGFloat picItemWH;

/** 记录模型所在的tableViewview上次滚动的偏移量 */
@property (nonatomic, assign) CGPoint previousContentOffset;
+ (instancetype)trendViewModelWithTrend:(XYTrendItem *)item info:(XYHTTPResponseInfo *)info;
@end
