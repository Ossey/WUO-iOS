//
//  XYPlayerViewController.m
//  WUO
//
//  Created by mofeini on 17/1/8.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

#import "XYPlayerViewController.h"
#import "XYPlayerView.h"

@interface XYPlayerViewController () {
    NSURL *_videoURL;
    
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

    XYPlayerView *playerView = [[XYPlayerView alloc] initWithFrame:self.view.bounds videoURL:_videoURL];
    [self.view addSubview:playerView];
    [playerView setCloseEvent:^{
        [self dismissViewControllerAnimated:YES completion:nil];
    }];

}





- (void)dealloc {
    NSLog(@"%s", __func__);
}

@end
