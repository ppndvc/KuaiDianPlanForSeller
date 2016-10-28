//
//  KDUnhandleViewModel.h
//  KuaiDianForSeller
//
//  Created by ppnd on 16/8/21.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDBaseViewModel.h"
@class KDOrderModel;

@interface KDUnhandleViewModel : KDBaseViewModel

//开始请求tableview数据，带有开始和结束回调
-(void)startLoadTableDataWithBeginBlock:(KDViewModelBeginCallBackBlock)beginBlock completeBlock:(KDViewModelCompleteCallBackBlock)completeBlock;

//刷新tableview数据，带有开始和结束回调
-(void)refreshTableDataWithBeginBlock:(KDViewModelBeginCallBackBlock)beginBlock completeBlock:(KDViewModelCompleteCallBackBlock)completeBlock;

//加载tableview的下一页数据，带有开始和结束回调
-(void)loadmoreTableDataWithBeginBlock:(KDViewModelBeginCallBackBlock)beginBlock completeBlock:(KDViewModelCompleteCallBackBlock)completeBlock;

//确认订单
-(void)confirmOrder:(KDOrderModel *)orderModel beginBlock:(KDViewModelBeginCallBackBlock)beginBlock completeBlock:(KDViewModelCompleteCallBackBlock)completeBlock;
@end
