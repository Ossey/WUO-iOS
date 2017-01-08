//
//  XYPlayerProgressView.h
//  WUO
//
//  Created by mofeini on 17/1/8.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>


@interface XYPlayerProgressView : UIView


- (instancetype)initWithFrame:(CGRect)frame player:(AVPlayer *)player;

@property (nonatomic, copy) void (^playPauseCallBack)(UIButton *btn);
@property (nonatomic, strong) AVPlayer *player;

@end
