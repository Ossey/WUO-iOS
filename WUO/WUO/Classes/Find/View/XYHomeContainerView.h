//
//  XYHomeContainerView.h
//  PandaTVHomeDemo
//
//  Created by mofeini on 16/12/8.
//  Copyright © 2016年 com.test.demo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XYHomeContainerView;
@protocol XYHomeContainerViewDelegate <UICollectionViewDelegate>

@optional
/**
 * @explain 滚动containerView减速完成时调用，对应的索引, 从0开始
 */
- (void)containerView:(XYHomeContainerView *)containerView indexAtContainerView:(NSInteger)index;

/**
 * containerView滚动的时候调用
 */
- (void)containerViewDidScroll:(XYHomeContainerView *)containerView;
/**
 * containerView滚动完成的时候调用
 */
- (void)containerViewDidScrollDidEndDecelerating:(XYHomeContainerView *)containerView;

/**
 * @explain 滚动containerView 手指离开屏幕的时候调用
 */
- (void)containerViewDidEndDragging:(XYHomeContainerView *)containerView willDecelerate:(BOOL)decelerate;

@end

@interface XYHomeContainerView : UICollectionView

/** 分类标题数组, 当外界的分类标题数组发生改变时，要把数组重新赋值以下即可，当有新值时，内部会自动刷新 */
@property (nonatomic, strong) NSMutableArray<NSDictionary *> *channelCates;

/** 代理 */
@property (nonatomic, weak) id<XYHomeContainerViewDelegate> containerViewDelegate;

/**
 * @explain 手动选择某个页面, 从0开始
 *
 */
- (void)selectIndex:(NSInteger)index;
/**
 * @explain 创建并初始化当前类对象
 *
 * @param   frame  frame
 * @param   channelCates  频道分类数组
 * @return  实例化的对象
 */
- (instancetype)initWithFrame:(CGRect)frame channelCates:(NSArray *)channelCates;
@end

@interface XYHomeContainerViewLayout : UICollectionViewFlowLayout

@end


@interface XYHomeContainerViewCell : UICollectionViewCell

@end
