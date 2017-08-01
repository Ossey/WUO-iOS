//
//  XYRefreshGifFooter.m
//  WUO
//
//  Created by mofeini on 17/1/3.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

#import "XYRefreshGifFooter.h"

@implementation XYRefreshGifFooter

- (instancetype)init {
    
    if (self = [super init]) {
    
        self.stateLabel.hidden = YES;
        
        NSMutableArray *images = [NSMutableArray arrayWithCapacity:16];
        for (NSInteger i = 1; i < 17; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"refresh_%ld", i]];
            [images addObject:image];
        }
        
        [self setImages:images forState:MJRefreshStateRefreshing];
        [self setImages:images forState:MJRefreshStatePulling];
        [self setImages:images forState:MJRefreshStateIdle];
    }
    
    return self;
}

@end
