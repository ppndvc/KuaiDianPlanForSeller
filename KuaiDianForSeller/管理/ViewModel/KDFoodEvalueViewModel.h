//
//  KDFoodEvalueViewModel.h
//  KuaiDianForSeller
//
//  Created by ppnd on 16/9/5.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDBaseViewModel.h"

@interface KDFoodEvalueViewModel : KDBaseViewModel

//获取model，并设置是否选中
-(id)collectionViewModelForIndexPath:(NSIndexPath *)indexPath setSelected:(BOOL)selected;

//开始请求tableview数据，带有开始和结束回调
-(void)startLoadTableDataWithBeginBlock:(KDViewModelBeginCallBackBlock)beginBlock completeBlock:(KDViewModelCompleteCallBackBlock)completeBlock;

//刷新tableview数据，带有开始和结束回调
-(void)refreshTableDataWithBeginBlock:(KDViewModelBeginCallBackBlock)beginBlock completeBlock:(KDViewModelCompleteCallBackBlock)completeBlock;

//加载tableview的下一页数据，带有开始和结束回调
-(void)loadmoreTableDataWithBeginBlock:(KDViewModelBeginCallBackBlock)beginBlock completeBlock:(KDViewModelCompleteCallBackBlock)completeBlock;

//添加回复
-(void)sendReplyWithParams:(NSDictionary *)params beginBlock:(KDViewModelBeginCallBackBlock)beginBlock completeBlock:(KDViewModelCompleteCallBackBlock)completeBlock;

//按条件过滤
-(void)filterReplyWithStarLevel:(KDEvalueStarLevel)level;

@end
