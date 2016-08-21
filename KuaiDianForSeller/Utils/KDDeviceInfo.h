//
//  KDDeviceInfo.h
//  KuaiDianPlan
//
//  Created by ppnd on 16/6/26.
//  Copyright © 2016年 zy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KDDeviceInfo : NSObject

//获取设置model(iphone/ipad)
+(NSString *)deviceBrand;

//获取版本号
+(NSString *)appVersion;

//获取系统ios版本
+(NSString *)systemVersion;

//获取设备名
+ (NSString*)deviceString;

@end
