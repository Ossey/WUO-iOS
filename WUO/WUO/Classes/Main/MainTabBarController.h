//
//  MainTabBarController.h
//  WUO
//
//  Created by mofeini on 17/1/1.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>

@interface MainTabBarController : UITabBarController
{
    EMConnectionState _connectionState;
}
//- (void)setupUntreatedApplyCount;

//- (void)setupUnreadMessageCount;
//
//- (void)networkChanged:(EMConnectionState)connectionState;

@end
