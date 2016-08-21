//
//  KDRequest.h
//  netAccessDemo
//
//  Created by ppnd on 16/3/2.
//  Copyright © 2016年 ppnd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFURLRequestSerialization.h"

#define TIMEOUT_INTERVAL 15
#define LONG_TASK_TIMEOUT_INTERVAL 60
#define KDErrorDomain @"KDErrorDomain"

#define HTTP_REQUEST_ERROR @"请求出错"

#define RESPONSE_STATUS @"status"
#define RESPONSE_MESSAGE @"msg"
#define RESPONSE_PAYLOAD @"data"

#define NORMAL_STATUS @"200"
#define ERROR_STATUS @"0"
//#define UnregisterStatus @"-1"


#define LOGIN_REQUEST_PATH @"login_request"
#define GET_USERINFO_REQUEST_PATH @"get_userinfo"
#define GET_ORDER_REQUEST_PATH @"get_order"
#define GET_ORDER_LIKE_REQUEST_PATH @"get_order_like"
#define LOGOUT_REQUEST_PATH @"logout_request"
#define _REQUEST_PATH @""
#define _REQUEST_PATH @""
//#define _REQUEST_PATH @""
//#define _REQUEST_PATH @""
//#define _REQUEST_PATH @""
//#define _REQUEST_PATH @""
//#define _REQUEST_PATH @""
//#define _REQUEST_PATH @""
//#define _REQUEST_PATH @""
//#define _REQUEST_PATH @""
//#define _REQUEST_PATH @""
//#define _REQUEST_PATH @""
//#define _REQUEST_PATH @""
//#define _REQUEST_PATH @""


//请求方法
typedef NS_ENUM(NSUInteger , KDRequestMethod)
{
    //GET
    KDRequestMethodGet = 0,
    //POST
    KDRequestMethodPost,
};

//请求序列化方法
typedef NS_ENUM(NSUInteger , KDRequestSerializerType)
{
    //HTTP
    KDRequestSerializerTypeHTTP = 0,
    //JSON
    KDRequestSerializerTypeJSON,
    
};

//请求类型
typedef NS_ENUM(NSUInteger , KDRequestType)
{
    //普通请求
    KDDefaultRequest = 0,
    //上传请求
    KDUploadRequest,
    //下载请求
    KDDownloadRequest,
};

//请求返回回调
typedef void (^KDRequestCompletionBlock)(id responseObject, NSError *error);

//下载请求设置（设置缓存路径和文件名）
typedef NSURL *(^KDDownloadSettingBlock)(void);

//下载完成回调
typedef void (^KDDownloadCompleteBlock)(NSDictionary *fileData, NSString *filePath, NSError *error);

//进度回调
typedef void (^KDRequestProgressBlock)(long long numberOfFinishedOperations, long long totalNumberOfOperations, float progress);

//创建form表单的block
typedef void (^KDConstructBodyBlock)(id <AFMultipartFormData> formData);

@interface KDRequest : NSObject

//设置请求的相对URL
@property (nonatomic, strong) NSString *relativeURLString;

//设置请求的完整URL
@property (nonatomic, strong) NSString *URLString;

//设置请求返回的回调
@property (nonatomic, copy) KDRequestCompletionBlock requestCompletionBlock;

//进度回调
@property (nonatomic,copy) KDRequestProgressBlock progressBlock;

//设置下载设置回调
@property (nonatomic,copy) KDDownloadSettingBlock downloadSettingBlock;

//设置下载完成回调
@property (nonatomic,copy) KDDownloadCompleteBlock downloadCompleteBlock;

//设置创建form表单的block
@property (nonatomic,copy) KDConstructBodyBlock constructBodyBlock;

//设置请求超时时间
@property (nonatomic, assign) NSTimeInterval timeoutInterval;

//设置请求序列化方法
@property (nonatomic, assign) KDRequestSerializerType requestSerializerType;

//设置请求的参数
@property (nonatomic, strong) id parameters;

//设置附件
@property (nonatomic, strong) id attachment;

//设置附件路径
@property (nonatomic, strong) NSString *attachmentFilePath;

//设置请求类型
@property (nonatomic, assign) KDRequestType requestType;

//设置请求方法
@property (nonatomic, assign) KDRequestMethod requestMethod;


//普通请求初始化
+(instancetype)requestWithURL:(NSString *)URL parameters:(NSDictionary *)parameters method:(KDRequestMethod)method requestComplete:(KDRequestCompletionBlock)requestComplete;

//普通请求初始化
+(instancetype)requestWithRelativeURL:(NSString *)relativeURL parameters:(NSDictionary *)parameters method:(KDRequestMethod)method requestComplete:(KDRequestCompletionBlock)requestComplete;

//下载请求初始化
+(instancetype)downloadRequestWithURL:(NSString *)URL parameters:(NSDictionary *)parameters method:(KDRequestMethod)method downloadCompleteBlock:(KDDownloadCompleteBlock)downloadCompleteBlock;

//下载请求初始化
+(instancetype)downloadRequestWithURL:(NSString *)URL parameters:(NSDictionary *)parameters method:(KDRequestMethod)method progressBlock:(KDRequestProgressBlock)progressBlock downloadCompleteBlock:(KDDownloadCompleteBlock)downloadCompleteBlock;

//上传请求初始化(自己构建form表单)
+(instancetype)uploadRequestWithRelativeURL:(NSString *)relativeURL parameters:(NSDictionary *)parameters method:(KDRequestMethod)method constructBodyBlock:(KDConstructBodyBlock)constructBodyBlock progressBlock:(KDRequestProgressBlock)progressBlock requestComplete:(KDRequestCompletionBlock)requestComplete;

//上传请求初始化(使用附件)
+(instancetype)uploadRequestWithRelativeURL:(NSString *)relativeURL parameters:(NSDictionary *)parameters method:(KDRequestMethod)method attachment:(NSDictionary *)attachment progressBlock:(KDRequestProgressBlock)progressBlock requestComplete:(KDRequestCompletionBlock)requestComplete;

//处理服务器响应的统一入口
-(void)handleResponse:(NSURLResponse *)response responseData:(id)responseData error:(NSError *)error;

//处理服务器响应的统一入口
-(void)handleResponse:(NSURLResponse *)response filePath:(id)filePath error:(NSError *)error;

@end
