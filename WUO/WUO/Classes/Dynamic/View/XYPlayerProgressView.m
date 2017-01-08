//
//  XYPlayerProgressView.m
//  WUO
//
//  Created by mofeini on 17/1/8.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

#import "XYPlayerProgressView.h"

#define margin 10.0
#define timeLabelFontSize 12

@interface XYPlayerProgressView () <UIGestureRecognizerDelegate>

/** 当前播放的时间 */
@property (nonatomic, assign) NSInteger currentPlayerTime;
/** 剩余播放的时间 */
@property (nonatomic, assign) NSInteger remainingTime;
@end

@implementation XYPlayerProgressView {
    UIButton *_playPauseBtn;             // 播放暂停按钮
    UISlider *_progressView;            // 播放进度条 滑竿
    UILabel *_currentPlayerTimeLabel;   // 当前播放的时间label
    UILabel *_remainingTimeLabel;       // 剩余时间label
    AVPlayer *_player;                  // 当前的播放器
    CADisplayLink *_link;
    UITapGestureRecognizer *_tapGesture;
    BOOL _isPlaying;
    CGFloat _videoPlaybackPosition;       // 视频需要播放的位置 . 当滑竿value移动时改变此值
    BOOL _isFirstLink;                     // 定时是不是第一次
}

- (instancetype)initWithFrame:(CGRect)frame player:(AVPlayer *)player {
    if (self = [self initWithFrame:frame]) {
        _player = player;
        _isPlaying = NO;
        [self initObserver];
        [self startDisplayLink];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        
    }
    return self;
}

- (void)setupUI {

    _playPauseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:_playPauseBtn];
    [_playPauseBtn setImage:[UIImage imageNamed:@"dynamic-video-player-play"] forState:UIControlStateNormal];
    [_playPauseBtn setImage:[UIImage imageNamed:@"dynamic-video-player-pause"] forState:UIControlStateSelected];
    [_playPauseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).mas_offset(margin);
        make.width.equalTo(@12);
        make.height.equalTo(@19);
        make.centerY.equalTo(self);
    }];
    [_playPauseBtn addTarget:self action:@selector(playPauseEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    _currentPlayerTimeLabel = [[UILabel alloc] init];
    _currentPlayerTimeLabel.textColor = [UIColor whiteColor];
    _currentPlayerTimeLabel.font = kFontWithSize(timeLabelFontSize);
    _currentPlayerTimeLabel.text = @"00:00";
    [self addSubview:_currentPlayerTimeLabel];
    [_currentPlayerTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_playPauseBtn.mas_right).mas_offset(margin);
        make.bottom.top.equalTo(self);
    }];
    
    _remainingTimeLabel = [[UILabel alloc] init];
    _remainingTimeLabel.textColor = [UIColor whiteColor];
    _remainingTimeLabel.font = kFontWithSize(timeLabelFontSize);
    _remainingTimeLabel.text = @"00:10";
    [self addSubview:_remainingTimeLabel];
    [_remainingTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).mas_offset(-margin);
        make.top.bottom.equalTo(self);
    }];
    
    _progressView = [[UISlider alloc] init];
    [_progressView setThumbImage:[UIImage imageNamed:@"dynamic_player"] forState:UIControlStateNormal];
    [self addSubview:_progressView];
    [_progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_currentPlayerTimeLabel.mas_right).mas_offset(margin);
        make.right.equalTo(_remainingTimeLabel.mas_left).mas_offset(-margin);
        make.centerY.equalTo(self);
    }];
    
    // 第一次进来时，就触发下播放暂停时间
    [self performSelector:@selector(playPauseEvent:) withObject:_playPauseBtn afterDelay:0.2];

    /*UISlider 事件
     ValueChanged: 当UISlider的值发生变化时调用.
     TouchDown: 当UISlider被按下时调用.
     TouchUpInside  松开时调用
     TouchUpOutside:
     */
    
    [_progressView addTarget:self action:@selector(sliderValueChangedEvent:) forControlEvents:UIControlEventValueChanged];
    [_progressView addTarget:self action:@selector(sliderTouchDownEvent:) forControlEvents:UIControlEventTouchDown];
    [_progressView addTarget:self action:@selector(sliderTouchUpInsideEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    // 给滑竿添加手势，实现单击取值
    _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTapGestureOnSlider:)];
    _tapGesture.delegate = self;
    [_progressView addGestureRecognizer:_tapGesture];
}


- (void)play {
    _playPauseBtn.selected = YES;
    [_player play];
    _isPlaying = YES;
    [self startDisplayLink];
}

- (void)pause {
    _playPauseBtn.selected = NO;
    [_player pause];
    [self endDisplayLink];
    _isPlaying = NO;

}


- (void)playerProgress {
    
    if (_isFirstLink) {

        // 计算当前播放时间, 视频总长度 * 滑竿的进度 = 当前应该所在播放位置
        float currentTime = CMTimeGetSeconds(_player.currentItem.duration) * _progressView.value;
        NSLog(@"%f", (float)_player.currentItem.duration.value);
        // 第一次开始定时器的时候，先让player从到滑动条最小值的位置开始播放
        [self seekVideoToPos:currentTime];
        NSLog(@"%f---%f", _progressView.value,  currentTime);
    }
    
    _isFirstLink = NO;
    
    NSLog(@"%f", CMTimeGetSeconds(_player.currentItem.currentTime));
    // currentTime：player播放的当前时间，duration： 总时长
    _progressView.value = CMTimeGetSeconds(_player.currentItem.currentTime) / CMTimeGetSeconds(_player.currentItem.duration);

    // 当前播放的时间
    self.currentPlayerTime = (NSInteger)CMTimeGetSeconds(_player.currentItem.currentTime);
    // 剩余时间
    self.remainingTime = (NSInteger)CMTimeGetSeconds(_player.currentItem.duration) - self.currentPlayerTime;
    
}

- (void)initObserver {
    
    // 监听播放到结尾的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerPlayToEndTime:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];

}



// 将NSInteger类型的秒，转换为00:00:00格式
- (NSString *)timeStringFromInteger:(NSInteger)secondCount {
   
    // 时
//    NSString *tmphh = [NSString stringWithFormat:@"%ld",secondCount / 3600];
//     NSLog(@"tmphh--%@", tmphh);
//    if ([tmphh length] == 1){
//        tmphh = [NSString stringWithFormat:@"0%@",tmphh];
//    }
    
    // 分
    NSString *tmpmm = [NSString stringWithFormat:@"%ld",(secondCount / 60) % 60];
    if ([tmpmm length] == 1) {
        tmpmm = [NSString stringWithFormat:@"0%@",tmpmm];
    }
    
    // 秒
    NSString *tmpss = [NSString stringWithFormat:@"%ld",secondCount % 60];
    if ([tmpss length] == 1)
    {
        tmpss = [NSString stringWithFormat:@"0%@",tmpss];
    }

//    NSLog(@"%@:%@", tmphh, tmpmm);
    return [NSString stringWithFormat:@"%@:%@",tmpmm,tmpss];
}

// 快进或后退视频
- (void)seekVideoToPos:(CGFloat)pos {
    
    CMTime time = CMTimeMakeWithSeconds(pos, _player.currentTime.timescale);
    [self.player seekToTime:time toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
}

#pragma mark - 属性设置
- (void)setCurrentPlayerTime:(NSInteger)currentPlayerTime {
    _currentPlayerTime = currentPlayerTime;
    
    _currentPlayerTimeLabel.text = [self timeStringFromInteger:currentPlayerTime];
}

- (void)setRemainingTime:(NSInteger)remainingTime {
    _remainingTime = remainingTime;
    
    _remainingTimeLabel.text = [self timeStringFromInteger:remainingTime];
}

#pragma mark - 事件监听
// 点击播放暂停按钮时调用
- (void)playPauseEvent:(UIButton *)btn {
    
    if (!_isPlaying) {
        [self play];
    } else {
        [self pause];
    }
    
    if (self.playPauseCallBack) {
        self.playPauseCallBack(btn);
    }
}


// 播放完成时调用
- (void)playerPlayToEndTime:(NSNotification *)note {
    [self seekVideoToPos:0];
    _playPauseBtn.selected = NO;
    _progressView.value = 0;
    [self endDisplayLink];
}

/**
 当按下滑竿按钮时，暂停播放
 当松开滑竿按钮时，继续播放
 当滑竿的value发生改变时，更新播放进度，让当前播放器的时间快进或后退到用户选择的时间
 当单击整个滑竿时，更新播放进度，让当前播放器的时间快进或后退到用户选择的时间
 */

// 按下滑竿按钮的时候调用
- (void)sliderTouchDownEvent:(id)sender {
    _tapGesture.enabled = NO;
    
    [self pause];
}

// 松开滑竿按钮的时候调用
- (void)sliderTouchUpInsideEvent:(id)sender {
    _tapGesture.enabled = YES;
    
    [self play];
}

// 滑竿的value发生改变的时候调用
- (void)sliderValueChangedEvent:(UISlider *)sender {
    // 计算当前播放时间, 视频总长度秒 * 滑竿的进度 = 当前应该所在播放位置秒
    float currentTime = CMTimeGetSeconds(_player.currentItem.duration) * _progressView.value;
    NSLog(@"%f", (float)_player.currentItem.duration.value);
    [self seekVideoToPos:currentTime];
    
}

// 单击整个滑动条时调用
- (void)actionTapGestureOnSlider:(UITapGestureRecognizer*)tap {
    // 手指按下时，暂停播放，并调整视频的位置到当前滑竿的位置
    [self pause];
    CGPoint touchPoint = [tap locationInView:_progressView];
    CGFloat value = (_progressView.maximumValue - _progressView.minimumValue) * (touchPoint.x / _progressView.frame.size.width );
    [_progressView setValue:value animated:YES];
    
    [self seekVideoToPos:_progressView.value];
    
    switch (tap.state) {
            
        case UIGestureRecognizerStateBegan:
            // 手指按下时，不调用这里
            break;
            // 手指松开时，继续播放，且从滑动当前的位置开始播放
        case UIGestureRecognizerStateEnded:
            [self play];
            break;
        default:
            break;
    }
    
}


#pragma mark - 定时器
- (void)startDisplayLink {
    if (_link == nil) {
        _isFirstLink = YES;
        _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(playerProgress)];
        [_link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    }
}

- (void)endDisplayLink {
    if (_link) {
        
        [_link removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
        [_link invalidate];
        _link = nil;
    }
}


- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self endDisplayLink];
    NSLog(@"%s", __func__);
}

@end
