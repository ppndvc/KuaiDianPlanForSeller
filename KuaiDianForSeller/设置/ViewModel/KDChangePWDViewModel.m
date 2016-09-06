//
//  KDChangePWDViewModel.m
//  KuaiDianForSeller
//
//  Created by ppnd on 16/8/22.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDChangePWDViewModel.h"

@implementation KDChangePWDViewModel
-(void)getCodeWithParams:(NSDictionary *)params beginBlock:(KDViewModelBeginCallBackBlock)beginBlock completeBlock:(KDViewModelCompleteCallBackBlock)completeBlock
{
    if (params && [params isKindOfClass:[NSDictionary class]])
    {
        if ([NSThread isMainThread])
        {
            if (beginBlock)
            {
                beginBlock();
            }
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (beginBlock)
                {
                    beginBlock();
                }
            });
        }
        
        [KDRequestAPI sendGetVerifyCodeRequestWithParam:params completeBlock:^(id responseObject, NSError *error) {
            
            if (error)
            {
                if (completeBlock)
                {
                    completeBlock(NO,nil,error);
                }
                
                DDLogInfo(@"获取验证码请求失败：%@",error.localizedDescription);
            }
            else
            {
                if (responseObject)
                {
                    NSDictionary *dict = [responseObject objectForKey:RESPONSE_PAYLOAD];
                    if (dict && [dict isKindOfClass:[NSDictionary class]])
                    {
                        if (completeBlock)
                        {
                            completeBlock(YES,dict,nil);
                        }
                        return ;
                    }
                }
                
                if (completeBlock)
                {
                    NSString *message = @"服务端返回为空";
                    NSString *errotReason = @"服务端返回错误";
                    NSDictionary *userInfo = @{
                                               NSLocalizedDescriptionKey:message,
                                               NSLocalizedFailureReasonErrorKey: errotReason,
                                               };
                    NSError *finalError = [NSError errorWithDomain:KDErrorDomain code:kCFURLErrorCancelled userInfo:userInfo];
                    completeBlock(NO,nil,finalError);
                }
            }
        }];
    }
}

-(void)startVerifyCodeWithParams:(NSDictionary *)params beginBlock:(KDViewModelBeginCallBackBlock)beginBlock completeBlock:(KDViewModelCompleteCallBackBlock)completeBlock
{
    if ([NSThread isMainThread])
    {
        if (beginBlock)
        {
            beginBlock();
        }
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (beginBlock)
            {
                beginBlock();
            }
        });
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (completeBlock)
        {
            completeBlock(YES,nil,nil);
        }
    });
}

@end
