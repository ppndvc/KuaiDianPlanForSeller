//
//  KDHandleListViewModel.h
//  KuaiDianForSeller
//
//  Created by ppnd on 16/9/1.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDBaseViewModel.h"

@class KDOrderModel;

@interface KDHandleListViewModel : KDBaseViewModel

-(instancetype)init NS_UNAVAILABLE;
+(instancetype)new NS_UNAVAILABLE;

//推荐初始化函数
-(instancetype)initWithOrderStatus:(KDOrderStatus)orderStatus;

-(void)refreshTodayTableDataWithBeginBlock:(KDViewModelBeginCallBackBlock)beginBlock completeBlock:(KDViewModelCompleteCallBackBlock)completeBlock;

-(void)startLoadTodayTableDataWithBeginBlock:(KDViewModelBeginCallBackBlock)beginBlock completeBlock:(KDViewModelCompleteCallBackBlock)completeBlock;

-(void)loadmoreTodayTableDataWithBeginBlock:(KDViewModelBeginCallBackBlock)beginBlock completeBlock:(KDViewModelCompleteCallBackBlock)completeBlock;

-(void)refreshHistoryTableDataWithBeginBlock:(KDViewModelBeginCallBackBlock)beginBlock completeBlock:(KDViewModelCompleteCallBackBlock)completeBlock;

-(void)startLoadHistoryTableDataWithBeginBlock:(KDViewModelBeginCallBackBlock)beginBlock completeBlock:(KDViewModelCompleteCallBackBlock)completeBlock;

-(void)loadmoreHistoryTableDataWithBeginBlock:(KDViewModelBeginCallBackBlock)beginBlock completeBlock:(KDViewModelCompleteCallBackBlock)completeBlock;

-(void)confirmOrder:(KDOrderModel *)orderModel beginBlock:(KDViewModelBeginCallBackBlock)beginBlock completeBlock:(KDViewModelCompleteCallBackBlock)completeBlock;

@end
