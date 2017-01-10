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



/// 重写父类的方法
//- (void)contentViewDidScroll:(UIScrollView *)scrollView {
//    
//    [super contentViewDidScroll:scrollView];
//    
//    // scrollView滚动的时候调用,让字体跟随滚动渐变缩放
//    NSInteger leftI = scrollView.contentOffset.x / CGRectGetWidth(scrollView.frame);
//    NSInteger rightI = leftI + 1;
//    
////    NSLog(@"%@--%ld---%p", self.class, self.items.count, self.items);
//    
//    // 取出缩放的两个按钮
//    // 取出左边按钮
//    UIButton *leftBtn = self.items[leftI];
//    
//    // 取出右边的按钮
//    UIButton *rightBtn;
//    // 容错处理，防止数组越界
//    if (rightI < self.items.count) {
//        
//        rightBtn = self.items[rightI];
//    }
//    
//    // 缩放按钮
//    // 计算需要缩放的比例
//    CGFloat scaleR = scrollView.contentOffset.x / CGRectGetWidth(scrollView.frame); // 放大
//    scaleR -= leftI;
//    CGFloat scaleL = 1 - scaleR; // 缩小，与放大取反即可
//    
//    // 让按钮的缩放范围在1 ~ 1.3的范围，如果不设置按钮的缩放范围在0 ~ 1
//    rightBtn.transform = CGAffineTransformMakeScale(scaleR * self.itemScale + 1, scaleR * self.itemScale + 1);
//    leftBtn.transform = CGAffineTransformMakeScale(scaleL * self.itemScale + 1, scaleL * self.itemScale + 1);
////    NSLog(@"%f--%f", scaleL, scaleR);
//    // 标题按钮文字颜色渐变
////    UIColor *leftColor = [UIColor colorWithRed:0.0f green:scaleL blue:0.0f alpha:1.0f];
////    UIColor *rightColor = [UIColor colorWithRed:0.0f green:scaleR blue:0.0f alpha:1.0f];
////    [leftBtn setTitleColor:leftColor forState:UIControlStateNormal];
////    [rightBtn setTitleColor:rightColor forState:UIControlStateNormal];
//}
//
//- (void)contentViewDidScrollDidEndDecelerating:(UIScrollView *)scrollView {
//    
//    [super contentViewDidScrollDidEndDecelerating:scrollView];
// 
//}


@end
