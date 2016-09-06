//
//  KDHandleListViewModel.h
//  KuaiDianForSeller
//
//  Created by ppnd on 16/9/1.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDBaseViewModel.h"

@interface KDHandleListViewModel : KDBaseViewModel

//开始请求tableview数据，带有开始和结束回调
-(void)startLoadTableDataWithPage:(NSInteger)page rowsPerPage:(NSInteger)rows beginBlock:(KDViewModelBeginCallBackBlock)beginBlock completeBlock:(KDViewModelCompleteCallBackBlock)completeBlock;
@end
