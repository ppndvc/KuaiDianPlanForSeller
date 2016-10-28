//
//  HXRequestAPI.h
//  netAccessDemo
//
//  Created by ppnd on 16/3/10.
//  Copyright © 2016年 ppnd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KDRequest.h"

@interface KDRequestAPI : NSObject
//登陆请求
+(void)sendLoginRequestWithParam:(NSDictionary *)param completeBlock:(KDRequestCompletionBlock)completeBlock;
//注销请求
+(void)sendLogoutRequestWithCompleteBlock:(KDRequestCompletionBlock)completeBlock;
//获取餐厅信息请求
+(void)sendGetShopInfoRequestWithParam:(NSDictionary *)param completeBlock:(KDRequestCompletionBlock)completeBlock;
//获取个人信息请求
+(void)sendGetUserInfoRequestWithCompleteBlock:(KDRequestCompletionBlock)completeBlock;
//查询订单
+(void)sendGetOrderRequestWithParam:(NSDictionary *)param completeBlock:(KDRequestCompletionBlock)completeBlock;
//查询订单（模糊查询）
+(void)sendGetBlurOrderRequestWithParam:(NSDictionary *)param completeBlock:(KDRequestCompletionBlock)completeBlock;
//获取验证码请求
+(void)sendGetVerifyCodeRequestWithParam:(NSDictionary *)param completeBlock:(KDRequestCompletionBlock)completeBlock;
//修改订单状态请求
+(void)sendModifyOrderStatusRequestWithParam:(NSDictionary *)param completeBlock:(KDRequestCompletionBlock)completeBlock;
//修改用户信息请求
+(void)sendModifyUserInfoRequestWithParam:(NSDictionary *)param completeBlock:(KDRequestCompletionBlock)completeBlock;
//获取食品分类请求
+(void)sendGetFoodCategoryInfoRequestWithParam:(NSDictionary *)param completeBlock:(KDRequestCompletionBlock)completeBlock;
//获取食品列表请求
+(void)sendGetFoodListInfoRequestWithParam:(NSString *)param completeBlock:(KDRequestCompletionBlock)completeBlock;
//添加食品分类
+(void)sendAddFoodCateRequestWithParam:(NSDictionary *)param completeBlock:(KDRequestCompletionBlock)completeBlock;
//修改食品分类名字
+(void)sendModifyFoodCateTitleWithParam:(NSDictionary *)param completeBlock:(KDRequestCompletionBlock)completeBlock;
//添加食品项请求
+(void)sendAddFoodItemWithParam:(NSDictionary *)param completeBlock:(KDRequestCompletionBlock)completeBlock;
//更新食品请求
+(void)sendUpdateFoodItemWithParam:(NSDictionary *)param completeBlock:(KDRequestCompletionBlock)completeBlock;
//删除食品请求
+(void)sendDeleteFoodItemWithParam:(NSDictionary *)param completeBlock:(KDRequestCompletionBlock)completeBlock;
//上传食品logo请求
+(void)sendUploadFileWithParam:(NSDictionary *)param fileData:(NSData *)fileData fileName:(NSString *)fileName progressBlock:(KDRequestProgressBlock)progressBlock completeBlock:(KDRequestCompletionBlock)completeBlock;

@end
