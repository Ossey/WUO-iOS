//
//  XYAdvertView.m
//  WUO
//
//  Created by mofeini on 17/1/5.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//  广告视图

#import "XYAdvertView.h"
#import "XRCarouselView.h"
#import "XYAdvertItem.h"

@interface XYAdvertView () <XRCarouselViewDelegate>

@end
@implementation XYAdvertView


- (void)setAdvertItems:(NSArray *)advertItems {
    
    _advertItems = advertItems;
    
    /**
     注意: 这里数组不要使用懒加载，会导致重复添加，崩溃
     */
    NSMutableArray *imageURLs = [NSMutableArray array];
    for (XYAdvertItem *item in advertItems) {
        [imageURLs addObject:item.imgs];
    }
    
    XRCarouselView *view = [[XRCarouselView alloc] init];
    [view setImageArray:imageURLs];
    view.time = 2.0;
    view.delegate = self;
    view.frame = self.bounds;
    [self addSubview:view];
}

#pragma mark - XRCarouselViewDelegate
- (void)carouselView:(XRCarouselView *)carouselView clickImageAtIndex:(NSInteger)index {
    
    NSLog(@"%ld", index);
    if (self.advertClickBlock) {
        self.advertClickBlock(self.advertItems[index]);
    }
}

@end
