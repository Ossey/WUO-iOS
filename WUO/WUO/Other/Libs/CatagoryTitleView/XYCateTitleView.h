//
//  XYCateTitleView.h
//  PandaTVHomeDemo
//
//  Created by mofeini on 16/12/8.
//  Copyright © 2016年 com.test.demo. All rights reserved.
//  分类标题内容视图

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN
//extern NSString *const cname; // 文字名称
//extern NSString *const ename; // 图片名称


@class XYCateTitleView;
@protocol XYCateTitleViewDelegate <NSObject>

@optional
/**
 * @explain 分类子标题按钮已全部创建完毕的通知
 
 * @param   view  XYCateTitleView实例对象
 * @param   itemCount  子标题按钮的个数
 */
- (void)cateTitleView:(XYCateTitleView *)view cateTitleItemDidCreated:(NSInteger)itemCount;
/**
 * @explain 点击`添加频道分类`按钮时调用
 *
 */
- (void)cateTitleView:(XYCateTitleView *)view didSelectedAddSubTitle:(UIButton *)addBtn;

/**
 * @explain 点击cateTitleView上每一个item时调用
 *
 * @param   view  XYCateTitleView实例对象
 * @param   btn  点击cateTitleView上的item
 * @param   ename 点击cateTitleView上的item对应的ename，用于判断点击的是哪个界面
 */
- (void)cateTitleView:(XYCateTitleView *)view didSelectedItem:(UIButton *)btn ename:(NSString *)ename;
- (void)cateTitleView:(XYCateTitleView *)view didSelectedItem:(UIButton *)btn cname:(NSString *)cname;
/**
 * @explain 滚动时调用
 *
 * @param   scrollView  滚动条
 */
- (void)cateTitleViewDidScroll:(UIScrollView *)scrollView;

@required
/**
 * @explain 点击标题按钮时调用，并把点击标题按钮的索引传递出去
 *
 * @param   view  XYCateTitleView的实例对象
 * @param   index  选中标题按钮的索引
 */
- (void)cateTitleView:(XYCateTitleView *)view didSelectedItem:(NSInteger)index;
@end

@interface XYCateTitleView : UIView <NSCopying>

/** 分类标题数组, 当外界的分类标题数组发生改变时，要把数组重新赋值以下即可，当有新值时，内部会自动刷新 */
@property (nonatomic, strong) NSMutableArray<NSDictionary *> *channelCates;
/** 分类标题内容视图 */
@property (nonatomic, weak, readonly) UIScrollView *cateTitleView;
/** 选中标题按钮的索引, 默认为0, 当外界设置的索引大于子控制器的总数时，设置的索引无效会重置为0 */
@property (nonatomic, assign) NSInteger selectedIndex;
/** 标题按钮缩放比例, 默认为0, 有效范围0.0~1.0 */
@property (nonatomic, assign) CGFloat itemScale;
/** 存放标题按钮的数组 */
@property (nonatomic, strong, readonly) NSMutableArray<UIButton *> *items;
/** 标题按钮的字体 */
@property (nonatomic, strong) UIFont *titleItemFont;
/** 按钮的名称应该按照什么key去字典中取名称 */
@property (nonatomic, copy) NSString *itemNameKey;
/** 按钮的图片应该按照什么key去字典中取图片的名称 */
@property (nonatomic, copy) NSString *itemImageNameKey;
@property (nonatomic, strong) UIColor *currentItemBackgroundColor;
@property (nonatomic, strong) UIColor *otherItemBackgroundColor;
@property (nonatomic, strong) UIColor *underLineBackgroundColor;
@property (nonatomic, strong) UIImage *underLineImage;
@property (nonatomic, strong) UIImage *separatorImage;
@property (nonatomic, strong) UIColor *separatorBackgroundColor;
@property (nonatomic, strong) UIColor *globalBackgroundColor;
@property (nonatomic, assign) CGFloat itemWidth;
@property (nonatomic, weak, readonly) UIButton *rightButton;
@property (nonatomic, weak) id<XYCateTitleViewDelegate> delegate;
@property (nonatomic, copy) void (^selectedItemCallBack)(NSString *ename, NSInteger index);
@property (nonatomic, copy) void (^selectedRightBtnCallBack)(UIButton *btn);
/**
 * @explain 创建标题滑动栏
 *
 * @param   channelCates  根据channelCates创建对应的标题按钮，channelCates数组中的字典应根据cname和ename传入对应的标题文字和图片名称
 * @param   rightBtnWidth  右侧按钮的宽度
 * @return  初始化对象
 */
- (instancetype)initWithFrame:(CGRect)frame
                     delegate:(id)delegate
                 channelCates:(NSArray<NSDictionary *> * _Nullable )channelCates
                rightBtnWidth:(CGFloat)rightBtnWidth NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;
- (void)setRightItemTitle:(NSString *)title image:(UIImage *)image forState:(UIControlState)state;
/**
 * containerView滚动的时候调用,子类如果需求在此时做事情，重写此方法即可
 */
- (void)contentViewDidScroll:(UIScrollView *)scrollView;
/**
 * containerView滚动完成的时候调用
 */
- (void)contentViewDidScrollDidEndDecelerating:(UIScrollView *)scrollView;
@end


@interface UIButton (XYCateTitle)

/**
 * 增加ename属性是为了保存每个Button对应的ename字段的内容，最终结果是点击标题栏按钮时请求对应的ename字段的内容
 */
@property (nonatomic, copy) NSString *ename;
/**
 * 增加ename属性是为了保存每个Button的title，最终结果是点击标题栏按钮时请求对应的cname字段的内容
 */
@property (nonatomic, copy) NSString *cname;

@end
NS_ASSUME_NONNULL_END

