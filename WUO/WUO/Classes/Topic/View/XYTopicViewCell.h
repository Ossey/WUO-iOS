//
//  XYTopicViewCell.h
//  WUO
//
//  Created by mofeini on 17/1/2.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XYTopicViewModel, XYTopicViewCell;

@protocol XYTopicViewCellDelegate <NSObject>

@optional
/**
 * @explain 点击cell上面头像时调用
 */
- (void)topicViewCellDidSelectAvatarView:(XYTopicViewCell *)cell;

@end

@interface XYTopicViewCell : UITableViewCell

@property (nonatomic, strong) XYTopicViewModel *viewModel;

@property (nonatomic, weak) id<XYTopicViewCellDelegate> delegate;

- (void)clear;
- (void)releaseMemory;
- (void)draw;


@end
