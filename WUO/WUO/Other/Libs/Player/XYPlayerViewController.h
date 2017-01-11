//
//  XYPlayerViewController.h
//  WUO
//
//  Created by mofeini on 17/1/8.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XYPlayerViewController : UIViewController

- (instancetype)initWithVideoURL:(NSURL *)URL;

+ (void)presenteViewControllerWithVideoURL:(NSURL *)URL;



@end
