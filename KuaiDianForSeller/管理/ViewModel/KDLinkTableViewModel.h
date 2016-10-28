//
//  KDEditFoodViewModel.h
//  KuaiDianForSeller
//
//  Created by ppnd on 16/9/13.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDBaseViewModel.h"

@class KDFoodItemModel;

@interface KDLinkTableViewModel : KDBaseViewModel

//修改食品分类
-(void)updateFoodCategoryWithIndexPath:(NSIndexPath *)indexPath title:(NSString *)title beginBlock:(KDViewModelBeginCallBackBlock)beginBlock completeBlock:(KDViewModelCompleteCallBackBlock)completeBlock;
//删除食品
-(void)deleteFoodItem:(KDFoodItemModel *)foodModel beginBlock:(KDViewModelBeginCallBackBlock)beginBlock completeBlock:(KDViewModelCompleteCallBackBlock)completeBlock;
//更改食品状态
-(void)updateFoodItemRequestWithFood:(KDFoodItemModel *)foodModel beginBlock:(KDViewModelBeginCallBackBlock)beginBlock completeBlock:(KDViewModelCompleteCallBackBlock)completeBlock;

//更新数据源
-(void)updateLeftTableData:(NSArray *)array;
-(void)updateRightTableData:(NSArray *)array atIndex:(NSInteger)index;

-(NSArray *)leftTableData;

//行数
-(NSInteger)leftTableViewRowsForSection:(NSInteger)section;
-(NSInteger)rightTableViewRowsForSection:(NSInteger)section;

-(NSInteger)rightTableViewSections;

//获取左侧cell的model
-(id)leftTableViewModelForIndexPath:(NSIndexPath *)indexPath;

//配置cell
-(void)configureLeftTableViewCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath;
-(void)configureRightTableViewCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath;

@end
