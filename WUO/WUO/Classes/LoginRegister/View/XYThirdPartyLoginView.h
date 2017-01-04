//
//  XYThirdPartyLoginView.h
//  WUO
//
//  Created by mofeini on 17/1/2.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, XYThirdPartyLoginType) {
    
    XYThirdPartyLoginTypeWeChat = 1,
    XYThirdPartyLoginTypeQQ,
    XYThirdPartyLoginTypeSina
    
};

@interface XYThirdPartyLoginView : UIView

@property (nonatomic, copy) void (^thirdPartyLoginBlock)(XYThirdPartyLoginType type);

@end
