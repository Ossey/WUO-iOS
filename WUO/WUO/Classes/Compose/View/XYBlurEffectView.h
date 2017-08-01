//
//  XYBlurEffectView.h
//  WUO
//
//  Created by mofeini on 17/2/8.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, XYBlurEffectItemType) {
    /// 发布图文
    XYBlurEffectItemTypeComposeImageOrText = 0,
    /// 发布视频
    XYBlurEffectItemTypeComposeVideo,
    /// 关闭
    XYBlurEffectItemTypeClose
};

@class XYBlurItem, XYBlurEffectView;

@protocol XYBlurEffectViewDelegate <NSObject>

@optional

- (void)blurEffectView:(XYBlurEffectView *)view didSelectItemWithType:(XYBlurEffectItemType)type;
@end

@interface XYBlurEffectView : UIView

@property (nonatomic, strong) NSArray<XYBlurItem *> *menuItemList;
@property (nonatomic, assign) CGFloat itemScale;

@property (nonatomic, weak) id<XYBlurEffectViewDelegate> delegate;

+ (instancetype)showWithMenuItemList:(NSArray *)list;
- (void)showToView:(UIView *)view menuItemList:(NSArray<XYBlurItem *> *)list;
+ (void)dismiss;
+ (void)dismissWithAnimated:(BOOL)flag completion:(void (^)(BOOL finished))completion;
@end

@interface XYBlurItem : NSObject

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) NSString *title;

+ (instancetype)blurItemWithImageNamed:(NSString *)imageNamed title:(NSString *)title;

@end

@interface XYBlurButton : UIButton

@end
