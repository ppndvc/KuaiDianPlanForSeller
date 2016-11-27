//
//  KDManageViewModel.h
//  KuaiDianForSeller
//
//  Created by ppnd on 16/8/29.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDBaseViewModel.h"

@class KDSaleStatisticInfoModel;

@interface KDManageViewModel : KDBaseViewModel

-(KDSaleStatisticInfoModel *)getTodayStatisticInfo;

//请求统计信息
-(void)startRequestSaleStatisticInfoWithFromDate:(NSString *)fromDate toDate:(NSString *)toDate beginBlock:(KDViewModelBeginCallBackBlock)beginBlock completeBlock:(KDViewModelCompleteCallBackBlock)completeBlock;

@end
