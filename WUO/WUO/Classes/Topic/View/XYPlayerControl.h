//
//  XYPlayerControl.h
//  WUO
//
//  Created by mofeini on 17/1/8.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//  播放控制视图

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>


@interface XYPlayerControl : UIView


- (instancetype)initWithFrame:(CGRect)frame player:(AVPlayer *)player;

@property (nonatomic, copy) void (^playPauseCallBack)(UIButton *btn);
@property (nonatomic, strong) AVPlayer *player;

/**
 * @explain 播放控制，播放时会开启一个定时器，用于监听播放的进度，做快进后退，外界停止播放时，需要调用pause，销毁定时器
 *
 */
- (void)play;
- (void)pause;


@end
