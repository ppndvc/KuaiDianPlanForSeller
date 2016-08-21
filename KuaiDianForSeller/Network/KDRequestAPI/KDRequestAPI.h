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
//获取个人信息请求
+(void)sendGetUserInfoRequestWithCompleteBlock:(KDRequestCompletionBlock)completeBlock;
//查询订单
+(void)sendGetOrderRequestWithParam:(NSDictionary *)param completeBlock:(KDRequestCompletionBlock)completeBlock;
//查询订单（模糊查询）
+(void)sendGetBlurOrderRequestWithParam:(NSDictionary *)param completeBlock:(KDRequestCompletionBlock)completeBlock;
@end
