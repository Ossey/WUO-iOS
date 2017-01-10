//
//  XYCateSelecteView.m
//
//  Created by mofeini on 16/12/14.
//  Copyright © 2016年 com.test.demo. All rights reserved.
//

#import "XYTrendLabelView.h"

@implementation XYTrendLabelView

- (instancetype)initWithFrame:(CGRect)frame delegate:(id)delegate channelCates:(NSArray<NSDictionary *> *)channelCates rightBtnWidth:(CGFloat)rightBtnWidth {

    if (self = [super initWithFrame:frame delegate:delegate channelCates:channelCates rightBtnWidth:rightBtnWidth]) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.titleItemFont = kFontWithSize(11);
        self.itemScale = 0.1;
        self.underLineImage = [UIImage new];
        self.itemWidth = 60;
    }
    
    return self;
}





@end
