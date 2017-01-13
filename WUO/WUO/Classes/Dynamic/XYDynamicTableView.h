//
//  XYDynamicTableView.h
//  WUO
//
//  Created by mofeini on 17/1/3.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XYDynamicTableView, XYTopicViewModel, XYTopicItem;
@protocol XYDynamicTableViewDelegate <UITableViewDelegate>

@optional

/**
 * @explain 点击cell上面头像时调用
 *
 * @param   item  头像对应用户当前的topic模型数据
 */
- (void)dynamicTableView:(XYDynamicTableView *)tableView didSelectAvatarViewAtIndexPath:(NSIndexPath *)indexPath item:(XYTopicItem *)item;
/**
 * @explain scrollView滚动的时候调用
 *
 */
- (void)dynamicTableViewDidScroll:(XYDynamicTableView *)scrollView;
/**
 * @explain 触摸scrollView并拖拽画面，再松开时，触发该函数
 *
 */
- (void)dynamicTableViewDidEndDragging:(XYDynamicTableView *)scrollView willDecelerate:(BOOL)decelerate;
/**
 * @explain scrollView停止减速的时候调用，再这里可以确定scrollView滚动完成后最终的偏移量
 * 当scrollView未产生减速效果时，不会调用此方法
 */
- (void)dynamicTableViewDidEndDecelerating:(UIScrollView *)scrollView;

- (CGFloat)dynamicTableView:(XYDynamicTableView *)dynamicTableView heightForHeaderInSection:(NSInteger)section;
- (UIView *)dynamicTableView:(XYDynamicTableView *)dynamicTableView viewForHeaderInSection:(NSInteger)section;

@end

@interface XYDynamicTableView : UITableView

@property (nonatomic, weak) id<XYDynamicTableViewDelegate> dynamicDelegate;

/**
 网络请求的数据类型，1 是动态界面 2 是发现界面
*/
@property (nonatomic, assign) NSInteger dataType;
@property (nonatomic, copy) NSString *serachLabel;
- (void)setDataType:(NSInteger)type serachLabel:(NSString *)serachLabel;
- (void)setSerachLabel:(NSString *)serachLabel;

@end
