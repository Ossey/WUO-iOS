//
//  XYUserDetailController.m
//  WUO
//
//  Created by mofeini on 17/1/11.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

#import "XYUserDetailController.h"
#import "XYUserDetailTableView.h"
#import "WUOHTTPRequest.h"

@interface XYUserDetailController ()

@end

@implementation XYUserDetailController {
    XYUserDetailTableView *_tableView;
}

- (instancetype)initWithTargetUid:(NSInteger)uid {
    if (self = [super init]) {
        self.uid = uid;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    // 获取用户的主页及用户信息的 只需要获取一次即可
    // userInfo URL	http://me.api.kfit.com.cn/me-api/rest/api/userInfo/getUserInfo
    // targetUid=2579
    
    // 请求用户发布的作品的
    // URL	http://me.api.kfit.com.cn/me-api/rest/api/trend/getAllTrendById
    // idstamp=&pageNum=15&toUid=2579
  
    _tableView = [[XYUserDetailTableView alloc] init];
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [WUOHTTPRequest userDetail_getUserInfoWithtargetUid:self.uid finishedCallBack:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"%@", error.localizedDescription);
            [self xy_showMessage:@"网络请求失败"];
            return;
        }
        
        NSLog(@"%@", responseObject);
    }];
}



@end
