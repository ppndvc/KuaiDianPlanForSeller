//
//  KDNetworkManager.m
//  netAccessDemo
//
//  Created by ppnd on 16/3/8.
//  Copyright © 2016年 ppnd. All rights reserved.
//

#import "KDNetworkManager.h"
#import "AFNetworking.h"
#import "KDEnvironmentManager.h"
#import "KDCacheManager.h"

#define NeedSecurityHttp (0)
#define MaxConcurrentRequestCount 6

@interface KDNetworkManager()

//AFNetworking类
@property(nonatomic,strong)AFURLSessionManager *manager;
//请求序列化
@property (nonatomic, strong) AFHTTPRequestSerializer <AFURLRequestSerialization> * requestSerializer;
//请求序列化类型
@property(nonatomic,assign)KDRequestSerializerType requestSerializerType;

@end

@implementation KDNetworkManager

+ (instancetype)sharedManager
{
    __strong static id sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        _manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        _manager.operationQueue.maxConcurrentOperationCount = MaxConcurrentRequestCount;
        _manager.securityPolicy = [self customSecurityPolicy];
        //默认使用HTTP序列化方法
        [self setRequestSerializerType:KDRequestSerializerTypeHTTP];
    }
    return self;
}

-(AFSecurityPolicy *)customSecurityPolicy
{
    AFSecurityPolicy *securityPolicy = nil;
    
    if (NeedSecurityHttp)
    {
        // /先导入证书
        NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"sslCert" ofType:@"cer"];
        NSData *certData = [NSData dataWithContentsOfFile:cerPath];
        
        // AFSSLPinningModeCertificate 使用证书验证模式
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
        
        // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
        // 如果是需要验证自建证书，需要设置为YES
        securityPolicy.allowInvalidCertificates = YES;
        
        //validatesDomainName 是否需要验证域名，默认为YES；
        //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
        //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
        //如置为NO，建议自己添加对应域名的校验逻辑。
        securityPolicy.validatesDomainName = NO;
        
        securityPolicy.pinnedCertificates = [NSSet setWithArray:@[certData]];;
    }
    else
    {
//        securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        securityPolicy.allowInvalidCertificates = YES;
//        securityPolicy.validatesDomainName = YES;
    }

    return securityPolicy;
}

//修改序列化方法
-(void)setRequestSerializerType:(KDRequestSerializerType)requestSerializerType
{
    _requestSerializerType = requestSerializerType;
    [self _changeRequestSerilaizerWithType:_requestSerializerType];
}

//发送请求
-(void)sendRequest:(KDRequest *)request
{
    if(request)
    {
        //设置cookie
        [self setCookie];
        
        //生成请求
        NSURLRequest *AFRequest = [self getURLRequestFromKDRequest:request];
        if (AFRequest)
        {
            //先取消此地址的所有请求
            [self cancelRequestWithNSURLRequest:AFRequest];
            
            switch (request.requestType)
            {
                case KDDefaultRequest:
                {
                    NSURLSessionDataTask *requestTask = [_manager dataTaskWithRequest:AFRequest completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
                        [request handleResponse:response responseData:responseObject error:error];
                    }];
                    
                    [requestTask resume];
                }
                    break;
                case KDDownloadRequest:
                {
                    NSURLSessionDownloadTask *downloadTask = [_manager downloadTaskWithRequest:AFRequest progress:^(NSProgress *downloadProgress) {
                        if (request.progressBlock)
                        {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                request.progressBlock(downloadProgress.completedUnitCount,downloadProgress.totalUnitCount,downloadProgress.fractionCompleted);
                            });
                        }
                    } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
                        
                        if (request.downloadSettingBlock)
                        {
                            return request.downloadSettingBlock();
                        }
                        else
                        {
                            NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
                            return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
                        }
                        
                    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
                        [request handleResponse:response filePath:filePath error:error];
                    }];
                    [downloadTask resume];
                }
                    break;
                case KDUploadRequest:
                {
                    NSURLSessionUploadTask *uploadTask = [_manager uploadTaskWithStreamedRequest:AFRequest progress:^(NSProgress * _Nonnull uploadProgress) {
                        if (request.progressBlock)
                        {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                request.progressBlock(uploadProgress.completedUnitCount,uploadProgress.totalUnitCount,uploadProgress.fractionCompleted);
                            });
                        }
                    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                        [request handleResponse:response responseData:responseObject error:error];
                    }];
                    
                    [uploadTask resume];
                }
                    break;
                default:
                    break;
            }
        }
        else
        {
            NSString *message = @"生成请求失败";
            NSString *errotReason = @"生成请求失败";
            NSDictionary *userInfo = @{
                                       NSLocalizedDescriptionKey:message,
                                       NSLocalizedFailureReasonErrorKey: errotReason,
                                       };
            NSError *error = [NSError errorWithDomain:KDErrorDomain code:kCFURLErrorCancelled userInfo:userInfo];
            
            if (request.requestType == KDDownloadRequest)
            {
                [request handleResponse:nil filePath:nil error:error];
            }
            else
            {
                [request handleResponse:nil responseData:nil error:error];
            }
        }
    }
}
//取消请求
-(void)cancelRequestWithNSURLRequest:(NSURLRequest *)request
{
    [_manager.tasks enumerateObjectsUsingBlock:^(NSURLSessionTask * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSURLSessionTask *task = (NSURLSessionTask *)obj;
        if (task && [task.originalRequest isEqual:request])
        {
            NSLog(@"取消 task %@",task.taskDescription);
            
            [task cancel];
            *stop = YES;
        }
    }];
}
//取消全部请求
-(void)cancelAllRequest
{
    [_manager.tasks enumerateObjectsUsingBlock:^(NSURLSessionTask * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSURLSessionTask *task = (NSURLSessionTask *)obj;
        [task cancel];
    }];
    
    NSLog(@"取消全部task");
}

//KDRequest转换为NSURLRequest
-(NSURLRequest *)getURLRequestFromKDRequest:(KDRequest *)kdRequest
{
    NSMutableURLRequest *request = nil;
    NSString *requestURL = nil;
    
    //生成请求URL
    if (kdRequest.URLString && kdRequest.URLString.length > 0)
    {
        NSString *urlStr = kdRequest.URLString;
        
        if ([urlStr respondsToSelector:@selector(stringByAddingPercentEncodingWithAllowedCharacters:)])
        {
            requestURL = [[[NSURL alloc] initWithString:[urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]] absoluteString];
        }
        else
        {
            requestURL = [[[NSURL alloc] initWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] absoluteString];
        }
        
    }
    else if( kdRequest.relativeURLString)
    {
        NSString *baseURL = [[KDEnvironmentManager sharedInstance] getBaseURL];
        //如果获取的基础url是非法的，直接返回nil
        if (!VALIDATE_STRING(baseURL))
        {
            return nil;
        }
        
        NSString *urlStr = kdRequest.relativeURLString;

        if ([urlStr respondsToSelector:@selector(stringByAddingPercentEncodingWithAllowedCharacters:)])
        {
            requestURL = [[NSURL URLWithString:[urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]] relativeToURL:[NSURL URLWithString:[baseURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]] absoluteString];
        }
        else
        {
            requestURL = [[NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] relativeToURL:[NSURL URLWithString:[baseURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]] absoluteString];
        }
    }
    
    NSParameterAssert(requestURL);
    
    //生成NSURLRequest
    switch (kdRequest.requestType)
    {
        case KDDefaultRequest:
        case KDDownloadRequest:
        {
            request = [_requestSerializer requestWithMethod:[self _formatMethodString:kdRequest.requestMethod] URLString:requestURL parameters:kdRequest.parameters error:nil];
        }
            break;
        case KDUploadRequest:
        {
            if (kdRequest.constructBodyBlock)
            {
                request = [_requestSerializer multipartFormRequestWithMethod:[self _formatMethodString:kdRequest.requestMethod] URLString:requestURL parameters:kdRequest.parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                    
                    kdRequest.constructBodyBlock(formData);
                    
                } error:nil];
            }
            else
            {
                if (kdRequest.attachment)
                {
                    request = [_requestSerializer multipartFormRequestWithMethod:[self _formatMethodString:kdRequest.requestMethod] URLString:requestURL parameters:kdRequest.parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                       
                        [formData appendPartWithFileData:kdRequest.attachment name:@"file" fileName:@"file" mimeType:@"application/file"];
                   
                    } error:nil];
                }
            }
        }
            break;
        default:
            break;
    }
    
    //设置超时时间
    if (request)
    {
        request.timeoutInterval = kdRequest.timeoutInterval;
    }
    
    return request;
}

-(NSString *)_formatMethodString:(KDRequestMethod)method
{
    NSString *methodString = nil;
    if (method == KDRequestMethodGet)
    {
        methodString = @"GET";
    }
    else if (method == KDRequestMethodPost)
    {
        methodString = @"POST";
    }
    
    return methodString;
}

-(void)_changeRequestSerilaizerWithType:(KDRequestSerializerType)requestSerializerType
{
    if (requestSerializerType == KDRequestSerializerTypeHTTP)
    {
        _requestSerializer = [[AFHTTPRequestSerializer alloc] init];
    }
    else
    {
        _requestSerializer = [[AFJSONRequestSerializer alloc] init];
    }
}

-(void)setCookie
{
    NSString *cookieStr = (NSString *)[[KDCacheManager userCache] objectForKey:COOKIE_KEY];
    
    if (VALIDATE_STRING(cookieStr))
    {
        //设置cookie
        [_requestSerializer setValue:cookieStr forHTTPHeaderField:COOKIE_KEY];
    }
}
@end
