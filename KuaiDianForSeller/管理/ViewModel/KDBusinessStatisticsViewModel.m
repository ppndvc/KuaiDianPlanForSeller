//
//  KDBusinessStatisticsViewModel.m
//  KuaiDianForSeller
//
//  Created by ppnd on 16/11/3.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDBusinessStatisticsViewModel.h"
#import "KDSaleStatisticInfoModel.h"

#define DAYS_BEFORE 7

@interface KDBusinessStatisticsViewModel()

@property(nonatomic,strong)NSArray *statisticArray;

@property(nonatomic,strong)KDSaleStatisticInfoModel *todayStatisticInfo;

@property(nonatomic,copy)NSString *startDateString;

@property(nonatomic,copy)NSString *endDateString;

@end

@implementation KDBusinessStatisticsViewModel

-(instancetype)init
{
    self = [super init];
    if (self)
    {
//        NSTimeInterval currentDate = [[NSDate date] timeIntervalSince1970];
//        NSTimeInterval daysBeforeToday = currentDate - SECOND_PER_DAY*DAYS_BEFORE;
//        _startDateString = [NSString getTimeString:daysBeforeToday formater:YYYY_MM_DD_HH_MM_SS_DATE_FORMATER];
//        _endDateString = [NSString getTimeString:currentDate formater:YYYY_MM_DD_HH_MM_SS_DATE_FORMATER];
        
        _startDateString = @"2016-09-29 00:00:00";
        _endDateString = @"2016-10-06 23:59:59";
    }
    return self;
}
-(NSString *)getStartString
{
    return _startDateString;
}
-(NSString *)getEndDateString
{
    return _endDateString;
}
-(void)setStartString:(NSString *)startDate
{
    if (VALIDATE_STRING(startDate))
    {
        _startDateString = startDate;
    }
}
-(void)setEndDateString:(NSString *)endDate
{
    if (VALIDATE_STRING(endDate))
    {
        _endDateString = endDate;
    }
}
-(void)startRequestSaleStatisticInfoWithBeginBlock:(KDViewModelBeginCallBackBlock)beginBlock completeBlock:(KDViewModelCompleteCallBackBlock)completeBlock
{
    [self startRequestSaleStatisticInfoWithFromDate:_startDateString toDate:_endDateString beginBlock:beginBlock completeBlock:completeBlock];
}

-(void)startRequestSaleStatisticInfoWithFromDate:(NSString *)fromDate toDate:(NSString *)toDate beginBlock:(KDViewModelBeginCallBackBlock)beginBlock completeBlock:(KDViewModelCompleteCallBackBlock)completeBlock
{
    if (!VALIDATE_STRING(fromDate) || !VALIDATE_STRING(toDate))
    {
        return;
    }
    
    if (beginBlock)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            beginBlock();
        });
    }
    NSDictionary *param = @{REQUEST_KEY_ORDER_START_DATE:fromDate,REQUEST_KEY_ORDER_END_DATE:toDate};
    
    WS(ws);
    [KDRequestAPI sendGetSaleStatisticInfoWithParam:param completeBlock:^(id responseObject, NSError *error) {
        
        if (error)
        {
            DDLogInfo(@"获取销售统计信息请求失败：%@",error.localizedDescription);
            
            if (completeBlock)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completeBlock(NO,nil,error);
                });
            }
        }
        else
        {
            NSArray *array = [responseObject objectForKey:RESPONSE_PAYLOAD];
            
            if (VALIDATE_ARRAY(array))
            {
                NSArray *saleArray = [NSArray yy_modelArrayWithClass:[KDSaleStatisticInfoModel class] json:array];
                
                if (VALIDATE_ARRAY(saleArray))
                {
                    //                    [[KDCacheManager userCache] setObject:ws.foodListArray forKey:UC_FOOD_LIST_KEY];
                    ws.statisticArray = saleArray;
                    if (completeBlock)
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            completeBlock(YES,saleArray,nil);
                        });
                    }
                }
                else
                {
                    if (completeBlock)
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            completeBlock(NO,nil,nil);
                        });
                    }
                }
                
            }
            else
            {
                if (completeBlock)
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completeBlock(NO,nil,nil);
                    });
                }
            }
        }
    }];
}
@end
