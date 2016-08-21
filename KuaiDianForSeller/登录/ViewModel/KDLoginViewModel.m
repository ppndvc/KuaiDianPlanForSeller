//
//  KDLoginVIewModel.m
//  KuaiDianForSeller
//
//  Created by ppnd on 16/8/13.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDLoginViewModel.h"
#import "KDRequestAPI.h"
#import "KDUserManager.h"

@implementation KDLoginViewModel

-(void)startLoginWithParams:(NSDictionary *)params beginBlock:(KDViewModelBeginCallBackBlock)beginBlock completeBlock:(KDViewModelCompleteCallBackBlock)completeBlock
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
        
        [KDRequestAPI sendLoginRequestWithParam:params completeBlock:^(id responseObject, NSError *error) {
            
            if (error)
            {
                if (completeBlock)
                {
                    completeBlock(NO,nil,error);
                }
                
                DDLogInfo(@"登陆请求失败：%@",error.localizedDescription);
            }
            else
            {
                if (responseObject)
                {
                    NSDictionary *dict = [responseObject objectForKey:RESPONSE_PAYLOAD];
                    if (dict && [dict isKindOfClass:[NSDictionary class]])
                    {
                        KDUserModel *model = [KDUserModel yy_modelWithDictionary:dict];
                        if (model)
                        {
                            [[KDUserManager sharedInstance] updateUserInfo:model];
                            if (completeBlock)
                            {
                                completeBlock(YES,model,nil);
                            }
                            
                            return;
                        }
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
@end
