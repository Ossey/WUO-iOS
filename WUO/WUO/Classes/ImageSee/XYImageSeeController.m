//
//  XYImageSeeController.m
//  WUO
//
//  Created by mofeini on 17/1/5.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

#import "XYImageSeeController.h"

@interface XYImageSeeController ()

@end

@implementation XYImageSeeController

- (instancetype)initWithImgItems:(NSArray<XYDynamicImgItem *> *)imgItems indexPath:(NSIndexPath *)indexPath {
    
    if (self = [super init]) {
        _imgItems = imgItems;
        _indexPath = indexPath;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
