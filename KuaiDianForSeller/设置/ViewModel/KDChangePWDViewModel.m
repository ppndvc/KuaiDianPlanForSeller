//
//  KDChangePWDViewModel.m
//  KuaiDianForSeller
//
//  Created by ppnd on 16/8/22.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDChangePWDViewModel.h"

#define TIME_INTERVAL 0.5
#define MAX_DURATION 60

@interface KDChangePWDViewModel ()

@property(nonatomic,copy)KDViewModelTimerHandleBlock timerBlock;

@property(nonatomic,copy)KDViewModelTimerFinishedHandleBlock timerFinishedBlock;

@property(nonatomic,copy)NSString *code;

@property(nonatomic,strong)NSTimer *timer;

@property(nonatomic,assign)NSInteger originalStamp;

@end

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
        
        WS(ws);
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
                    NSString *tmpCode = [NSString stringWithFormat:@"%@",[responseObject objectForKey:RESPONSE_PAYLOAD]];
                    if (VALIDATE_STRING(tmpCode))
                    {
                        ws.code = tmpCode;
                        DDLogInfo(@"-code:%@",tmpCode);
                    }
                    
                    if (completeBlock)
                    {
                        completeBlock(YES,nil,nil);
                    }
                    return ;
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

-(void)startTimer
{
    if (!_timer || !_timer.isValid)
    {
        if (_timerBlock)
        {
            _originalStamp = [[NSDate date] timeIntervalSince1970];

            _timer = [NSTimer scheduledTimerWithTimeInterval:TIME_INTERVAL target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
            [_timer fire];
        }
    }
}
-(void)stopTimer
{
    if (_timer && _timer.isValid)
    {
        _originalStamp = 0;
        [_timer invalidate];
        _timer = nil;
    }
}
-(void)onTimer
{
    NSInteger stamp = [[NSDate date] timeIntervalSince1970];
    NSInteger stampOffset = stamp - _originalStamp;
    
    if (stampOffset < MAX_DURATION)
    {
        if (_timerBlock)
        {
            NSString *title = [NSString stringWithFormat:@"%d",(int)(MAX_DURATION - stampOffset)];
            _timerBlock(title);
        }
    }
    else
    {
        [self stopTimer];
        
        if (_timerFinishedBlock)
        {
            _timerFinishedBlock(nil);
        }
    }
}
-(void)setTimerHandleBlock:(KDViewModelTimerHandleBlock)block
{
    if (block)
    {
        _timerBlock = block;
    }
}
-(void)setTimerFinishedHandleBlock:(KDViewModelTimerFinishedHandleBlock)block
{
    if (block)
    {
        _timerFinishedBlock = block;
    }
}
-(BOOL)checkVerifyCode:(NSString *)code
{
    BOOL isValidate = NO;
    if (VALIDATE_STRING(code) && VALIDATE_STRING(_code) && [code isEqualToString:_code])
    {
        isValidate = YES;
    }
    return isValidate;
}
@end
