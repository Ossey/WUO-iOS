//
//  XYDynamicTableView.h
//  WUO
//
//  Created by mofeini on 17/1/3.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XYDynamicTableView;
@protocol XYDynamicTableViewDelegate <UITableViewDelegate>

@optional
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

- (NSInteger)getNetworkType;
- (NSString *)getSerachLabel;
@end
