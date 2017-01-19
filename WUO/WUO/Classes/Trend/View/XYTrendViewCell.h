//
//  XYTrendViewCell.h
//  WUO
//
//  Created by mofeini on 17/1/2.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XYTrendViewModel, XYTrendViewCell, XYTrendItem;

@protocol XYTrendViewCellDelegate <NSObject>

@optional
/**
 * @explain 点击cell上面头像时调用
 * uid      当前点击用户的uid，用于请求用户数据的参数
 */
- (void)topicViewCellDidSelectAvatarView:(XYTrendViewCell *)cell item:(XYTrendItem *)item;
/**
 * @explain 点赞时调用
 *
 * @param   btn  点赞所在的按钮，当点赞后应该修改对应的模型数据 数据修改后刷新表格，就会让按钮应该变为选中状态，且更新点赞数，按钮不可以相应事件
 */
- (void)topicViewCell:(XYTrendViewCell *)celll didSelectPraiseBtn:(UIButton *)btn item:(XYTrendItem *)item;
@end

@interface XYTrendViewCell : UITableViewCell

@property (nonatomic, strong) XYTrendViewModel *viewModel;

@property (nonatomic, weak) id<XYTrendViewCellDelegate> delegate;

- (void)clear;
- (void)releaseMemory;
- (void)draw;


@end
