//
//  KDBusinessStatisticsViewModel.h
//  KuaiDianForSeller
//
//  Created by ppnd on 16/11/3.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDBaseViewModel.h"

@interface KDBusinessStatisticsViewModel : KDBaseViewModel

//获取时间
-(NSString *)getStartString;
-(NSString *)getEndDateString;

//设置时间
-(void)setStartString:(NSString *)startDate;
-(void)setEndDateString:(NSString *)endDate;

//请求统计信息
-(void)startRequestSaleStatisticInfoWithBeginBlock:(KDViewModelBeginCallBackBlock)beginBlock completeBlock:(KDViewModelCompleteCallBackBlock)completeBlock;
-(void)startRequestSaleStatisticInfoWithFromDate:(NSString *)fromDate toDate:(NSString *)toDate beginBlock:(KDViewModelBeginCallBackBlock)beginBlock completeBlock:(KDViewModelCompleteCallBackBlock)completeBlock;

@end
