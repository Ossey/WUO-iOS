//
//  XYRefreshGifHeader.m
//  WUO
//
//  Created by mofeini on 17/1/3.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

#import "XYRefreshGifHeader.h"

@implementation XYRefreshGifHeader

- (instancetype)init {
    
    if (self = [super init]) {
     
        self.lastUpdatedTimeLabel.hidden = YES;
        self.stateLabel.hidden = YES;
        
        NSMutableArray *images = [NSMutableArray arrayWithCapacity:16];
        for (int i = 1; i < 17; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"refresh_%d", i]];
            [images addObject:image];
        }
        
        [self setImages:images forState:MJRefreshStateRefreshing];
        [self setImages:images forState:MJRefreshStatePulling];
        [self setImages:images forState:MJRefreshStateIdle];
    }
    
    return self;
}

@end
