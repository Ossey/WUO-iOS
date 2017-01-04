//
//  XYImageSeeController.h
//  WUO
//
//  Created by mofeini on 17/1/5.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XYDynamicImgItem;
@interface XYImageSeeController : UIViewController {
    
    NSArray<XYDynamicImgItem *> *_imgItems;
    NSIndexPath *_indexPath;
}


- (instancetype)initWithImgItems:(NSArray<XYDynamicImgItem *> *)imgItems indexPath:(NSIndexPath *)indexPath;

@end
