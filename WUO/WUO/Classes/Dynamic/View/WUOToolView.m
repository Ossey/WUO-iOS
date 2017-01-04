//
//  WUOToolView.m
//  WUO
//
//  Created by mofeini on 17/1/4.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

#import "WUOToolView.h"
#import "XYDynamicToolButton.h"

@implementation WUOToolView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        NSInteger count = 4;
        CGFloat x = 0;
        CGFloat y = 0;
        CGFloat h = SIZE_TOOLVIEWH;
        CGFloat w = (kScreenW - SIZE_GAP_MARGIN * 2 - SIZE_HEADERWH - SIZE_GAP_PADDING) / count;
        
        for (NSInteger i = 0; i < count; ++i) {
            x = i * w;
            XYDynamicToolButton *button = [XYDynamicToolButton buttonWithType:UIButtonTypeCustom];
            [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = i;
            [self addSubview:button];
            [button setFrame:CGRectMake(x, y, w, h)];
            [button setImage:[UIImage imageNamed:[self imageNames][i]] forState:UIControlStateNormal];
            [button setTitle:[NSString stringWithFormat:@"%d", 0] forState:UIControlStateNormal];
            
            switch (i) {
                case WUOToolViewEventTypeShare:
                    _shareBtn = button;
                    break;
                case WUOToolViewEventTypeComment:
                    _commentBtn = button;
                    break;
                case WUOToolViewEventTypeReward:
                    _rewardBtn = button;
                    break;
                case WUOToolViewEventTypePraise:
                    _praiseBtn = button;
                    break;
                    
                default:
                    break;
            }
        }
    }
    return self;
}

- (void)btnClick:(UIButton *)btn {
    
    if (self.toolViewEventBlock) {
        self.toolViewEventBlock(btn, btn.tag);
    }
}

- (NSArray *)imageNames {
    
    return @[@"Home_detailShare", @"Home_detailComment", @"Home_detailReward", @"Home_detailPraise"];
}


@end
