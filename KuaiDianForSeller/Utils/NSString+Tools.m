//
//  NSString+Tools.m
//  KuaiDianPlan
//
//  Created by ppnd on 16/8/4.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "NSString+Tools.h"
#import <CommonCrypto/CommonDigest.h>

#define anHour  3600
#define aMinute 60
#define REAL_NUMBER_LENGTH 3

#define TODAY_STRING @"今天"
#define YESTODAY_STRING @"昨天"

#define ARRAY_SEPERATOR @"-"
#define PHONE_SEPERATOR @"-"

@implementation NSString (Tools)

-(BOOL)containSubStr:(NSString *)subStr
{
    BOOL contain = NO;
    
    if (VALIDATE_STRING(subStr))
    {
        if (IS_OS_8_OR_LATER)
        {
            contain = [self containsString:subStr];
        }
        else
        {
            NSRange range = [self rangeOfString:subStr];
            
            if ( range.location != NSNotFound)
            {
                contain = YES;
            }
        }
    }
    
    return contain;
}
-(CGSize)getStringDrawRectWithConstrainSize:(CGSize)constrainSize font:(UIFont *)font
{
    CGSize realSize = [self boundingRectWithSize:constrainSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    
    return realSize;
}

+(NSString *)weiboFormateTimeWithTimeInterval:(NSTimeInterval)dateStamp
{
    //获取当前时间
    NSDate *currentDate = [NSDate date];
    //将当前时间转化为时间戳
    NSTimeInterval currentDateStamp = [currentDate timeIntervalSince1970] + 8 * anHour;

    //获取当前时间的小时单位（24小时制）
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"H"];
    int nowHour = [[formatter stringFromDate:currentDate] intValue];
    //获取当前时间的分钟单位
    NSDateFormatter *minFormatter = [NSDateFormatter new];
    [minFormatter setDateFormat:@"m"];
    int nowMinute = [[minFormatter stringFromDate:currentDate] intValue];
    //今天0点的时间戳
    double todayZeroClock = currentDateStamp - anHour * nowHour - aMinute * nowMinute;
    //时间格式化，为输出做准备
    NSDateFormatter *outputFormat = [NSDateFormatter new];
    [outputFormat setDateFormat:@"M月d日 HH:mm"];
    
    //已经超过两天以上
    if (todayZeroClock - dateStamp > 24 * anHour)
    {
        NSDateFormatter *outputFormat = [NSDateFormatter new];
        [outputFormat setDateFormat:@"M月d日 HH:mm"];
        
        return [outputFormat stringFromDate:[NSDate dateWithTimeIntervalSince1970:dateStamp]];
    }
    //已经超过一天（昨天）
    else if (todayZeroClock - dateStamp > 0)
    {
        NSDateFormatter *outputFormat = [NSDateFormatter new];
        [outputFormat setDateFormat:@"HH:mm"];
        NSString *timeStr = [outputFormat stringFromDate:[NSDate dateWithTimeIntervalSince1970:dateStamp]];
        return [NSString stringWithFormat:@"%@ %@",YESTODAY_STRING,timeStr];
    }
    else
    {
        NSDateFormatter *outputFormat = [NSDateFormatter new];
        [outputFormat setDateFormat:@"HH:mm"];
        NSString *timeStr = [outputFormat stringFromDate:[NSDate dateWithTimeIntervalSince1970:dateStamp]];
        return [NSString stringWithFormat:@"%@ %@",TODAY_STRING,timeStr];
    }
}

+(NSString *)getTodayStartDateString
{
    //获取当前时间
    NSDate *currentDate = [NSDate date];
    //将当前时间转化为时间戳
    NSTimeInterval currentDateStamp = [currentDate timeIntervalSince1970] + 8 * anHour;
    
    //获取当前时间的小时单位（24小时制）
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"H"];
    int nowHour = [[formatter stringFromDate:currentDate] intValue];
    //获取当前时间的分钟单位
    NSDateFormatter *minFormatter = [NSDateFormatter new];
    [minFormatter setDateFormat:@"m"];
    int nowMinute = [[minFormatter stringFromDate:currentDate] intValue];
    //今天0点的时间戳
    double todayZeroClock = currentDateStamp - anHour * nowHour - aMinute * nowMinute;
    
    return [self getTimeString:todayZeroClock formater:YYYY_MM_DD_HH_MM_SS_DATE_FORMATER];
}
+(NSString *)getInitDateString
{
    return [self getTimeString:1 formater:YYYY_MM_DD_HH_MM_SS_DATE_FORMATER];
}
+(NSString *)getCurrentDateString
{
    //获取当前时间
    return [self getTimeString:[[NSDate date] timeIntervalSince1970] formater:YYYY_MM_DD_HH_MM_SS_DATE_FORMATER];
}
+(NSString *)longMD5WithString:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ]; 
}
+(NSString *)getTimeString:(NSTimeInterval)time formater:(NSString *)formater
{
    NSString *timeStr = nil;
    if (time > 0 && VALIDATE_STRING(formater))
    {
        //毫秒级变为秒级
        if ((time / 1000) > 1000000000)
        {
            time /= 1000;
        }
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:formater];
        NSTimeZone *zone = [NSTimeZone localTimeZone];
        [dateFormatter setTimeZone:zone];
        
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
        timeStr = [dateFormatter stringFromDate:date];
    }

    return timeStr;
}
+(NSString *)getTimeStringWithDate:(NSDate *)date formater:(NSString *)formater
{
    NSString *timeStr = nil;
    if (date && VALIDATE_STRING(formater))
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:formater];
        NSTimeZone *zone = [NSTimeZone localTimeZone];
        [dateFormatter setTimeZone:zone];
        
        timeStr = [dateFormatter stringFromDate:date];
    }
    
    return timeStr;
}
+(NSString *)getFormateCardNumberFromString:(NSString *)srcString
{
    if (VALIDATE_STRING(srcString))
    {
        NSString *tmpStr = [srcString stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        NSInteger size = (tmpStr.length / 4);
        
        NSMutableArray *tmpStrArr = [[NSMutableArray alloc] init];
        for (int n = 0;n < size; n++)
        {
            [tmpStrArr addObject:[tmpStr substringWithRange:NSMakeRange(n*4, 4)]];
        }
        
        [tmpStrArr addObject:[tmpStr substringWithRange:NSMakeRange(size*4, (tmpStr.length % 4))]];
        
        tmpStr = [tmpStrArr componentsJoinedByString:@" "];
        
        return tmpStr;
    }
    
    return nil;
}
+(NSString *)getVertualCardNumberStringWithString:(NSString *)srcString
{
    if (VALIDATE_STRING(srcString))
    {
        NSInteger length = srcString.length;
        NSString *replaceStr = @"";
        for (int i = 0; i < length - REAL_NUMBER_LENGTH; i++)
        {
            replaceStr = [replaceStr stringByAppendingString:@"*"];
        }
        
        srcString = [srcString stringByReplacingCharactersInRange:NSMakeRange(0, length - REAL_NUMBER_LENGTH) withString:replaceStr];
        return srcString;
    }
    
    return nil;
}

+(NSComparisonResult)compareDateString:(NSString *)date1 withDate:(NSString *)date2 dateFormater:(NSString *)formater
{
    if (VALIDATE_STRING(date1) && VALIDATE_STRING(date2) && VALIDATE_STRING(formater))
    {
        NSDateFormatter *dateFromatter = [[NSDateFormatter alloc] init];
        [dateFromatter setDateFormat:formater];
        
        NSDate *dateF = [dateFromatter dateFromString:date1];
        NSDate *dateS = [dateFromatter dateFromString:date2];
        
        return [dateF compare:dateS];
    }
    
    return NSOrderedSame;
}
+(NSString *)getPhoneNumberWithString:(NSString *)srcStr formater:(NSString *)formater
{
    if (VALIDATE_STRING(srcStr) && VALIDATE_STRING(formater))
    {
        NSArray *posArray = [formater componentsSeparatedByString:ARRAY_SEPERATOR];
        NSMutableString *result = [[NSMutableString alloc] initWithString:srcStr];
        
        NSInteger offset = 0;
        NSInteger postion = 0;
        
        for(int i = 0 ; i < (int)[posArray count] - 1; i++)
        {
            postion += [posArray[i] integerValue];
            postion += (offset++);
            if (result.length > postion)
            {
                [result insertString:PHONE_SEPERATOR atIndex:postion];
            }
        }
        return result;
    }
    
    return nil;
}

//电话号码验证
+ (BOOL) validatePhoneNumber:(NSString *)phoneNumber
{
    if (VALIDATE_STRING(phoneNumber))
    {
        NSString *telephoneRegex = @"(\\d{2,5}-\\d{7,8}(-\\d{1,})?)|(((13[0-9])|(15[^4,\\D])|(17[0-9])|(18[0,0-9]))\\d{8}$)";
        NSPredicate *telephoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",telephoneRegex];
        return [telephoneTest evaluateWithObject:phoneNumber];
    }
    
    return NO;
}

//邮箱
+ (BOOL) validateEmail:(NSString *)email
{
    if (VALIDATE_STRING(email))
    {
        NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
        return [emailTest evaluateWithObject:email];
    }
    
    return NO;
}
//身份证号
+ (BOOL) validateIdentityCard: (NSString *)identityCard
{
    if (VALIDATE_STRING(identityCard))
    {
        BOOL flag;
        if (identityCard.length <= 0)
        {
            flag = NO;
            return flag;
        }
        NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
        NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
        return [identityCardPredicate evaluateWithObject:identityCard];
    }
    
    return NO;
}
+ (BOOL)validateBankCard: (NSString *)bankCard
{
    if (VALIDATE_STRING(bankCard))
    {
        NSString *tmpStr = [bankCard stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
        
        if(tmpStr.length > 0)
        {
            return NO;
        }
        
        return YES;
    }
    
    return NO;
}
+(NSString *)trimString:(NSString *)srcString
{
    if (VALIDATE_STRING(srcString))
    {
        srcString = [srcString stringByReplacingOccurrencesOfString:@" " withString:@""];
        srcString = [srcString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        return srcString;
    }
    
    return nil;
}
@end
