//
//  KDEnvironmentManager.h
//  KuaiDianPlan
//
//  Created by ppnd on 16/6/18.
//  Copyright © 2016年 zy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KDEnvironmentManager : NSObject
//类方法
+ (instancetype)sharedInstance;

//设置和获取方法
-(void)setEnvironmentType:(KDEnvironmentType)type;
-(void)setURLPrfixType:(KDURLPrefixType)prefixType;
-(KDEnvironmentType)getEnvironmentType;
-(KDURLPrefixType)getURLPrefixType;

//获取网络请求的基础URL
-(NSString *)getBaseURL;

//获取key对应的网络请求地址
-(NSString *)getRequetPathForKey:(NSString *)key;

@end
