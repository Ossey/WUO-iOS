//
//  XYVideoImgView.m
//  WUO
//
//  Created by mofeini on 17/1/8.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

#import "XYVideoImgView.h"
#import "XYTrendViewModel.h"
#import <UIImageView+WebCache.h>
#import "XYPlayerViewController.h"

// UIImageView是不会调用drawRect:(CGRect)rect方法的
@implementation XYVideoImgView {
    UIButton *_btn;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.userInteractionEnabled = YES;
        [self setClipsToBounds:YES];
        _btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_btn];
        [_btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.width.height.equalTo(@40);
        }];
        [_btn setImage:[UIImage imageNamed:@"dynamic_listPlayerVideo"] forState:UIControlStateNormal];
        [_btn addTarget:self action:@selector(playEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return self;
}

- (void)playEvent:(UIButton *)btn {
    
    [XYPlayerViewController presenteViewControllerWithVideoURL:self.item.videoFullURL];
    
    if (self.playBtnCallBack) {
        self.playBtnCallBack(btn);
        return;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(videoImgView:playBtn:)]) {
        [self.delegate videoImgView:self playBtn:_btn];
    }
}

- (void)setItem:(XYTrendItem *)item {
    _item = item;
    
    if (item.videoUrl.length) {
        self.hidden = NO;
        [self sd_setImageWithURL:item.videoImgFullURL];
    } else {
        self.hidden = YES;
    }
}

//- (void)setViewModel:(XYTrendViewModel *)viewModel {
//    _viewModel = viewModel;
//    
//    XYTrendItem * item = viewModel.item;
//    if (item.videoUrl.length) {
//        self.hidden = NO;
//        [self sd_setImageWithURL:item.videoImgFullURL];
//    } else {
//        self.hidden = YES;
//    }
//    self.frame = viewModel.videoImgViewFrame;
//}

@end
