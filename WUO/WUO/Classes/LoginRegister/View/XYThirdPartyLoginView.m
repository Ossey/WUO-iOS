//
//  XYThirdPartyLoginView.m
//  WUO
//
//  Created by mofeini on 17/1/2.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

#import "XYThirdPartyLoginView.h"


@implementation XYThirdPartyLoginView

+ (instancetype)xy_viewFromXib {
    
    return [[NSBundle mainBundle] loadNibNamed:@"XYLoginRegisterView" owner:nil options:nil][0];
}

- (IBAction)thirdPartyLogin:(UIButton *)sender {
    
    if (self.thirdPartyLoginBlock) {
        self.thirdPartyLoginBlock(sender.tag);
    }
}



@end
