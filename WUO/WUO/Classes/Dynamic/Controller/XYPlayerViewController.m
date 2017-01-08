//
//  XYPlayerViewController.m
//  WUO
//
//  Created by mofeini on 17/1/8.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

#import "XYPlayerViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "XYPlayerControl.h"

@interface XYPlayerViewController () {
    NSURL *_videoURL;
    AVPlayer *_player;
    AVPlayerItem *_playerItem;
    AVPlayerLayer *_playerLayer;
    XYPlayerControl *_playerControl;
}
@end

@implementation XYPlayerViewController

- (instancetype)initWithVideoURL:(NSURL *)URL {
    if (self = [super init]) {
        _videoURL = URL;
        self.view.backgroundColor = [UIColor blackColor];
    }
    
    return self;
}

+ (void)presenteViewControllerWithVideoURL:(NSURL *)URL {
    
    XYPlayerViewController *playerVc = [[XYPlayerViewController alloc] initWithVideoURL:URL];
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:playerVc animated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _playerItem = [AVPlayerItem playerItemWithURL:_videoURL];
    _player = [AVPlayer playerWithPlayerItem:_playerItem];
    _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
    // 设置画面缩放模式
    _playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    _playerLayer.frame = self.view.bounds;
    [self.view.layer addSublayer:_playerLayer];
    
    CGFloat progressViewH = 25;
    CGFloat bottomMargin = 15;
    _playerControl = [[XYPlayerControl alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame) - progressViewH - bottomMargin, CGRectGetWidth(self.view.frame), progressViewH) player:_player];
    [self.view addSubview:_playerControl];
    
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = touches.anyObject;
    // 获取手指在view上的位置
    CGPoint point = [touch locationInView:self.view];
    // 当手指在播放进度view以上的位置，点击时才可以响应以下事件
    if (point.y < _playerControl.frame.origin.y) {
        
        [self dismissViewControllerAnimated:YES completion:^{
            [_playerControl pause];
        }];
    }
    
}


- (void)dealloc {
    NSLog(@"%s", __func__);
}

@end
