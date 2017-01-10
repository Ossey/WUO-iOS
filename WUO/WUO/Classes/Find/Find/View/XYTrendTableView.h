//
//  XYTrendTableView.h
//  WUO
//
//  Created by mofeini on 17/1/6.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//



#import <UIKit/UIKit.h>

@class XYTrendTableView;
@protocol XYTrendTableViewDelegate <UITableViewDelegate>

@optional
/**
 * @explain scrollView滚动的时候调用
 *
 */
- (void)dynamicTableViewDidScroll:(XYTrendTableView *)scrollView;
/**
 * @explain 触摸scrollView并拖拽画面，再松开时，触发该函数
 *
 */
- (void)dynamicTableViewDidEndDragging:(XYTrendTableView *)scrollView willDecelerate:(BOOL)decelerate;
/**
 * @explain scrollView停止减速的时候调用，再这里可以确定scrollView滚动完成后最终的偏移量
 * 当scrollView未产生减速效果时，不会调用此方法
 */
- (void)dynamicTableViewDidEndDecelerating:(UIScrollView *)scrollView;

- (CGFloat)dynamicTableView:(XYTrendTableView *)dynamicTableView heightForHeaderInSection:(NSInteger)section;
- (UIView *)dynamicTableView:(XYTrendTableView *)dynamicTableView viewForHeaderInSection:(NSInteger)section;
@end

@interface XYTrendTableView : UITableView

@property (nonatomic, weak) id<XYTrendTableViewDelegate> dynamicDelegate;

/**
 网络请求的数据类型，1 是动态界面 2 是发现界面
 */
@property (nonatomic, assign) NSInteger dataType;
@property (nonatomic, copy) NSString *serachLabel;
@property (nonatomic, copy) void (^cnameBlock)(NSString *serachLabel);
- (instancetype)initWithFrame:(CGRect)frame dataType:(NSInteger)type;
- (void)setSerachLabel:(NSString *)serachLabel;

@end
