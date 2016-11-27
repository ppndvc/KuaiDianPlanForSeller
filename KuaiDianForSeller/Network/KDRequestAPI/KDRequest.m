//
//  KDRequest.m
//  netAccessDemo
//
//  Created by ppnd on 16/3/2.
//  Copyright © 2016年 ppnd. All rights reserved.
//

#import "KDRequest.h"
#import "KDEnvironmentManager.h"
#import "KDCacheManager.h"

@implementation KDRequest

//普通请求初始化
+(instancetype)requestWithURL:(NSString *)URL parameters:(NSDictionary *)parameters method:(KDRequestMethod)method requestComplete:(KDRequestCompletionBlock)requestComplete
{
    return [[KDRequest alloc] initRequestWithURL:URL relativeURL:nil parameters:parameters method:method requestType:KDDefaultRequest attachment:nil timeoutInterval:TIMEOUT_INTERVAL constructBodyBlock:nil progressBlock:nil downloadSettingBlock:nil downloadCompleteBlock:nil requestComplete:requestComplete];
}

//普通请求初始化
+(instancetype)requestWithRelativeURL:(NSString *)relativeURL parameters:(NSDictionary *)parameters method:(KDRequestMethod)method requestComplete:(KDRequestCompletionBlock)requestComplete
{
    return [[KDRequest alloc] initRequestWithURL:nil relativeURL:relativeURL parameters:parameters method:method requestType:KDDefaultRequest attachment:nil timeoutInterval:TIMEOUT_INTERVAL constructBodyBlock:nil progressBlock:nil downloadSettingBlock:nil downloadCompleteBlock:nil requestComplete:requestComplete];
}

//下载请求初始化
+(instancetype)downloadRequestWithURL:(NSString *)URL parameters:(NSDictionary *)parameters method:(KDRequestMethod)method downloadCompleteBlock:(KDDownloadCompleteBlock)downloadCompleteBlock
{
    return [self downloadRequestWithURL:URL parameters:parameters method:method progressBlock:nil downloadCompleteBlock:downloadCompleteBlock];
}
//下载请求初始化
+(instancetype)downloadRequestWithRelativeURL:(NSString *)relativeURL parameters:(NSDictionary *)parameters method:(KDRequestMethod)method downloadCompleteBlock:(KDDownloadCompleteBlock)downloadCompleteBlock
{
   return [[KDRequest alloc] initRequestWithURL:nil relativeURL:relativeURL parameters:parameters method:method requestType:KDDownloadRequest attachment:nil timeoutInterval:LONG_TASK_TIMEOUT_INTERVAL constructBodyBlock:nil progressBlock:nil downloadSettingBlock:nil downloadCompleteBlock:downloadCompleteBlock requestComplete:nil];
}

//下载请求初始化
+(instancetype)downloadRequestWithURL:(NSString *)URL parameters:(NSDictionary *)parameters method:(KDRequestMethod)method progressBlock:(KDRequestProgressBlock)progressBlock downloadCompleteBlock:(KDDownloadCompleteBlock)downloadCompleteBlock
{
    return [[KDRequest alloc] initRequestWithURL:URL relativeURL:nil parameters:parameters method:method requestType:KDDownloadRequest attachment:nil timeoutInterval:LONG_TASK_TIMEOUT_INTERVAL constructBodyBlock:nil progressBlock:progressBlock downloadSettingBlock:nil downloadCompleteBlock:downloadCompleteBlock requestComplete:nil];
}

//上传请求初始化(自己构建form表单)
+(instancetype)uploadRequestWithRelativeURL:(NSString *)relativeURL parameters:(NSDictionary *)parameters method:(KDRequestMethod)method constructBodyBlock:(KDConstructBodyBlock)constructBodyBlock progressBlock:(KDRequestProgressBlock)progressBlock requestComplete:(KDRequestCompletionBlock)requestComplete
{
    return [[KDRequest alloc] initRequestWithURL:nil relativeURL:relativeURL parameters:parameters method:method requestType:KDUploadRequest attachment:nil timeoutInterval:LONG_TASK_TIMEOUT_INTERVAL constructBodyBlock:constructBodyBlock progressBlock:progressBlock downloadSettingBlock:nil downloadCompleteBlock:nil requestComplete:requestComplete];
}

//上传请求初始化(使用附件)
+(instancetype)uploadRequestWithRelativeURL:(NSString *)relativeURL parameters:(NSDictionary *)parameters method:(KDRequestMethod)method attachment:(NSData *)attachment progressBlock:(KDRequestProgressBlock)progressBlock requestComplete:(KDRequestCompletionBlock)requestComplete
{
    return [[KDRequest alloc] initRequestWithURL:nil relativeURL:relativeURL parameters:parameters method:method requestType:KDUploadRequest attachment:attachment timeoutInterval:LONG_TASK_TIMEOUT_INTERVAL constructBodyBlock:nil progressBlock:progressBlock downloadSettingBlock:nil downloadCompleteBlock:nil requestComplete:requestComplete];
}

//处理服务器响应的统一入口
-(void)handleResponse:(NSURLResponse *)response responseData:(id)responseData error:(NSError *)error
{
    NSError *finalError = nil;
    NSMutableDictionary * object = nil;
    NSMutableDictionary *finalResponseDict = nil;
    
    if (error)
    {
        NSHTTPURLResponse *httpURLResponse = (NSHTTPURLResponse *)response;
        NSInteger stateCode = httpURLResponse.statusCode;
        
        //服务器错误
        if (stateCode > 200)
        {
            NSString *message = [NSString stringWithFormat:@"%d",(int)stateCode];
            NSString *errotReason = HTTP_REQUEST_ERROR;
            NSDictionary *userInfo = @{
                                       NSLocalizedDescriptionKey:message,
                                       NSLocalizedFailureReasonErrorKey: errotReason,
                                       };
            finalError = [NSError errorWithDomain:KDErrorDomain code:stateCode userInfo:userInfo];
        }
        //其他
        else
        {
            finalError = error;
        }
        
        finalResponseDict = nil;
        finalError = error;
        finalResponseDict = nil;
    }
    else if(responseData)
    {
        if ([responseData isKindOfClass:[NSDictionary class]])
        {
            object = [[NSMutableDictionary alloc] initWithDictionary:responseData];
        }
        else if ([responseData isKindOfClass:[NSData class]])
        {
            //iOS6 下，如果[NSJSONSerialization JSONObjectWithData： 传入 nil或者null 会崩溃
            if (responseData && ![responseData isEqual:[NSNull null]])
            {
                object = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&error];
            }
        }
        
        if (object)
        {
            NSString *status = [NSString stringWithFormat:@"%@",[object objectForKey:RESPONSE_STATUS]];
            
            if (status && [status isKindOfClass:[NSString class]] && status.length > 0)
            {
                if ([status isEqualToString:NORMAL_STATUS])
                {
                    finalResponseDict = [[NSMutableDictionary alloc] init];
                    NSString *message = [NSString stringWithFormat:@"%@",[object objectForKey:RESPONSE_MESSAGE]];
                    id data = [object objectForKey:RESPONSE_PAYLOAD];
                    
                    if (message)
                    {
                        [finalResponseDict setObject:message forKey:RESPONSE_MESSAGE];
                    }
                    
                    if (data)
                    {
                        [finalResponseDict setObject:data forKey:RESPONSE_PAYLOAD];
                    }
                
                    //如果登录请求成功，这里会先收集cookies
                    NSHTTPURLResponse *httpURLResponse = (NSHTTPURLResponse *)response;
                    NSArray* cookies = [NSHTTPCookie cookiesWithResponseHeaderFields:[httpURLResponse allHeaderFields] forURL:[NSURL URLWithString:[[KDEnvironmentManager sharedInstance] getBaseURL]]];
                    
                    NSDictionary* requestFields=[NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
                    NSString *cookieStr = [requestFields objectForKey:COOKIE_KEY];
      
                    if (VALIDATE_STRING(cookieStr))
                    {
                        [[KDCacheManager userCache] setObject:cookieStr forKey:COOKIE_KEY];
                    }
                    
                    finalError = nil;
                }
                else if ([status isEqualToString:LOGOUT_STATUS])
                {
                    DDLogInfo(@"未登录状态，需要登陆");
                    
                    NSString *message = @"请重新登录";
                    NSString *errotReason = @"请重新登录";
                    NSDictionary *userInfo = @{
                                               NSLocalizedDescriptionKey:message,
                                               NSLocalizedFailureReasonErrorKey: errotReason,
                                               };
                    finalError = [NSError errorWithDomain:KDErrorDomain code:[status integerValue] userInfo:userInfo];
                    finalResponseDict = nil;
                    [[KDUserManager sharedInstance] logout];
                    [[NSNotificationCenter defaultCenter]postNotificationName:kNeedUserLoginNotification object:nil];
                }
                else
                {
                    NSString *message = [NSString stringWithFormat:@"%@(%@)",[object objectForKey:RESPONSE_MESSAGE],status];
                    NSString *errotReason = @"服务端返回错误";
                    NSDictionary *userInfo = @{
                                               NSLocalizedDescriptionKey:message,
                                               NSLocalizedFailureReasonErrorKey: errotReason,
                                               };
                    finalError = [NSError errorWithDomain:KDErrorDomain code:[status integerValue] userInfo:userInfo];
                    finalResponseDict = nil;
                }
            }
            else
            {
                NSString *message = @"服务端返回为空";
                NSString *errotReason = @"服务端返回错误";
                NSDictionary *userInfo = @{
                                           NSLocalizedDescriptionKey:message,
                                           NSLocalizedFailureReasonErrorKey: errotReason,
                                           };
                finalError = [NSError errorWithDomain:KDErrorDomain code:kCFURLErrorUnknown userInfo:userInfo];
                finalResponseDict = nil;
            }
        }
        else
        {
            NSString *message = @"服务端返回为空";
            NSString *errotReason = @"服务端返回错误";
            NSDictionary *userInfo = @{
                                       NSLocalizedDescriptionKey:message,
                                       NSLocalizedFailureReasonErrorKey: errotReason,
                                       };
            finalError = [NSError errorWithDomain:KDErrorDomain code:kCFURLErrorUnknown userInfo:userInfo];
            finalResponseDict = nil;
        }
    }
    else
    {
        
        NSString *message = @"请求已取消";
        NSString *errotReason = @"请求已取消";
        NSDictionary *userInfo = @{
                                   NSLocalizedDescriptionKey:message,
                                   NSLocalizedFailureReasonErrorKey: errotReason,
                                   };
        finalError = [NSError errorWithDomain:KDErrorDomain code:kCFURLErrorCancelled userInfo:userInfo];
        finalResponseDict = nil;
    }
    
    if ([NSThread isMainThread])
    {
        self.requestCompletionBlock(finalResponseDict,finalError);
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.requestCompletionBlock(finalResponseDict,finalError);
        });
    }
}

//处理服务器响应的统一入口
-(void)handleResponse:(NSURLResponse *)response filePath:(id)filePath error:(NSError *)error
{
    NSError *finalError = nil;
    NSData *object = nil;
    NSMutableDictionary *finalResponseDict = [[NSMutableDictionary alloc] init];
    
    if (error)
    {
        finalError = error;
    }
    
    else if(filePath && [filePath isKindOfClass:[NSURL class]])
    {
        object = [[NSData alloc] initWithContentsOfURL:filePath];
        if (object)
        {
            [finalResponseDict setObject:object forKey:RESPONSE_PAYLOAD];
        }
        finalError = nil;
    }
    else
    {
        NSString *message = @"下载失败";
        NSString *errotReason = @"请求失败";
        NSDictionary *userInfo = @{
                                   NSLocalizedDescriptionKey:message,
                                   NSLocalizedFailureReasonErrorKey: errotReason,
                                   };
        finalError = [NSError errorWithDomain:KDErrorDomain code:kCFURLErrorCancelled userInfo:userInfo];
    }
    
    if ([NSThread isMainThread])
    {
        self.downloadCompleteBlock(finalResponseDict,filePath,finalError);
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.downloadCompleteBlock(finalResponseDict,filePath,finalError);
        });
    }
}

//请求初始化
-(instancetype)initRequestWithURL:(NSString *)url relativeURL:(NSString *)relativeURL parameters:(NSDictionary *)parameters method:(KDRequestMethod)method requestType:(KDRequestType)requestType attachment:(NSData *)attachment timeoutInterval:(NSTimeInterval)timeoutInterval constructBodyBlock:(KDConstructBodyBlock)constructBodyBlock progressBlock:(KDRequestProgressBlock)progressBlock downloadSettingBlock:(KDDownloadSettingBlock)downloadSettingBlock downloadCompleteBlock:(KDDownloadCompleteBlock)downloadCompleteBlock requestComplete:(KDRequestCompletionBlock)requestComplete
{
    self = [super init];
    
    if (self)
    {
        _URLString = url;
        _relativeURLString = relativeURL;
        _requestMethod = method;
        _requestType = requestType;
        _parameters = parameters;
        _attachment = attachment;
        _timeoutInterval = timeoutInterval;
        _constructBodyBlock = constructBodyBlock;
        _progressBlock = progressBlock;
        _downloadCompleteBlock = downloadCompleteBlock;
        _downloadSettingBlock = downloadSettingBlock;
        _requestCompletionBlock = requestComplete;
    }
    return self;
}

@end
