//
//  KDEditFoodViewModel.h
//  KuaiDianForSeller
//
//  Created by ppnd on 16/10/16.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDBaseViewModel.h"

@class KDFoodItemModel;

@interface KDEditFoodViewModel : KDBaseViewModel

//发送添加食品请求
-(void)startAddFoodItemRequestWithFood:(KDFoodItemModel *)foodModel beginBlock:(KDViewModelBeginCallBackBlock)beginBlock completeBlock:(KDViewModelCompleteCallBackBlock)completeBlock;

//更新食品请求
-(void)updateFoodItemRequestWithFood:(KDFoodItemModel *)foodModel beginBlock:(KDViewModelBeginCallBackBlock)beginBlock completeBlock:(KDViewModelCompleteCallBackBlock)completeBlock;

//上传图片
-(void)uploadImage:(UIImage *)image foodCategoryID:(NSString *)cateID beginBlock:(KDViewModelBeginCallBackBlock)beginBlock completeBlock:(KDViewModelCompleteCallBackBlock)completeBlock;

@end
