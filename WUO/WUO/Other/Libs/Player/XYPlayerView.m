//
//  XYPlayerView.m
//  WUO
//
//  Created by mofeini on 17/1/11.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

#import "XYPlayerView.h"
#import "XYPlayerControl.h"

@interface XYPlayerView ()

@property (nonatomic, strong) UIActivityIndicatorView *loadingView;// 菊花

@end

@implementation XYPlayerView {
    NSURL *_videoURL;
    AVPlayer *_player;
    AVPlayerItem *_playerItem;
    
}

+ (Class)layerClass {
    return [AVPlayerLayer class];
}

- (AVPlayerLayer *)playerLayer {
    return (AVPlayerLayer *)self.layer;
}

- (instancetype)initWithFrame:(CGRect)frame videoURL:(NSURL *)URL {
    if (self = [super initWithFrame:frame]) {
        _videoURL = URL;
        [self setup];
    }
    return self;
}


- (void)setup {
    
    _playerItem = [AVPlayerItem playerItemWithURL:_videoURL];
    _player = [AVPlayer playerWithPlayerItem:_playerItem];
    [self.playerLayer setPlayer:_player];
    // 设置画面缩放模式
    self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    
    CGFloat progressViewH = 25;
    CGFloat bottomMargin = 15;
    _playerControl = [[XYPlayerControl alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame) - progressViewH - bottomMargin, CGRectGetWidth(self.frame), progressViewH) player:_player];
    [self addSubview:_playerControl];
    
    // 菊花
    _loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [self addSubview:_loadingView];
    [_loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
       make.center.equalTo(self);
    }];
    [_loadingView startAnimating];
    [self bringSubviewToFront:_loadingView];
    
    // 根据播放状态 更新 菊花
    __weak typeof(self) weakSelf = self;
    [self.playerControl setPlayerStateChangeBlock:^(XYPlayerState state) {
        switch (state) {
            case XYPlayerStatePlaying:
                [weakSelf.loadingView stopAnimating];
                break;
            case XYPlayerStateBuffering:
                [weakSelf.loadingView startAnimating];
                break;
            case XYPlayerStateReadyToPlay:
                [weakSelf.loadingView stopAnimating];
                break;
            case XYPlayerStateFailed:
                [weakSelf.loadingView startAnimating];
                [weakSelf xy_showMessage:@"网络请求失败"];
                break;

            default:
                [weakSelf.loadingView stopAnimating];
                break;
        }
    }];
    
    // 添加点按手势
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureOnSelf:)]];
}

#pragma mark - Events 
- (void)tapGestureOnSelf:(UITapGestureRecognizer *)tap {
    
    // 获取手指在view上的位置
    CGPoint point = [tap locationInView:tap.view];
    // 当手指在播放进度view以上的位置，点击时才可以响应以下事件, 让_playerControl自身及其y值以上50的范围内，不响应手势事件
    if (point.y < _playerControl.frame.origin.y - 50) {
        [self.playerControl pause];
        if (self.closeEvent) {
            self.closeEvent();
            [self releaseSelf];
        }
    }
}

- (void)releaseSelf {
    // 执行完block后，让block释放,不然会有循环引用
    self.closeEvent = nil;
    [super removeFromSuperview];
}

- (void)dealloc {
    NSLog(@"%s", __FUNCTION__);
}

@end
