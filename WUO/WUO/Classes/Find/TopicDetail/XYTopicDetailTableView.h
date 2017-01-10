//
//  XYTopicDetailTableView.h
//  WUO
//
//  Created by mofeini on 17/1/10.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XYActivityTopicItem;
@interface XYTopicDetailTableView : UITableView

/** 主要用于展示头部信息的模型 */
@property (nonatomic, strong) XYActivityTopicItem *activityTopicItem;

@end
