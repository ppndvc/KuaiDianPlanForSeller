//
//  KDHandleListViewModel.m
//  KuaiDianForSeller
//
//  Created by ppnd on 16/9/1.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDHandleListViewModel.h"
#import "KDHandleListTableCell.h"
#import "KDOrderModel.h"

@interface KDHandleListViewModel()

@property(nonatomic,strong)NSMutableArray *dataSource;

@end

@implementation KDHandleListViewModel

-(instancetype)init
{
    self = [super init];
    if (self)
    {
        KDOrderModel *model = [KDOrderModel new];
        model.orderID = @"66";
        model.orderDescriptionString = @"多放点葱和咸菜。";
        model.totalPrice = 28.00;
        model.createTime = 1471786323;
        model.startTime = 1471786923;
        model.overTime = 1471789323;
        model.phoneNumber = @"13888888888";
        model.pickUpCode = @"123456";
        model.isPayed = YES;
        
        KDFoodItemModel *fm = [KDFoodItemModel new];
        fm.name = @"蛋炒饭";
        fm.price = 12.0;
        fm.quantity = 1;
        
        KDFoodItemModel *fmm = [KDFoodItemModel new];
        fmm.name = @"水煮肥牛";
        fmm.price = 18.0;
        fmm.quantity = 1;
        
        KDFoodItemModel *ff = [KDFoodItemModel new];
        ff.name = @"黄焖鸡米饭";
        ff.price = 18.0;
        ff.quantity = 1;
        
        KDFoodItemModel *ffd = [KDFoodItemModel new];
        ffd.name = @"黄焖鸡米饭";
        ffd.price = 18.0;
        ffd.quantity = 1;
        
        KDFoodItemModel *ffs = [KDFoodItemModel new];
        ffs.name = @"黄焖鸡米饭";
        ffs.price = 18.0;
        ffs.quantity = 1;
        
        model.orderDetail = @[fm,fmm,ff,ffd,ffs];
        
        KDOrderModel *tttt = [KDOrderModel new];
        tttt.orderID = @"66";
        tttt.orderDescriptionString = @"多放点葱和咸菜sdfad。";
        tttt.totalPrice = 28.00;
        tttt.createTime = 1471786323;
        tttt.startTime = 1471786923;
        tttt.overTime = 1471789323;
        tttt.phoneNumber = @"13634765616";
        tttt.pickUpCode = @"123456";
        tttt.isPayed = YES;
        
        tttt.orderDetail = @[fm,fmm];
        
        _dataSource = @[model,tttt];
        
    }
    
    return self;
}

-(void)startLoadTableDataWithPage:(NSInteger)page rowsPerPage:(NSInteger)rows beginBlock:(KDViewModelBeginCallBackBlock)beginBlock completeBlock:(KDViewModelCompleteCallBackBlock)completeBlock
{
    //如果是page = 0，而且本地的datasource里面不为空，表示用户不是第一次切换scrollview，不需要请求数据
//    if(page == 0)
//    {
//        if (_dataSource && _dataSource.count > 0)
//        {
//            return;
//        }
//    }
//    
    
    if (beginBlock)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            beginBlock();
        });
    }
    if (completeBlock)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            completeBlock(YES,nil,nil);
        });
    }
}
-(NSInteger)tableViewRowsForSection:(NSInteger)section
{
    NSInteger rows = 0;
    if (_dataSource && _dataSource.count > 0)
    {
        rows = _dataSource.count;
    }
    return rows;
}
-(id)tableViewModelForIndexPath:(NSIndexPath *)indexPath
{
    if (_dataSource && _dataSource.count > indexPath.row)
    {
        return _dataSource[indexPath.row];
    }
    return nil;
}
-(void)configureTableViewCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath
{
    if (cell && indexPath)
    {
        if (_dataSource.count > indexPath.row)
        {
            KDOrderModel *model = _dataSource[indexPath.row];
            [((KDHandleListTableCell *)cell) configureCellWithModel:model];
        }
    }
}
@end
