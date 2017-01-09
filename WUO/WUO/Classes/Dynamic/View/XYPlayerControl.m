//
//  XYPlayerControl.m
//  WUO
//
//  Created by mofeini on 17/1/8.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//  播放控制视图

#import "XYPlayerControl.h"

#define margin 10.0
#define timeLabelFontSize 12

@interface XYPlayerControl ()

/** 当前播放的时间 */
@property (nonatomic, assign) NSInteger currentPlayerTime;
/** 剩余播放的时间 */
@property (nonatomic, assign) NSInteger remainingTime;
@end

@implementation XYPlayerControl {
    // 播放暂停按钮
    UIButton *_playPauseBtn;
    // 滑竿 显示及控制播放进度条 当前项目此滑竿是展示下载缓存进度的，并不是播放进度，我这里写为播放进度，我未缓存视频数据
    UISlider *_slider;
    // 缓存进度条
    UIProgressView *_bufferProgressView;
    // 当前播放的时间label
    UILabel *_currentPlayerTimeLabel;
    // 剩余时间label
    UILabel *_remainingTimeLabel;
    // 当前的播放器
    AVPlayer *_player;
    // 定时器
    CADisplayLink *_link;
    UITapGestureRecognizer *_tapGesture;
    // 是否正在播放视频
    BOOL _isPlaying;
    // 视频需要播放的位置 . 当滑竿value移动时改变此值
    CGFloat _videoPlaybackPosition;
    // 是不是CADisplayLink的第一帧执行
    BOOL _isFirstLink;
}

- (instancetype)initWithFrame:(CGRect)frame player:(AVPlayer *)player {
    if (self = [self initWithFrame:frame]) {
        _player = player;
        // 设置plyer音量 范围 0 - 1，默认为 1
        player.volume = 0.9;
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
        make.left.equalTo(self).mas_offset(0);
        make.width.equalTo(@40); // 让按钮可点击范围大一些，避免用户不容易点击到按钮
        make.height.equalTo(@19);
        make.centerY.equalTo(self);
    }];
    [_playPauseBtn addTarget:self action:@selector(playPauseEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    _currentPlayerTimeLabel = [[UILabel alloc] init];
    _currentPlayerTimeLabel.textColor = [UIColor whiteColor];
    _currentPlayerTimeLabel.contentMode = UIViewContentModeCenter;
    _currentPlayerTimeLabel.font = kFontWithSize(timeLabelFontSize);
    _currentPlayerTimeLabel.text = @"00:00";
    [self addSubview:_currentPlayerTimeLabel];
    [_currentPlayerTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_playPauseBtn.mas_right).mas_offset(margin);
        make.bottom.top.equalTo(self);
    }];
    
    _remainingTimeLabel = [[UILabel alloc] init];
    _remainingTimeLabel.textColor = [UIColor whiteColor];
    _remainingTimeLabel.contentMode = UIViewContentModeCenter;
    _remainingTimeLabel.font = kFontWithSize(timeLabelFontSize);
    _remainingTimeLabel.text = @"00:10";
    [self addSubview:_remainingTimeLabel];
    [_remainingTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).mas_offset(-margin);
        make.top.bottom.equalTo(self);
    }];
    
    // 显示缓冲进度条
    _bufferProgressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    [self addSubview:_bufferProgressView];
    NSLog(@"%d", _bufferProgressView.userInteractionEnabled);
    [_bufferProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_currentPlayerTimeLabel.mas_right).mas_offset(margin);
        make.right.equalTo(_remainingTimeLabel.mas_left).mas_offset(-margin);
        make.centerY.equalTo(self);
    }];
    
    // 控制器播放进度的滑竿
    _slider = [[UISlider alloc] init];
    [self addSubview:_slider];
    [_slider mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.edges.equalTo(_bufferProgressView);
        make.left.equalTo(_currentPlayerTimeLabel.mas_right).mas_offset(margin);
        make.right.equalTo(_remainingTimeLabel.mas_left).mas_offset(-margin);
        make.centerY.equalTo(self);
    }];
    
    //    [self layoutIfNeeded];
    // 让_slider 中间只有ThumbImage了，把UISlider添加至UIProgressView上面，即可让滑竿上显示缓冲进度了
    //    UIGraphicsBeginImageContextWithOptions(CGSizeMake(_bufferProgressView.xy_width * 0.5, _bufferProgressView.xy_height), NO, 0.0f);
    //    UIImage *transparentImage = UIGraphicsGetImageFromCurrentImageContext();
    //    UIGraphicsEndImageContext();
    //    [_slider setMinimumTrackImage:transparentImage forState:UIControlStateNormal];
    //    [_slider setMaximumTrackImage:transparentImage forState:UIControlStateNormal];
    [_slider setMinimumTrackTintColor:[UIColor clearColor]];
    [_slider setMaximumTrackTintColor:[UIColor clearColor]];
    [_slider setThumbImage:[UIImage imageNamed:@"dynamic_player"] forState:UIControlStateNormal];
    
    
    
    // 第一次进来时，就触发下播放暂停时间
    [self performSelector:@selector(playPauseEvent:) withObject:_playPauseBtn afterDelay:0.1];
    
    /*UISlider 事件
     ValueChanged: 当UISlider的值发生变化时调用.
     TouchDown: 当UISlider被按下时调用.
     TouchUpInside  松开时调用
     */
    
    [_slider addTarget:self action:@selector(sliderValueChangedEvent:) forControlEvents:UIControlEventValueChanged];
    [_slider addTarget:self action:@selector(sliderTouchDownEvent:) forControlEvents:UIControlEventTouchDown];
    [_slider addTarget:self action:@selector(sliderTouchUpInsideEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    // 给滑竿添加手势，实现单击取值
    _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTapGestureOnSlider:)];
    [_slider addGestureRecognizer:_tapGesture];
}


- (void)initObserver {
    
    // 监听播放到结尾的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerPlayToEndTime:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    
    /// KVO监听playerItem
    // 监听准备播放状态属性
    [_player.currentItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    // 监听缓冲进度属性
    [_player.currentItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    // 监听播放器在缓冲数据的状态 , 缓冲数据为空，而且有效时间内数据无法补充，播放失败 缓冲不足会暂停 || 由于 AVPlayer 缓存不足就会自动暂停，所以缓存充足了需要手动播放，才能继续播放
    [_player.currentItem addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:nil];
    [_player.currentItem addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew context:nil];
    
}



// 将NSInteger类型的秒，转换为00:00:00格式
- (NSString *)coverTime:(NSInteger)secondCount {
    
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

#pragma mark - AVPlayer相关设置

- (void)play {
//    if (!_isPlaying) {
        // 播放时需要判断是否可以播放，再设置以下数据，比如有时明明网络有问题点击了播放，实际并未播放，以下状态却改变了是不行的
        [_player play];
        // 设置播放速率---默认为 1.0 (normal speed)，设为 0.0 时暂停播放。设置后立即开始播放，可放在开始播放后设置
        _player.rate = 1.0;
        //    if (_player.status == AVPlayerItemStatusReadyToPlay) {
        _playPauseBtn.selected = YES;
        _isPlaying = YES;
        [self startDisplayLink];
        //    }
        
//    }
    
}

- (void)pause {
//    if (_isPlaying) {
        [_player pause];
        _playPauseBtn.selected = NO;
        [self stopDisplayLink];
        _isPlaying = NO;
//    }
    
}

// 跳到指定位置播放
- (void)seekVideoToPos:(CGFloat)pos {
    
    CMTime time = CMTimeMakeWithSeconds(pos, _player.currentTime.timescale);
    [self.player seekToTime:time toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
}

#pragma mark - 属性设置
- (void)setCurrentPlayerTime:(NSInteger)currentPlayerTime {
    _currentPlayerTime = currentPlayerTime;
    
    _currentPlayerTimeLabel.text = [self coverTime:currentPlayerTime];
}

- (void)setRemainingTime:(NSInteger)remainingTime {
    _remainingTime = remainingTime;
    
    _remainingTimeLabel.text = [self coverTime:remainingTime];
}

#pragma mark - 事件监听
// 定时器监听的事件
- (void)playerProgress {
    
    if (_isFirstLink) {
        
        // 计算当前播放时间, 视频总长度 * 滑竿的进度 = 当前应该所在播放位置
        float currentTime = CMTimeGetSeconds(_player.currentItem.duration) * _slider.value;
        //        NSLog(@"%f", (float)_player.currentItem.duration.value);
        // 第一次开始定时器的时候，先让player从到滑动条最小值的位置开始播放
        [self seekVideoToPos:currentTime];
        //        NSLog(@"%f---%f", _slider.value,  currentTime);
    }
    
    _isFirstLink = NO;
    
    //    NSLog(@"%f", CMTimeGetSeconds(_player.currentItem.currentTime));
    // currentTime：player播放的当前时间，duration： 总时长
    _slider.value = CMTimeGetSeconds(_player.currentItem.currentTime) / CMTimeGetSeconds(_player.currentItem.duration);
    
    // 当前播放的时间
    self.currentPlayerTime = (NSInteger)CMTimeGetSeconds(_player.currentItem.currentTime);
    // 剩余时间
    self.remainingTime = (NSInteger)CMTimeGetSeconds(_player.currentItem.duration) - self.currentPlayerTime;
    
}



// KVO 回调
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    // 取出被观察的对象
    AVPlayerItem *playerItem = (AVPlayerItem *)object;
    
    // 播放的状态监听
    if ([keyPath isEqualToString:@"status"]) {
        
        switch (playerItem.status) {
            case AVPlayerItemStatusReadyToPlay:
                _isPlaying = YES;
                break;
            case AVPlayerItemStatusUnknown:
                [self pause];
                break;
            case AVPlayerItemStatusFailed:
                [self pause];
                break;
                
            default:
                break;
        }
    }
    
    // 监听播放器的下载进度
    if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        // 获取视频的缓冲进度
        NSArray<NSValue *> *loadedTimeRanges = playerItem.loadedTimeRanges;
        // 获取缓冲区域
        CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];
        // 视频开始播放的时间
        float startSecods = CMTimeGetSeconds(timeRange.start);
        // 总大小
        float durationSeconds = CMTimeGetSeconds(timeRange.duration);
        // 计算缓冲进度
        NSTimeInterval timeInterval = startSecods + durationSeconds;
        CMTime duration = playerItem.duration;
        CGFloat totalDuration = CMTimeGetSeconds(duration);
        // 缓存进度
        CGFloat progress = timeInterval / totalDuration;
        
        [_bufferProgressView setProgress:progress animated:YES];
        //         NSLog(@"下载进度：%.2f", progress);
        NSLog(@"视频开始播放时的时间:%f--总时长：%f -- 缓冲进度%f", startSecods, durationSeconds, progress);
        if (progress > 0.00) {
            // 大于0，说明已经开始缓冲了，视频可以播放了
            //            _playPauseBtn.selected = YES; // 在这里跳转按钮的选中状态，会有延迟
            _isPlaying = YES;
            
        }
    }
    
    // 监听播放器在缓冲数据的状态
    if ([keyPath isEqualToString:@"playbackBufferEmpty"]) {
        if (playerItem.playbackBufferEmpty == YES) {
            NSLog(@"缓存不足，强制暂停");
            [self pause];
        }
    }
    
    if ([keyPath isEqualToString:@"playbackLikelyToKeepUp"]) {
        if (playerItem.playbackLikelyToKeepUp) {
            
            // 缓存可达到播放的进度了。
            //由于 AVPlayer 缓存不足就会自动暂停，所以缓存充足了需要手动播放，才能继续播放
            [self player];
        }
    }
}

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
    // 还原以下数据
    [self seekVideoToPos:0];
    _playPauseBtn.selected = NO;
    [_slider setValue:0.00 animated:YES];
    self.currentPlayerTime = 0;
    self.remainingTime = CMTimeGetSeconds(_player.currentItem.duration);
    
    [self stopDisplayLink];
    
#warning TODO 当视频播放完成后，应显示视频的第一帧
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
    float currentTime = CMTimeGetSeconds(_player.currentItem.duration) * _slider.value;
    //    NSLog(@"%f", (float)_player.currentItem.duration.value);
    [self seekVideoToPos:currentTime];
    
}

// 单击整个滑动条时调用
- (void)actionTapGestureOnSlider:(UITapGestureRecognizer*)tap {
    // 手指按下时，暂停播放，并调整视频的位置到当前滑竿的位置
    [self pause];
    CGPoint touchPoint = [tap locationInView:_slider];
    // 用当前的手指在滑竿的x值 ➗ 滑竿的宽度 得到比例，计算滑竿滑动时的进度
    CGFloat value = (_slider.maximumValue - _slider.minimumValue) * (touchPoint.x / _slider.frame.size.width );
    // 使用滑竿的进度快进或后退视频
    [_slider setValue:value animated:YES];
    float currentTime = CMTimeGetSeconds(_player.currentItem.duration) * value;
    
    [self seekVideoToPos:currentTime];
    
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

- (void)stopDisplayLink {
    if (_link) {
        [_link removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
        [_link invalidate];
        _link = nil;
    }
}


- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_player.currentItem removeObserver:self forKeyPath:@"status"];
    [_player.currentItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [_player.currentItem removeObserver:self forKeyPath:@"playbackBufferEmpty"];
    [_player.currentItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
    [self stopDisplayLink];
    NSLog(@"%s", __func__);
}

@end
