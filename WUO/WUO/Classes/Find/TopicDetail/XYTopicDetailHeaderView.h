//
//  XYTopicDetailHeaderView.h
//  WUO
//
//  Created by mofeini on 17/1/9.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//  话题详情页的头部视图

#import <UIKit/UIKit.h>

@class XYActivityTopicItem;

@interface XYTopicDetailHeaderView : UIView

@property (nonatomic, strong) XYActivityTopicItem *item;

- (void)clear;
- (void)releaseMemory;
- (void)draw;

@end
