//
//  KDLoggerManager.h
//  KuaiDianPlan
//
//  Created by ppnd on 16/6/26.
//  Copyright © 2016年 zy. All rights reserved.
//

#import <Foundation/Foundation.h>

extern int const ddLogLevel;

@interface KDLoggerManager : NSObject

+ (instancetype)sharedInstance;

//开始记录日志
-(void)startLoggingWithOptions:(NSDictionary *)launchOptions;

@end
