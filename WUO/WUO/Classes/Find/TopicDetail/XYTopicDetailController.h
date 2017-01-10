//
//  XYTopicDetailController.h
//  WUO
//
//  Created by mofeini on 17/1/9.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//  话题详情页

#import "XYProfileBaseController.h"

@class XYActivityTopicItem;
@interface XYTopicDetailController : XYProfileBaseController

/** 活动话题模型，用于进入此界面时，请求对应的话题数据的 */
@property (nonatomic, strong) XYActivityTopicItem *item;

+ (void)pushWithItem:(XYActivityTopicItem *)item;

@end
