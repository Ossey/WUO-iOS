//
//  XYPlayerViewController.m
//  WUO
//
//  Created by mofeini on 17/1/8.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

#import "XYPlayerViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "XYPlayerProgressView.h"

@interface XYPlayerViewController () {
    NSURL *_videoURL;
    AVPlayer *_player;
    AVPlayerItem *_playerItem;
    AVPlayerLayer *_playerLayer;
    XYPlayerProgressView *_progressView;
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
    _playerLayer.frame = self.view.bounds;
    [self.view.layer addSublayer:_playerLayer];
    

    
    CGFloat progressViewH = 25;
    CGFloat bottomMargin = 10;
    _progressView = [[XYPlayerProgressView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame) - progressViewH - bottomMargin, CGRectGetWidth(self.view.frame), progressViewH) player:_player];
    [self.view addSubview:_progressView];
    
    [self initObserver];
}

- (void)initObserver {
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [_player pause];
}


@end
