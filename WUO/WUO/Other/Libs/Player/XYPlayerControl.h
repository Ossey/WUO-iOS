//
//  XYPlayerControl.h
//  WUO
//
//  Created by mofeini on 17/1/8.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//  播放控制视图

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

// 播放器的播放状态
typedef NS_ENUM(NSInteger, XYPlayerState) {
    XYPlayerStateFailed,        // 播放失败
    XYPlayerStateBuffering,     // 缓存中， 缓存不充足
    XYPlayerStateReadyToPlay,   // 将要播放
    XYPlayerStatePlaying,       // 播放中
    XYPlayerStatePause,         // 暂停播放
    XYPlayerStateEnd,           // 播放完毕
};


@interface XYPlayerControl : UIView

@property (nonatomic, copy) void (^playPauseCallBack)(UIButton *btn);
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, assign) XYPlayerState state;
/**
 * @explain 播放状态发送改变的回调
 */
@property (nonatomic, copy) void (^playerStateChangeBlock)(XYPlayerState);


/**
 * @explain 播放控制，播放时会开启一个定时器，用于监听播放的进度，做快进后退，外界停止播放时，需要调用pause，销毁定时器
 */
- (void)play;
- (void)pause;
- (instancetype)initWithFrame:(CGRect)frame player:(AVPlayer *)player;
@end
