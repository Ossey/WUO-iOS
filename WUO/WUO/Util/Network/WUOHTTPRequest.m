//
//  WUOHTTPRequest.m
//  WUO
//
//  Created by mofeini on 17/1/2.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

#import "WUOHTTPRequest.h"
#import "XYLoginInfo.h"
#import "AppDelegate.h"

//#import <AFNetworkActivityIndicatorManager.h>

@implementation WUOHTTPRequest

static id _instance;

+ (instancetype)shareInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    
    return _instance;
}

+ (void)setActivityIndicator:(BOOL)enabled {
    
//    [AFNetworkActivityIndicatorManager sharedManager].enabled = enabled;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = enabled;
}

// 登录接口: 此接口为用户通过app自身账号和密码登录
+ (void)loginWithAccount:(NSString *)account pwd:(NSString *)pwd finished:(FinishedCallBack)finishedCallBack {
    
    // 登录接口
    NSString *urlStr = @"http://me.api.kfit.com.cn/me-api/rest/api/userInfo/login";
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@"123" forKey:@"deviceToken"];
    [parameters setValue:account forKey:@"loginAccount"];
    [parameters setValue:@"iOS" forKey:@"os"];
    [parameters setValue:@"4.2.2" forKey:@"osVersion"];
    [parameters setValue:@"iPhone 6 (A1549/A1586)" forKey:@"phoneModel"];
    // 密码采用md5加密，未加盐
    NSString *pwdMD5 = [pwd MD5].uppercaseString;
    [parameters setValue:pwdMD5 forKey:@"pwd"];
    [parameters setValue:@"1.73" forKey:@"versionCode"];
    
    [[XYNetworkRequest shareInstance] request:XYNetworkRequestTypePOST url:urlStr parameters:parameters progress:nil finished:finishedCallBack];
    
}

// 第三方平台登录接口: 此接口为用户授权第三方信息成功后，会再给服务器发送一个请求，返回登录的信息
+ (void)loginByOpenPlatformDeviceToken:(NSString *)deviceToken head:(NSString *)head name:(NSString *)name openPlatform:(NSString *)openPlatform openPlatformId:(NSString *)openPlatformId osVersion:(NSString *)osVersion phoneModel:(NSString *)phoneModel finished:(FinishedCallBack)finishedCallBack {
//URL	http://me.api.kfit.com.cn/me-api/rest/api/userInfo/loginByOpenPlatform
    // deviceToken=1d5fab615224efa398414edaf08ce4a143fc37fb16e9d63eb2c889d28a430da7&
    // head=http%3A//q.qlogo.cn/qqapp/1105284118/94262324467C0AFD63A71AD292C5C470/100&
    // name=sey.00&
    // openPlatform=QQ&
    // openPlatformId=94262324467C0AFD63A71AD292C5C470&
    // os=iOS&
    // osVersion=4.2.2&
    // phoneModel=iPhone&
    // versionCode=1.7.7
    
    NSString *urlStr = @"http://me.api.kfit.com.cn/me-api/rest/api/userInfo/loginByOpenPlatform";
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    [parameters setObject:deviceToken forKey:@"deviceToken"];
    [parameters setObject:head forKey:@"head"];
    [parameters setObject:name forKey:@"name"];
    [parameters setObject:openPlatform forKey:@"openPlatform"];
    [parameters setObject:openPlatformId forKey:@"openPlatformId"];
    [parameters setObject:phoneModel forKey:@"phoneModel"];
    [parameters setObject:osVersion forKey:@"osVersion"];
    [parameters setObject:@"1.7.7" forKey:@"versionCode"];
    [parameters setObject:@"iOS" forKey:@"os"];
    [[XYNetworkRequest shareInstance] request:XYNetworkRequestTypePOST url:urlStr parameters:parameters progress:nil finished:finishedCallBack];
}

// 获取帖子 接口
+ (void)topicWithIdstamp:(NSString *)idstamp type:(NSInteger)type serachLabel:(NSString *)serachLabel finished:(FinishedCallBack)finishedCallBack {
    
    XYLoginInfo *loginInfoItem = [WUOHTTPRequest userLoginInfoItem];
    // 设置请求头部
    [[XYNetworkRequest shareInstance].manager.requestSerializer setValue:[NSString stringWithFormat:@"%ld", loginInfoItem.userInfo.uid] forHTTPHeaderField:@"uid"];
    [[XYNetworkRequest shareInstance].manager.requestSerializer setValue:loginInfoItem.userInfo.token forHTTPHeaderField:@"token"];
    
    NSString *urlStr = @"http://me.api.kfit.com.cn/me-api/rest/api/trend/getAll";
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:idstamp forKey:@"idstamp"];
    [parameters setValue:@15 forKey:@"pageNum"];
    [parameters setValue:@(type) forKey:@"type"];
    [parameters setValue:serachLabel forKey:@"serachLabel"];
    
    [[XYNetworkRequest shareInstance] request:XYNetworkRequestTypePOST url:urlStr parameters:parameters progress:nil finished:finishedCallBack];
}



// 广告接口
+ (void)find_advertWithFinishedCallBack:(FinishedCallBack)finishedCallBack {
    
    NSString *urlStr = @"http://me.api.kfit.com.cn/me-api/rest/api/base/advert";
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@"found" forKey:@"type"];
    [[XYNetworkRequest shareInstance] request:XYNetworkRequestTypePOST url:urlStr parameters:parameters progress:nil finished:finishedCallBack];
}

// 发现界面 分类标题接口
+ (void)find_hotTrendLabelWithFinishedCallBack:(FinishedCallBack)finishedCallBack {
    
    XYLoginInfo *loginInfoItem = [WUOHTTPRequest userLoginInfoItem];
    NSString *urlStr = @"http://me.api.kfit.com.cn/me-api/rest/api/label/getHotTrendLabel";
    [[XYNetworkRequest shareInstance].manager.requestSerializer setValue:[NSString stringWithFormat:@"%ld", loginInfoItem.userInfo.uid] forHTTPHeaderField:@"uid"];
    [[XYNetworkRequest shareInstance].manager.requestSerializer setValue:loginInfoItem.userInfo.token forHTTPHeaderField:@"token"];
    
    [[XYNetworkRequest shareInstance] request:XYNetworkRequestTypePOST url:urlStr parameters:nil progress:nil finished:finishedCallBack];
}

// 发现界面 -- 活动话题接口
+ (void)find_allTopicWithFinishedCallBack:(FinishedCallBack)finishedCallBack  {
    
    XYLoginInfo *info = [WUOHTTPRequest userLoginInfoItem];

    [[XYNetworkRequest shareInstance].manager.requestSerializer setValue:[NSString stringWithFormat:@"%ld", info.userInfo.uid] forHTTPHeaderField:@"uid"];
    [[XYNetworkRequest shareInstance].manager.requestSerializer setValue:info.userInfo.token forHTTPHeaderField:@"token"];
    
    NSString *urlStrl = @"http://me.api.kfit.com.cn/me-api/rest/api/topic/getAll";
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    [parameters setValue:@"" forKey:@"idstamp"];
    [parameters setValue:@"" forKey:@"keyWords"];
    [parameters setValue:@20 forKey:@"pageNum"];
    [parameters setValue:@1 forKey:@"type"];
    [[XYNetworkRequest shareInstance] request:XYNetworkRequestTypePOST url:urlStrl parameters:parameters progress:nil finished:finishedCallBack];
}

// 话题详情 接口 第一次进入话题详情界面时，请求这个数据，以后每次都请求下面的话题数据接口
+ (void)find_topicDetailByID:(NSInteger)topicID finishedCallBack:(FinishedCallBack)finishedCallBack {
    
    XYLoginInfo *info = [WUOHTTPRequest userLoginInfoItem];
    
    [[XYNetworkRequest shareInstance].manager.requestSerializer setValue:[NSString stringWithFormat:@"%ld", info.userInfo.uid] forHTTPHeaderField:@"uid"];
    [[XYNetworkRequest shareInstance].manager.requestSerializer setValue:info.userInfo.token forHTTPHeaderField:@"token"];
    
    NSString *urlStr = @"http://me.api.kfit.com.cn/me-api/rest/api/topic/getTopicById";
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    [parameters setValue:@(topicID) forKey:@"topicId"];
    [[XYNetworkRequest shareInstance] request:XYNetworkRequestTypePOST url:urlStr parameters:parameters progress:nil finished:finishedCallBack];
}


// 发现界面 -- 话题详情topic 接口  type为1时请求最新数据，type为0时请求排行榜数据
+ (void)find_getTrendByTopicId:(NSInteger)topicID idstamp:(NSString *)idstamp type:(NSInteger)type finishedCallBack:(FinishedCallBack)finishedCallBack {
    XYLoginInfo *info = [WUOHTTPRequest userLoginInfoItem];
    
    [[XYNetworkRequest shareInstance].manager.requestSerializer setValue:[NSString stringWithFormat:@"%ld", info.userInfo.uid] forHTTPHeaderField:@"uid"];
    [[XYNetworkRequest shareInstance].manager.requestSerializer setValue:info.userInfo.token forHTTPHeaderField:@"token"];

    NSString *urlStr = @"http://me.api.kfit.com.cn/me-api/rest/api/topic/getTrendByTopicId";
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    [parameters setValue:@(topicID) forKey:@"topicId"];
    [parameters setValue:idstamp forKey:@"idstamp"];
    [parameters setValue:@(type) forKey:@"type"];
    [[XYNetworkRequest shareInstance] request:XYNetworkRequestTypePOST url:urlStr parameters:parameters progress:nil finished:finishedCallBack];
}

// 用户详情页--获取用户的主页及用户信息的 只需要获取一次即可
+ (void)userDetail_getUserInfoWithtargetUid:(NSInteger)targetUid finishedCallBack:(FinishedCallBack)finishedCallBack {
    
    XYLoginInfo *info = [WUOHTTPRequest userLoginInfoItem];
    [[XYNetworkRequest shareInstance].manager.requestSerializer setValue:[NSString stringWithFormat:@"%ld", info.userInfo.uid] forHTTPHeaderField:@"uid"];
    [[XYNetworkRequest shareInstance].manager.requestSerializer setValue:info.userInfo.token forHTTPHeaderField:@"token"];
    
    NSString *urlStr = @"http://me.api.kfit.com.cn/me-api/rest/api/userInfo/getUserInfo";
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:1];
    [parameters setValue:@(targetUid) forKey:@"targetUid"];
    [[XYNetworkRequest shareInstance] request:XYNetworkRequestTypePOST url:urlStr parameters:parameters progress:nil finished:finishedCallBack];
}

// 用户详情界面
// 请求用户发布的作品的
// URL	http://me.api.kfit.com.cn/me-api/rest/api/trend/getAllTrendById
// idstamp=&pageNum=15&toUid=2579
+ (void)userDetail_getUserTopicByUid:(NSInteger)uid idstamp:(NSString *)idstamp finishedCallBack:(FinishedCallBack)finishedCallBack {
    
    XYLoginInfo *info = [WUOHTTPRequest userLoginInfoItem];
    [[XYNetworkRequest shareInstance].manager.requestSerializer setValue:[NSString stringWithFormat:@"%ld", info.userInfo.uid] forHTTPHeaderField:@"uid"];
    [[XYNetworkRequest shareInstance].manager.requestSerializer setValue:info.userInfo.token forHTTPHeaderField:@"token"];
    
    NSString *urlStr = @"http://me.api.kfit.com.cn/me-api/rest/api/trend/getAllTrendById";
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:3];
    [parameters setValue:@(uid) forKey:@"toUid"];
    [parameters setValue:idstamp forKey:@"idstamp"];
    [parameters setValue:@15 forKey:@"pageNum"];
    [[XYNetworkRequest shareInstance] request:XYNetworkRequestTypePOST url:urlStr parameters:parameters progress:nil finished:finishedCallBack];
}

// 用户相册
// URL	http://me.api.kfit.com.cn/me-api/rest/api/me/myAlbum
// page=2&pageNum=15&targetUid=2579
// page 是指请求的页数
+ (void)userDetail_getUserAlbumWithPage:(NSInteger)page targetUid:(NSInteger)targetUid finishedCallBack:(FinishedCallBack)finishedCallBack {
    
    XYLoginInfo *info = [WUOHTTPRequest userLoginInfoItem];
    [[XYNetworkRequest shareInstance].manager.requestSerializer setValue:[NSString stringWithFormat:@"%ld", info.userInfo.uid] forHTTPHeaderField:@"uid"];
    [[XYNetworkRequest shareInstance].manager.requestSerializer setValue:info.userInfo.token forHTTPHeaderField:@"token"];
    
    NSString *urlStr = @"http://me.api.kfit.com.cn/me-api/rest/api/me/myAlbum";
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:3];
    [parameters setValue:@(page) forKey:@"page"];
    [parameters setValue:@(targetUid) forKey:@"targetUid"];
    [parameters  setValue:@15 forKey:@"pageNum"];
    [[XYNetworkRequest shareInstance] request:XYNetworkRequestTypePOST url:urlStr parameters:parameters progress:nil finished:finishedCallBack];

}

// 获取用户登录的信息，并转换为模型
+ (XYLoginInfo *)userLoginInfoItem {
    
    NSDictionary *loginInfoDict = [NSDictionary dictionaryWithContentsOfFile:kLoginInfoPath];
    
    return [XYLoginInfo loginInfoItemWithDict:loginInfoDict];
}

// 每次请求网络时，检测登录状态，如果发现已经在其他地方登录，当前账户就要强制退出，并提醒用户
+ (void)checkLoginStatusFromResponseCode:(NSInteger)code {

    if (code == -2) {
        
        [self showInfo:[NSString stringWithFormat:@"您的账号已于%@在其他设备上登录，如果不是您的操作，您的密码可能已经泄露，请立刻重新登录后修改密码", @"(刚刚)"]];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 用户没有登录
            AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            delegate.isLogin = NO;
            
            // 主动退出登录：调用 SDK 的退出接口；
            EMError *error = [[EMClient sharedClient] logout:YES];
            if (!error) {
                NSLog(@"您的账号退出成功");
            }
            
        });
        
        [[NSUserDefaults standardUserDefaults] setObject:@(code) forKey:XYUserLoginStatuKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }

}
@end
