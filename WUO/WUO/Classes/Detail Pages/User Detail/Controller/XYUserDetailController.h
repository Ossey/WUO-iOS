//
//  XYUserDetailController.h
//  WUO
//
//  Created by mofeini on 17/1/11.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//  用户详情页控制器

#import "XYProfileBaseController.h"

@class XYTopicItem;

@interface XYUserDetailController : XYProfileBaseController

/** item中的 uid 当前用户的uid 请求数据的时候使用此参数*/
@property (nonatomic, strong) XYTopicItem *item;
- (instancetype)initWithItem:(XYTopicItem *)item;
@end
