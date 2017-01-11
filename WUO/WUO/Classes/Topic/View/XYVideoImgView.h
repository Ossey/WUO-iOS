//
//  XYVideoImgView.h
//  WUO
//
//  Created by mofeini on 17/1/8.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

#import <YYImage/YYImage.h>

@class XYVideoImgView, XYTopicViewModel;
@protocol XYVideoImgViewDelegate <NSObject>

@optional
/**
 * @explain 点击图片中间的播放按钮时调用
 *
 */
- (void)videoImgView:(XYVideoImgView *)imgView playBtn:(UIButton *)btn;

@end

@interface XYVideoImgView : YYAnimatedImageView

@property (nonatomic, strong) XYTopicViewModel *viewModel;

@property (nonatomic, weak) id<XYVideoImgViewDelegate> delegate;
@property (nonatomic, copy) void(^playBtnCallBack)(UIButton *);

@end
