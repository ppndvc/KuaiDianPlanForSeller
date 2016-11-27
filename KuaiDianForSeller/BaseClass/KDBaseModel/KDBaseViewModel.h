//
//  KDBaseViewModel.h
//  KuaiDianForSeller
//
//  Created by ppnd on 16/8/21.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDBaseModel.h"
#import "KDRequestAPI.h"
#import "KDActionModel.h"

@class KDUserModel;

@interface KDBaseViewModel : KDBaseModel

//数据源包含个数
-(NSInteger)dataSourceCount;

//section数目
-(NSInteger)tableViewSections;

//section对应的行数
-(NSInteger)tableViewRowsForSection:(NSInteger)section;

//获取所有数据
-(NSArray *)getAllTableData;

//配置对应行的cell
-(void)configureTableViewCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath;

//collectionview的行数
-(NSInteger)collectionViewRowsForSection:(NSInteger)section;

//配置collctioncell
-(void)configureCollectionViewCell:(UICollectionViewCell *)cell indexPath:(NSIndexPath *)indexPath;

//获取对应航的model
-(id)tableViewModelForIndexPath:(NSIndexPath *)indexPath;
//获取对应航的model
-(id)collectionViewModelForIndexPath:(NSIndexPath *)indexPath;


//刷新加载
-(void)refreshTableDataWithBeginBlock:(KDViewModelBeginCallBackBlock)beginBlock completeBlock:(KDViewModelCompleteCallBackBlock)completeBlock;

//开始加载数据
-(void)startLoadTableDataWithBeginBlock:(KDViewModelBeginCallBackBlock)beginBlock completeBlock:(KDViewModelCompleteCallBackBlock)completeBlock;

//加载更多
-(void)loadmoreTableDataWithBeginBlock:(KDViewModelBeginCallBackBlock)beginBlock completeBlock:(KDViewModelCompleteCallBackBlock)completeBlock;

//获取用户信息
-(KDUserModel *)getUserInfoModel;

@end
