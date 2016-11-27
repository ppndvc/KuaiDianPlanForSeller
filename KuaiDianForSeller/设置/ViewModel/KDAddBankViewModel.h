//
//  KDAddBankViewModel.h
//  KuaiDianForSeller
//
//  Created by ppnd on 16/11/8.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDBaseViewModel.h"

@interface KDAddBankViewModel : KDBaseViewModel

//开始获取验证码请求，带有开始和结束回调
-(void)getCodeWithParams:(NSDictionary *)params beginBlock:(KDViewModelBeginCallBackBlock)beginBlock completeBlock:(KDViewModelCompleteCallBackBlock)completeBlock;

//开始添加银行卡请求，带有开始和结束回调
-(void)addBankCardWithParams:(NSDictionary *)params beginBlock:(KDViewModelBeginCallBackBlock)beginBlock completeBlock:(KDViewModelCompleteCallBackBlock)completeBlock;

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
