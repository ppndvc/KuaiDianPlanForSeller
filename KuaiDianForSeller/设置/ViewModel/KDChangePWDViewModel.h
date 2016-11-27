//
//  KDChangePWDViewModel.h
//  KuaiDianForSeller
//
//  Created by ppnd on 16/8/22.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDBaseViewModel.h"


@interface KDChangePWDViewModel : KDBaseViewModel
//开始获取验证码请求，带有开始和结束回调
-(void)getCodeWithParams:(NSDictionary *)params beginBlock:(KDViewModelBeginCallBackBlock)beginBlock completeBlock:(KDViewModelCompleteCallBackBlock)completeBlock;

//开始校验验证码请求，带有开始和结束回调
-(void)startVerifyCodeWithParams:(NSDictionary *)params beginBlock:(KDViewModelBeginCallBackBlock)beginBlock completeBlock:(KDViewModelCompleteCallBackBlock)completeBlock;

//设置定时回调
-(void)setTimerHandleBlock:(KDViewModelTimerHandleBlock)block;

//设置定时结束回调
-(void)setTimerFinishedHandleBlock:(KDViewModelTimerFinishedHandleBlock)block;

//开启定时器
-(void)startTimer;

//结束定时器
-(void)stopTimer;

//是否正确验证码
-(BOOL)checkVerifyCode:(NSString *)code;

@end
