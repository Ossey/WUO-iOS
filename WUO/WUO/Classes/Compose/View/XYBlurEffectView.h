//
//  XYBlurEffectView.h
//  WUO
//
//  Created by mofeini on 17/2/8.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XYBlurItem;
@interface XYBlurEffectView : UIView

@property (nonatomic, strong) NSArray<XYBlurItem *> *menuItemList;
@property (nonatomic, assign) CGFloat itemScale;

+ (void)showWithMenuItemList:(NSArray *)list;
- (void)showToView:(UIView *)view menuItemList:(NSArray<XYBlurItem *> *)list;
+ (void)dismiss;
+ (void)dismiss:(void (^)(BOOL finished))completion;
@end

@interface XYBlurItem : NSObject

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) NSString *title;

+ (instancetype)blurItemWithImageNamed:(NSString *)imageNamed title:(NSString *)title;

@end

@interface XYBlurButton : UIButton

@end
