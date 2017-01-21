//
//  XYUserDetailController.h
//  WUO
//
//  Created by mofeini on 17/1/11.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//  用户详情页控制器

#import "XYProfileBaseController.h"

@class XYTrendItem;

@interface XYUserDetailController : XYProfileBaseController

/** uid 当前用户的uid 请求数据的时候使用此参数*/
@property (nonatomic, assign) NSInteger uid;
@property (nonatomic, copy) NSString *username;
- (instancetype)initWithUid:(NSInteger)uid username:(NSString *)name;
@end
