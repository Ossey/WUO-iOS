//
//  XYActiveTopicDetailTableView.h
//  WUO
//
//  Created by mofeini on 17/1/10.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XYActivityTopicItem, XYTrendItem, XYActiveTopicDetailTableView;

@protocol XYActiveTopicTableViewDelegate <UITableViewDelegate>

@optional
/**
 * @explain 点击cell上面头像时调用
 *
 * @param   item  头像对应用户当前的topic模型数据
 */
- (void)activeTopicDetailTableView:(XYActiveTopicDetailTableView *)tableView didSelectAvatarViewAtIndexPath:(NSIndexPath *)indexPath item:(XYTrendItem *)item;

- (void)activeTopicDetailTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath item:(XYTrendItem *)item;

@end

@interface XYActiveTopicDetailTableView : UITableView

/** 主要用于展示头部信息的模型 */
@property (nonatomic, strong) XYActivityTopicItem *activityTopicItem;

@property (nonatomic, weak) id<XYActiveTopicTableViewDelegate> activeTopicTableViewdelegate;

@end
