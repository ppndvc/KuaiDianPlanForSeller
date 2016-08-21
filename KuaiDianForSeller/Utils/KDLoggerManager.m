//
//  KDLoggerManager.m
//  KuaiDianPlan
//
//  Created by ppnd on 16/6/26.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDLoggerManager.h"
#import "KDDeviceInfo.h"

#if DEBUG
#import "DDTTYLogger.h"
#import "DDASLLogger.h"
#endif

@implementation KDLoggerManager
+ (instancetype)sharedInstance
{
    __strong static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

-(void)startLoggingWithOptions:(NSDictionary *)launchOptions
{
#ifdef DEBUG
    //写入苹果日志
    [DDLog addLogger:[DDASLLogger sharedInstance]];
    //写入控制台
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
#endif
    
    [self startToLogging:launchOptions];
    
}

- (void)startToLogging:(NSDictionary *)launchOptions
{
    DDLogInfo(@"=========================================================");
    DDLogInfo(@"Launching KuaiDian Plan");
#ifdef DEBUG
    DDLogInfo(@"Log mode:  Debug");
#else
    DDLogInfo(@"Log mode:  Production");
#endif
    DDLogInfo(@"Device brand: %@", [KDDeviceInfo deviceBrand]);
    DDLogInfo(@"OS version: %@", [KDDeviceInfo systemVersion]);
    DDLogInfo(@"APP version: %@", [KDDeviceInfo appVersion]);
    DDLogInfo(@"Launch options: %@", launchOptions);
    DDLogInfo(@"==========================================================");
}

@end
