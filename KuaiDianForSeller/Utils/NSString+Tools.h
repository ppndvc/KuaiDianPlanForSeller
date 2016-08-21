//
//  NSString+Tools.h
//  KuaiDianPlan
//
//  Created by ppnd on 16/8/4.
//  Copyright © 2016年 zy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Tools)

//包含字符串
-(BOOL)containSubStr:(NSString *)subStr;

//微博时间格式
+(NSString *)weiboFormateTimeWithTimeInterval:(NSTimeInterval)dateStamp;

//把time转化成对应格式的字符串
+(NSString *)getTimeString:(NSTimeInterval)time formater:(NSString *)formater;

//格式化银行卡号码（隔4位）
+(NSString *)getFormateCardNumberFromString:(NSString *)srcString;

//获得虚拟银行卡号 比如： *****5958
+(NSString *)getVertualStringWithString:(NSString *)srcString;
@end
