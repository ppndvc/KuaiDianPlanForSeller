//
//  HXRequestAPI.m
//  netAccessDemo
//
//  Created by ppnd on 16/3/10.
//  Copyright © 2016年 ppnd. All rights reserved.
//

#import "KDRequestAPI.h"
#import "KDNetworkManager.h"
#import "KDEnvironmentManager.h"
#import "KDUserManager.h"

@implementation KDRequestAPI
+(void)sendLoginRequestWithParam:(NSDictionary *)param completeBlock:(KDRequestCompletionBlock)completeBlock
{
    DDLogInfo(@"==== 发送 登陆请求 ====");
    DDLogInfo(@"==== 请求参数：%@ ====",param);
    KDRequest *request = [KDRequest requestWithRelativeURL:[[KDEnvironmentManager sharedInstance] getRequetPathForKey:LOGIN_REQUEST_PATH] parameters:param method:KDRequestMethodPost requestComplete:completeBlock];
    [[KDNetworkManager sharedManager] sendRequest:request];
}
+(void)sendLogoutRequestWithCompleteBlock:(KDRequestCompletionBlock)completeBlock
{
    DDLogInfo(@"==== 发送 注销请求 ====");
    KDRequest *request = [KDRequest requestWithRelativeURL:[[KDEnvironmentManager sharedInstance] getRequetPathForKey:LOGOUT_REQUEST_PATH] parameters:nil method:KDRequestMethodPost requestComplete:completeBlock];
    [[KDNetworkManager sharedManager] sendRequest:request];
}
+(void)sendGetUserInfoRequestWithCompleteBlock:(KDRequestCompletionBlock)completeBlock
{
    DDLogInfo(@"==== 发送 获取用户信息请求 ====");
    KDRequest *request = [KDRequest requestWithRelativeURL:[[KDEnvironmentManager sharedInstance] getRequetPathForKey:GET_USERINFO_REQUEST_PATH] parameters:nil method:KDRequestMethodPost requestComplete:completeBlock];
    [[KDNetworkManager sharedManager] sendRequest:request];
}

+(void)sendGetOrderRequestWithParam:(NSDictionary *)param completeBlock:(KDRequestCompletionBlock)completeBlock
{
    DDLogInfo(@"==== 发送 获取订单请求 ====");
    DDLogInfo(@"==== 请求参数：%@ ====",param);
    
    //需要在relativeurl后面追加用户的id（后台的rest风格）
    NSString *userID = [[[KDUserManager sharedInstance] getUserInfo] identifier];
    NSString *requestURL = [NSString stringWithFormat:@"%@/%@",[[KDEnvironmentManager sharedInstance] getRequetPathForKey:GET_ORDER_REQUEST_PATH],userID];
    
    KDRequest *request = [KDRequest requestWithRelativeURL:requestURL parameters:param method:KDRequestMethodPost requestComplete:completeBlock];
    [[KDNetworkManager sharedManager] sendRequest:request];
}
+(void)sendGetBlurOrderRequestWithParam:(NSDictionary *)param completeBlock:(KDRequestCompletionBlock)completeBlock
{
    DDLogInfo(@"==== 发送 获取订单请求（模糊查询） ====");
    DDLogInfo(@"==== 请求参数：%@ ====",param);
    KDRequest *request = [KDRequest requestWithRelativeURL:[[KDEnvironmentManager sharedInstance] getRequetPathForKey:GET_ORDER_LIKE_REQUEST_PATH] parameters:param method:KDRequestMethodPost requestComplete:completeBlock];
    [[KDNetworkManager sharedManager] sendRequest:request];
}
+(void)sendGetVerifyCodeRequestWithParam:(NSDictionary *)param completeBlock:(KDRequestCompletionBlock)completeBlock
{
    DDLogInfo(@"==== 发送 获取验证码请求 ====");
    DDLogInfo(@"==== 请求参数：%@ ====",param);
    KDRequest *request = [KDRequest requestWithRelativeURL:[[KDEnvironmentManager sharedInstance] getRequetPathForKey:GET_VERIFY_CODE_REQUEST_PATH] parameters:param method:KDRequestMethodPost requestComplete:completeBlock];
    [[KDNetworkManager sharedManager] sendRequest:request];
}
+(void)sendModifyOrderStatusRequestWithParam:(NSDictionary *)param completeBlock:(KDRequestCompletionBlock)completeBlock
{
    DDLogInfo(@"==== 发送 修改订单状态请求 ====");
    DDLogInfo(@"==== 请求参数：%@ ====",param);
    KDRequest *request = [KDRequest requestWithRelativeURL:[[KDEnvironmentManager sharedInstance] getRequetPathForKey:MODIFY_ORDER_STATUS_REQUEST_PATH] parameters:param method:KDRequestMethodPost requestComplete:completeBlock];
    [[KDNetworkManager sharedManager] sendRequest:request];
}
+(void)sendModifyUserInfoRequestWithParam:(NSDictionary *)param completeBlock:(KDRequestCompletionBlock)completeBlock
{
    DDLogInfo(@"==== 发送 修改用户信息请求 ====");
    DDLogInfo(@"==== 请求参数：%@ ====",param);
    KDRequest *request = [KDRequest requestWithRelativeURL:[[KDEnvironmentManager sharedInstance] getRequetPathForKey:MODIFY_ORDER_STATUS_REQUEST_PATH] parameters:param method:KDRequestMethodPost requestComplete:completeBlock];
    [[KDNetworkManager sharedManager] sendRequest:request];
}
@end
