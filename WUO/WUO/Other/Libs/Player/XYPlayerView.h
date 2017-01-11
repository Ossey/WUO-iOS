//
//  XYPlayerView.h
//  WUO
//
//  Created by mofeini on 17/1/11.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYPlayerControl.h"

@interface XYPlayerView : UIView

@property (nonatomic, strong, readonly) AVPlayerLayer *playerLayer;
@property (nonatomic, strong) XYPlayerControl *playerControl;
@property (nonatomic, copy) void (^closeCallBack)();
/**
 *  菊花（加载框）
 */
@property (nonatomic,strong) UIActivityIndicatorView *loadingView;

- (instancetype)initWithFrame:(CGRect)frame videoURL:(NSURL *)URL;


@end
