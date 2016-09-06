//
//  KDMainPageTableViewModel.h
//  KuaiDianPlan
//
//  Created by ppnd on 16/7/26.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDBaseViewModel.h"
@class KDShopCellTableViewCell;
@class KDActionCollectionViewCell;
@class KDActionModel;

@interface KDMainPageViewModel : KDBaseViewModel

//开始更新
-(void)beginUpdate;

//开始加载更多
-(void)beginLoadMore;

//获取headerview对应的动作
-(KDActionModel *)headerViewActionForIndex:(NSInteger)index;

//section对应的行数
-(NSInteger)tableViewRowsForSection:(NSInteger)section;

//配置对应行的cell
-(void)configureTableViewCell:(KDShopCellTableViewCell *)cell indexPath:(NSIndexPath *)indexPath;

//section对应行数
-(NSInteger)collectionViewRows;

//获取collectionview对应的动作
-(KDActionModel *)collectionViewActionForIndex:(NSInteger)index;

//配置cell
-(void)configureCollectionViewCell:(KDActionCollectionViewCell *)cell indexPath:(NSIndexPath *)indexPath;

//更新tableview
-(void)updateViewWithCallBackBlock:(KDMainPageUpdateCallBackBlock)callBack;

@end
