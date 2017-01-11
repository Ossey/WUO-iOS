//
//  XYTopicDetailLabelView.m
//  WUO
//
//  Created by mofeini on 17/1/10.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

#import "XYTopicDetailLabelView.h"

@implementation XYTopicDetailLabelView

- (instancetype)initWithFrame:(CGRect)frame delegate:(id)delegate channelCates:(NSArray<NSDictionary *> *)channelCates rightBtnWidth:(CGFloat)rightBtnWidth {
    
    if (self = [super initWithFrame:frame delegate:delegate channelCates:channelCates rightBtnWidth:rightBtnWidth]) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.titleItemFont = kFontWithSize(11);
        self.itemScale = 0.2;
        self.underLineBackgroundColor = [UIColor blackColor];
        self.itemWidth = kScreenW * 0.5;
        self.underLineWidth = 50;
        self.separatorImage = [UIImage new];
    
    }
    
    return self;
}

@end
