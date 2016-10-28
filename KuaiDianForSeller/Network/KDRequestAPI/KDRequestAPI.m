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
    
    KDRequest *request = [KDRequest requestWithRelativeURL:[[KDEnvironmentManager sharedInstance] getRequetPathForKey:GET_ORDER_REQUEST_PATH] parameters:param method:KDRequestMethodPost requestComplete:completeBlock];
    [[KDNetworkManager sharedManager] sendRequest:request];
}

+(void)sendGetShopInfoRequestWithParam:(NSDictionary *)param completeBlock:(KDRequestCompletionBlock)completeBlock
{
    DDLogInfo(@"==== 发送 获取餐厅信息请求 ====");
    DDLogInfo(@"==== 请求参数：%@ ====",param);
    
    //需要在relativeurl后面追加用户的id（后台的rest风格）
    NSString *shopID = [[[KDUserManager sharedInstance] getUserInfo] shopID];
    NSString *requestURL = [NSString stringWithFormat:@"%@/%@",[[KDEnvironmentManager sharedInstance] getRequetPathForKey:GET_STORE_INFO_REQUEST_PATH],shopID];
    
    KDRequest *request = [KDRequest requestWithRelativeURL:requestURL parameters:param method:KDRequestMethodGet requestComplete:completeBlock];
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
+(void)sendGetFoodCategoryInfoRequestWithParam:(NSDictionary *)param completeBlock:(KDRequestCompletionBlock)completeBlock
{
    DDLogInfo(@"==== 发送 获取视频分类信息请求 ====");
    DDLogInfo(@"==== 请求参数：%@ ====",param);
    
    //需要在relativeurl后面追加用户的id（后台的rest风格）
    NSString *shopID = [[[KDUserManager sharedInstance] getUserInfo] shopID];
    NSString *requestURL = [NSString stringWithFormat:@"%@/%@",[[KDEnvironmentManager sharedInstance] getRequetPathForKey:GET_FOOD_CATEGORY_REQUEST_PATH],shopID];
    
    KDRequest *request = [KDRequest requestWithRelativeURL:requestURL parameters:param method:KDRequestMethodGet requestComplete:completeBlock];
    [[KDNetworkManager sharedManager] sendRequest:request];

}
+(void)sendGetFoodListInfoRequestWithParam:(NSString *)param completeBlock:(KDRequestCompletionBlock)completeBlock
{
    DDLogInfo(@"==== 发送 获取食品列表信息请求 ====");
    DDLogInfo(@"==== 请求参数：%@ ====",param);
    
    //需要在relativeurl后面追加用户的id（后台的rest风格）
    NSString *requestURL = [NSString stringWithFormat:@"%@/%@",[[KDEnvironmentManager sharedInstance] getRequetPathForKey:GET_FOOD_LIST_REQUEST_PATH],param];
    
    KDRequest *request = [KDRequest requestWithRelativeURL:requestURL parameters:nil method:KDRequestMethodPost requestComplete:completeBlock];
    [[KDNetworkManager sharedManager] sendRequest:request];
    
}
+(void)sendAddFoodCateRequestWithParam:(NSDictionary *)param completeBlock:(KDRequestCompletionBlock)completeBlock
{
    DDLogInfo(@"==== 发送 添加食品分类请求 ====");
    DDLogInfo(@"==== 请求参数：%@ ====",param);
    KDRequest *request = [KDRequest requestWithRelativeURL:[[KDEnvironmentManager sharedInstance] getRequetPathForKey:ADD_FOOD_CATE_REQUEST_PATH] parameters:param method:KDRequestMethodPost requestComplete:completeBlock];
    [[KDNetworkManager sharedManager] sendRequest:request];
    
}
+(void)sendModifyFoodCateTitleWithParam:(NSDictionary *)param completeBlock:(KDRequestCompletionBlock)completeBlock
{
    DDLogInfo(@"==== 发送 修改食品分类请求 ====");
    DDLogInfo(@"==== 请求参数：%@ ====",param);
    KDRequest *request = [KDRequest requestWithRelativeURL:[[KDEnvironmentManager sharedInstance] getRequetPathForKey:MODIFY_FOOD_CATE_TITLE_REQUEST_PATH] parameters:param method:KDRequestMethodPost requestComplete:completeBlock];
    [[KDNetworkManager sharedManager] sendRequest:request];
}
+(void)sendAddFoodItemWithParam:(NSDictionary *)param completeBlock:(KDRequestCompletionBlock)completeBlock
{
    DDLogInfo(@"==== 发送 添加食品项请求 ====");
    DDLogInfo(@"==== 请求参数：%@ ====",param);
    KDRequest *request = [KDRequest requestWithRelativeURL:[[KDEnvironmentManager sharedInstance] getRequetPathForKey:ADD_FOOD_ITEM_REQUEST_PATH] parameters:param method:KDRequestMethodPost requestComplete:completeBlock];
    [[KDNetworkManager sharedManager] sendRequest:request];
}
+(void)sendUpdateFoodItemWithParam:(NSDictionary *)param completeBlock:(KDRequestCompletionBlock)completeBlock
{
    DDLogInfo(@"==== 发送 更新食品项请求 ====");
    DDLogInfo(@"==== 请求参数：%@ ====",param);
    KDRequest *request = [KDRequest requestWithRelativeURL:[[KDEnvironmentManager sharedInstance] getRequetPathForKey:UPDATE_FOOD_ITEM_REQUEST_PATH] parameters:param method:KDRequestMethodPost requestComplete:completeBlock];
    [[KDNetworkManager sharedManager] sendRequest:request];
}
+(void)sendDeleteFoodItemWithParam:(NSDictionary *)param completeBlock:(KDRequestCompletionBlock)completeBlock
{
    DDLogInfo(@"==== 发送 删除食品项请求 ====");
    DDLogInfo(@"==== 请求参数：%@ ====",param);
    KDRequest *request = [KDRequest requestWithRelativeURL:[[KDEnvironmentManager sharedInstance] getRequetPathForKey:DELETE_FOOD_ITEM_REQUEST_PATH] parameters:param method:KDRequestMethodPost requestComplete:completeBlock];
    [[KDNetworkManager sharedManager] sendRequest:request];
}

+(void)sendUploadFileWithParam:(NSDictionary *)param fileData:(NSData *)fileData fileName:(NSString *)fileName progressBlock:(KDRequestProgressBlock)progressBlock completeBlock:(KDRequestCompletionBlock)completeBlock
{
    DDLogInfo(@"==== 发送 上传食品logo请求 ====");
    DDLogInfo(@"==== 请求参数：%@ ====",param);
    KDRequest *request = [KDRequest uploadRequestWithRelativeURL:[[KDEnvironmentManager sharedInstance] getRequetPathForKey:UPLODA_FOOD_LOGO_REQUEST_PATH] parameters:param method:KDRequestMethodPost constructBodyBlock:^(id<AFMultipartFormData> formData) {
        
        if (VALIDATE_MODEL(fileData, @"NSData"))
        {
            [formData appendPartWithFileData:fileData name:fileName fileName:fileName mimeType:@"application/file"];
        }
    } progressBlock:progressBlock requestComplete:completeBlock];
    
    [[KDNetworkManager sharedManager] sendRequest:request];
}


@end
