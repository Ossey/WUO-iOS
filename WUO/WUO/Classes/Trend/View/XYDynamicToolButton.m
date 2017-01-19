//
//  XYDynamicToolButton.m
//  WUO
//
//  Created by mofeini on 17/1/2.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

#import "XYDynamicToolButton.h"

@implementation XYDynamicToolButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.titleLabel setFont:[UIFont systemFontOfSize:11]];
        [self setTitleColor:kColorCountText forState:UIControlStateNormal];
    }
    return self;
}
- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    self.imageView.xy_y = 0;
    self.imageView.xy_height = self.xy_height - self.titleLabel.xy_height;
    self.imageView.xy_width = self.imageView.xy_height;
    self.imageView.xy_x = 0;
    
    self.titleLabel.xy_y = CGRectGetMaxY(self.imageView.frame);
    // 当设置为imageView的中心点x值为button的中心点x值时，点击按钮后，imageView会向左偏移
    self.titleLabel.xy_centerX = self.imageView.xy_centerX;
    //    self.imageView.xy_centerX = self.titleLabel.xy_centerX;
    
    [self sizeToFit];

}

@end
