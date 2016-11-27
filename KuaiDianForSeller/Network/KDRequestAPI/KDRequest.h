//
//  KDRequest.h
//  netAccessDemo
//
//  Created by ppnd on 16/3/2.
//  Copyright © 2016年 ppnd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFURLRequestSerialization.h"


#pragma mark - 请求时间设置

#define TIMEOUT_INTERVAL 15
#define LONG_TASK_TIMEOUT_INTERVAL 60
#define ROWS_PER_PAGE 60

#pragma mark - 请求返回信息

#define KDErrorDomain @"KDErrorDomain"

#define HTTP_REQUEST_ERROR @"请求出错"

#define RESPONSE_STATUS @"status"
#define RESPONSE_MESSAGE @"msg"
#define RESPONSE_PAYLOAD @"data"

#define NORMAL_STATUS @"200"
#define ERROR_STATUS @"0"
#define LOGOUT_STATUS @"401"

#pragma mark - 请求字段key

#define REQUEST_KEY_SELLER_ID @"sellerid"
#define REQUEST_KEY_ORDER_ID @"id"
#define REQUEST_KEY_ORDER_STATES(a) ([NSString stringWithFormat:@"states[%@]",(a)])
#define REQUEST_KEY_STATE @"state"
#define REQUEST_KEY_PAGING_PAGE @"pagination.page"
#define REQUEST_KEY_PAGING_ROWS @"pagination.rows"
#define REQUEST_KEY_ORDER_START_DATE @"fromtime"
#define REQUEST_KEY_ORDER_END_DATE @"totime"
#define REQUEST_KEY_FOOD_NAME @"foodName"
#define REQUEST_KEY_REMEMBER_ME @"rememberMe"
#define REQUEST_KEY_SHOP_ID @"storeid"
#define REQUEST_KEY_NAME @"name"
#define REQUEST_KEY_PRICE @"price"
#define REQUEST_KEY_LOGO_URL @"logourl"
#define REQUEST_KEY_FOOD_SOLD_IN_MONTH @"soldinmonth"
#define REQUEST_KEY_FOOD_LABEL @"lab"
#define REQUEST_KEY_DESCRIPITION @"remark"
#define REQUEST_KEY_CLASSIFY_ID @"classifyid"
#define REQUEST_KEY_FILE_NAME @"file"
#define REQUEST_KEY_VERIFY_CODE_TO @"to"
#define REQUEST_KEY_BANK_NAME @"bankname"
#define REQUEST_KEY_BANK_CARD_NUMBER @"card"
#define REQUEST_KEY_BANK_ACCOUNT_NAME @"accountname"
#define REQUEST_KEY_PHONE_NUMBER @"phone"
#define REQUEST_KEY_IDENTITY_CARD_NUMBER @"identity"
#define REQUEST_KEY_EVALUATE_ID @"evaluateid"
#define REQUEST_KEY_CONTENT @"content"
#define REQUEST_KEY_PARAMETER_SEPERATOR @"?"
#define REQUEST_KEY_FILE_PATH @"filePath"
#define REQUEST_KEY_EQUAL @"="
//#define REQUEST_KEY_ @""
//#define REQUEST_KEY_ @""
//#define REQUEST_KEY_ @""
//#define REQUEST_KEY_ @""
//#define REQUEST_KEY_ @""
//#define REQUEST_KEY_ @""
//#define REQUEST_KEY_ @""
//#define REQUEST_KEY_ @""

#pragma mark - 请求路径key
#define LOGIN_REQUEST_PATH @"login_request"
#define GET_USERINFO_REQUEST_PATH @"get_userinfo"
#define GET_ORDER_REQUEST_PATH @"get_order"
#define GET_ORDER_LIKE_REQUEST_PATH @"get_order_like"
#define LOGOUT_REQUEST_PATH @"logout_request"
#define GET_VERIFY_CODE_REQUEST_PATH @"get_phone_code"
#define MODIFY_ORDER_STATUS_REQUEST_PATH @"modify_order_status"
#define MODIFY_USER_INFO_REQUEST_PATH @"modify_user_info"
#define GET_STORE_INFO_REQUEST_PATH @"get_store_info"
#define GET_FOOD_CATEGORY_REQUEST_PATH @"get_food_class"
#define GET_FOOD_LIST_REQUEST_PATH @"get_food_list"
#define ADD_FOOD_CATE_REQUEST_PATH @"add_food_cate"
#define MODIFY_FOOD_CATE_TITLE_REQUEST_PATH @"modify_food_cate_title"
#define ADD_FOOD_ITEM_REQUEST_PATH @"add_food_item"
#define UPDATE_FOOD_ITEM_REQUEST_PATH @"update_food_item"
#define DELETE_FOOD_ITEM_REQUEST_PATH @"delete_food_item"
#define UPLODA_FOOD_LOGO_REQUEST_PATH @"upload_food_logo"
#define SALE_STATISTIC_REQUEST_PATH @"business_record"
#define GET_FOOD_EVALUE_INFO_REQUEST_PATH @"food_evalue_search"
#define GET_BANK_CARD_INFO_REQUEST_PATH @"bank_card_info"
#define ADD_BANK_CARD_REQUEST_PATH @"add_bank_card"
#define ADD_REPLY_REQUEST_PATH @"add_reply"
#define GET_BILL_DETAIL_REQUEST_PATH @"get_bill_detail"
#define DOWNLOAD_FOOD_LOGO_REQUEST_PATH @"download_food_logo"
#define DOWNLOAD_SHOP_LOGO_REQUEST_PATH @"download_shop_logo"
//#define _REQUEST_PATH @""
//#define _REQUEST_PATH @""
//#define _REQUEST_PATH @"
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

//下载
+(instancetype)downloadRequestWithRelativeURL:(NSString *)relativeURL parameters:(NSDictionary *)parameters method:(KDRequestMethod)method downloadCompleteBlock:(KDDownloadCompleteBlock)downloadCompleteBlock;

//下载请求初始化
+(instancetype)downloadRequestWithURL:(NSString *)URL parameters:(NSDictionary *)parameters method:(KDRequestMethod)method progressBlock:(KDRequestProgressBlock)progressBlock downloadCompleteBlock:(KDDownloadCompleteBlock)downloadCompleteBlock;

//上传请求初始化(自己构建form表单)
+(instancetype)uploadRequestWithRelativeURL:(NSString *)relativeURL parameters:(NSDictionary *)parameters method:(KDRequestMethod)method constructBodyBlock:(KDConstructBodyBlock)constructBodyBlock progressBlock:(KDRequestProgressBlock)progressBlock requestComplete:(KDRequestCompletionBlock)requestComplete;

//上传请求初始化(使用附件)
+(instancetype)uploadRequestWithRelativeURL:(NSString *)relativeURL parameters:(NSDictionary *)parameters method:(KDRequestMethod)method attachment:(NSData *)attachment progressBlock:(KDRequestProgressBlock)progressBlock requestComplete:(KDRequestCompletionBlock)requestComplete;

//处理服务器响应的统一入口
-(void)handleResponse:(NSURLResponse *)response responseData:(id)responseData error:(NSError *)error;

//处理服务器响应的统一入口
-(void)handleResponse:(NSURLResponse *)response filePath:(id)filePath error:(NSError *)error;

@end
