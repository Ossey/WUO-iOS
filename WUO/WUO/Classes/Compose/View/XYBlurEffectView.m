//
//  XYBlurEffectView.m
//  WUO
//
//  Created by mofeini on 17/2/8.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

#import "XYBlurEffectView.h"

CGFloat const itemWH = 80;

@interface XYBlurEffectView () {
    NSMutableArray<XYBlurButton *> *_items;
    UIButton *_closeBtn;
}

@end

@implementation XYBlurEffectView

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
        
    }
    return self;
}

- (void)setup {
    self.backgroundColor = [UIColor clearColor];
    _items = [NSMutableArray arrayWithCapacity:2];
    [self initBlurEffect];
    [self initCloseBtn];
    
}

- (void)initBlurEffect {
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *visualEffectView =[[UIVisualEffectView alloc] initWithEffect:blurEffect];
    [self addSubview:visualEffectView];
    [self insertSubview:visualEffectView atIndex:0];
    [visualEffectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

/// 关闭按钮
- (void)initCloseBtn {
    _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_closeBtn setImage:[UIImage imageNamed:@"tabbar_sendMsgTabbarItem"] forState:UIControlStateNormal];
    [self addSubview:_closeBtn];
    CGFloat wh = 40;
    CGFloat x = self.xy_width * 0.5 - wh * 0.5;
    CGFloat y = self.xy_height - wh;
    _closeBtn.alpha = 0;
    _closeBtn.frame = CGRectMake(x, y, wh, wh);
    [_closeBtn addTarget:self action:@selector(closeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setMenuItemList:(NSArray *)menuItemList {
    
    _menuItemList = menuItemList;
    if (_items.count > 0) {
        [_items removeAllObjects];
    }
    
    __block CGFloat y = self.xy_height;
    CGFloat x = self.xy_width * 0.5 - itemWH * 0.5;
    for (NSInteger i = 0; i < menuItemList.count; ++i) {
        XYBlurButton *btn = [XYBlurButton buttonWithType:UIButtonTypeCustom];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [btn setTag:i];
        [self addSubview:btn];
        /// 手指按下按钮时，放大按钮
        [btn addTarget:self action:@selector(scaleBtn:) forControlEvents:UIControlEventTouchDown];
        [btn addTarget:self action:@selector(resumeBtn:) forControlEvents:UIControlEventTouchUpInside];
        [btn addTarget:self action:@selector(drawExitBtn:) forControlEvents:UIControlEventTouchDragExit];
        XYBlurItem *item = menuItemList[i];
        [btn setImage:item.image forState:UIControlStateNormal];
        [btn setTitle:item.title forState:UIControlStateNormal];
        [_items addObject:btn];
        
        if (i == 1) {
            y = CGRectGetMaxY(_items.firstObject.frame) - itemWH * 0.5;
        }
        
        btn.frame = CGRectMake(x, y, itemWH, itemWH);
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            y = self.xy_height * 0.5 - itemWH * 0.5;
            if (i == 1) {
                y = self.xy_height * 0.5 + self.xy_height * 0.5 * 0.5 - itemWH * 0.5;
            }
            [UIView animateWithDuration:0.5 delay:i*0.02 usingSpringWithDamping:0.6 initialSpringVelocity:1.5 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
                // 让item出现
                btn.xy_y = y;
                _closeBtn.alpha = 1.0 * i+0.3;
            } completion:^(BOOL finished) {
                
            }];
        });
    }
    
}

#pragma mark - 对外开发的方法
- (void)showToView:(UIView *)view menuItemList:(NSArray<XYBlurItem *> *)list {
    
    if ([self isKindOfClass:[UIView class]]) {
        if (self.superview) {
            [self removeFromSuperview];
        }
        [view addSubview:self];
        [self setMenuItemList:list];
    }
    
}

+ (instancetype)showWithMenuItemList:(NSArray *)list {
    
    XYBlurEffectView *blurEffectView = [[XYBlurEffectView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [blurEffectView showToView:[UIApplication sharedApplication].keyWindow menuItemList:list];
    return blurEffectView;
}


+ (void)dismissWithAnimated:(BOOL)flag completion:(void (^)(BOOL))completion {
    __block XYBlurEffectView *blurEffectView = nil;
    for (UIView *view in [UIApplication sharedApplication].keyWindow.subviews) {
        if ([view isKindOfClass:[XYBlurEffectView class]]) {
            blurEffectView = (XYBlurEffectView *)view;
            break;
        }
    }
    [blurEffectView dismissWithAnimated:flag completion:completion];
    
}

- (void)dismissWithAnimated:(BOOL)flag completion:(void (^)(BOOL finished))completion {
    
    // 遍历items, 将item移动至底部看不见的范围, 即还原item的位置
    for (XYBlurButton *btn in self->_items) {
        NSLog(@"%@", btn);
        if (flag) {
            
            [UIView animateWithDuration:0.5 delay:btn.tag*0.02 usingSpringWithDamping:0.6 initialSpringVelocity:1.5 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
                btn.xy_y = self.xy_height;
                if (btn.tag == 1) {
                    btn.xy_y = self.xy_height + self.xy_height*0.5*0.5 - itemWH*0.5;
                }
                
                // 让colseBtn慢慢消失
                self->_closeBtn.alpha = 0;
            } completion:^(BOOL finished) {
                [btn removeFromSuperview];
                // 移除背景蒙版
                if (self != nil) {
                    [self removeFromSuperview];
                    
                }
                if (completion) {
                    completion(finished);
                }
            }];
        } else {
            btn.xy_y = self.xy_height;
            if (btn.tag == 1) {
                btn.xy_y = self.xy_height + self.xy_height*0.5*0.5 - itemWH*0.5;
            }
            
            // 让colseBtn慢慢消失
            self->_closeBtn.alpha = 0;
            // 移除背景蒙版
            if (self != nil) {
                [self removeFromSuperview];
                
            }

        }
    }
}

+ (void)dismiss {
    [self dismissWithAnimated:NO completion:nil];
}

#pragma mark - Events
- (void)scaleBtn:(UIButton *)btn {
    /// 放大按钮
    
    [UIView animateWithDuration:0.1 animations:^{
        btn.transform = CGAffineTransformMakeScale(1.0 + self.itemScale, 1.0 + self.itemScale);
    } completion:nil];
}

- (void)resumeBtn:(UIButton *)btn {
    
    [UIView animateWithDuration:0.1 animations:^{
        btn.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:nil];
    if (self.delegate && [self.delegate respondsToSelector:@selector(blurEffectView:didSelectItemWithType:)]) {
        [self.delegate blurEffectView:self didSelectItemWithType:btn.tag];
    }
}

/// 按钮退出托转时调用
- (void)drawExitBtn:(UIButton *)btn {
    [UIView animateWithDuration:0.1 animations:^{
        btn.transform = CGAffineTransformMakeScale(1.0, 1.0);
    }completion:nil];
}


- (void)closeBtnClick:(UIButton *)btn {
    
    /// 关闭
    [self dismissWithAnimated:YES completion:^(BOOL finished) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(blurEffectView:didSelectItemWithType:)]) {
            [self.delegate blurEffectView:self didSelectItemWithType:XYBlurEffectItemTypeClose];
        }
        
    }];
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [XYBlurEffectView dismissWithAnimated:YES completion:nil];
}

#pragma mark - set\get
- (CGFloat)itemScale {
    return _itemScale ?: 0.2;
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}

@end

@interface XYBlurItem ()


@end

@implementation XYBlurItem

+ (instancetype)blurItemWithImageNamed:(NSString *)imageNamed title:(NSString *)title {
    return [[self alloc] initWithImageNamed:imageNamed title:title];
}

- (instancetype)initWithImageNamed:(NSString *)imageNamed title:(NSString *)title {
    if (self = [super init]) {
        self.image = [UIImage imageNamed:imageNamed];
        self.title = title;
    }
    return self;
}

@end

@implementation XYBlurButton

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    CGFloat margin = 5;
    
    self.imageView.xy_y = 0;
    self.imageView.xy_height = self.xy_height - self.titleLabel.xy_height - margin;
    self.imageView.xy_width = self.imageView.xy_height;
    self.imageView.xy_centerX = self.xy_width * 0.5;
    
    self.titleLabel.xy_y = CGRectGetMaxY(self.imageView.frame) + margin;
    /// 当设置为imageView的中心点x值为button的中心点x值时，点击按钮后，imageView会向左偏移
    self.titleLabel.xy_centerX = self.imageView.xy_centerX;
    
}

- (void)setHighlighted:(BOOL)highlighted {}

@end
