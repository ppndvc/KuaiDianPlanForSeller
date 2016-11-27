//
//  KDFoodManageViewModel.h
//  KuaiDianForSeller
//
//  Created by ppnd on 16/10/10.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDBaseViewModel.h"

@interface KDFoodManageViewModel : KDBaseViewModel

//下载结束的回调
-(void)setFinishDownloadLogoHandler:(ImageDownloadCompletedHandler)handler;

//请求食品分类
-(void)startRequestFoodCategoryInfoWithBeginBlock:(KDViewModelBeginCallBackBlock)beginBlock completeBlock:(KDViewModelCompleteCallBackBlock)completeBlock;

//请求foodid对应的食品列表
-(void)startRequestFoodListWithID:(NSString *)foodID index:(NSInteger)index beginBlock:(KDViewModelBeginCallBackBlock)beginBlock completeBlock:(KDViewModelCompleteCallBackBlock)completeBlock;

//是否需要请求初始化数据
-(BOOL)needRequestInitData;
@end
