//
//  XYUserDetailController.h
//  WUO
//
//  Created by mofeini on 17/1/11.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//  用户详情页控制器

#import <UIKit/UIKit.h>

@class XYTopicViewModel;

@interface XYUserDetailController : UIViewController

/** uid 当前用户的uid 请求数据的时候使用此参数*/
@property (nonatomic, assign) NSInteger uid;

- (instancetype)initWithTargetUid:(NSInteger)uid;
@end
