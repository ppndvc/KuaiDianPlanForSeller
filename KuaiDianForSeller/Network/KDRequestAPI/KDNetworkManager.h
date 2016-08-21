//
//  KDNetworkManager.h
//  netAccessDemo
//
//  Created by ppnd on 16/3/8.
//  Copyright © 2016年 ppnd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KDRequest.h"

@interface KDNetworkManager : NSObject

//类方法
+(instancetype)sharedManager;

//修改序列化方法
-(void)setRequestSerializerType:(KDRequestSerializerType)requestSerializerType;
//发送请求
-(void)sendRequest:(KDRequest *)request;
//取消请求
-(void)cancelRequestWithNSURLRequest:(NSURLRequest *)request;
//取消全部请求
-(void)cancelAllRequest;

@end
