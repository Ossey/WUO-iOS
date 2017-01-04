//
//  XYLoginRegisterController.h
//  WUO
//
//  Created by mofeini on 17/1/2.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

#import "XYProfileBaseController.h"

typedef NS_ENUM(NSInteger, XYLoginRegisterType) {
    
    XYLoginRegisterTypeRegister = 1,
    XYLoginRegisterTypeLogin
};

@interface XYLoginRegisterController : XYProfileBaseController

- (instancetype)initWithType:(XYLoginRegisterType)type;

@end
