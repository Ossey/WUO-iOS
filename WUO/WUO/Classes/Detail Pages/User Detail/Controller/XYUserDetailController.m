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
#import "XYUserInfo.h"
#import "XYTopicViewModel.h"

@interface XYUserDetailController ()
@property (nonatomic, strong) XYUserInfo *userInfo;
@end

@implementation XYUserDetailController {
    XYUserDetailTableView *_tableView;
    
}

- (instancetype)initWithItem:(XYTopicItem *)item {
    if (self = [super init]) {
        self.item = item;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = self.item.name;
    
    [self loadUserInfo];
    
    // 请求用户发布的作品的
    // URL	http://me.api.kfit.com.cn/me-api/rest/api/trend/getAllTrendById
    // idstamp=&pageNum=15&toUid=2579
  
    _tableView = [[XYUserDetailTableView alloc] init];
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    }

- (void)loadUserInfo {
    
    [WUOHTTPRequest setActivityIndicator:YES];
    
    [WUOHTTPRequest userDetail_getUserInfoWithtargetUid:self.item.uid finishedCallBack:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"%@", error.localizedDescription);
            [self xy_showMessage:@"网络请求失败"];
            [WUOHTTPRequest setActivityIndicator:NO];
            return;
        }
        
        if ([responseObject[@"code"] integerValue] == 0) {
            XYHTTPResponseInfo *info = [XYHTTPResponseInfo responseInfoWithDict:responseObject];
            if (responseObject[@"userInfo"] && [responseObject[@"userInfo"] isKindOfClass:[NSDictionary class]]) {
                self.userInfo = [XYUserInfo userInfoWithDict:responseObject[@"userInfo"] responseInfo:info];
            }
        }
        
        [WUOHTTPRequest setActivityIndicator:NO];
        
    }];

}

- (void)setUserInfo:(XYUserInfo *)userInfo {
    _userInfo = userInfo;
    _tableView.userInfo = userInfo;
}

@end
