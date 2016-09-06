//
//  KDUnhandleViewModel.m
//  KuaiDianForSeller
//
//  Created by ppnd on 16/8/21.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDUnhandleViewModel.h"
#import "KDOrderModel.h"
#import "KDFoodItemModel.h"
#import "KDOrderTableViewCell.h"

@interface KDUnhandleViewModel()

//数据源
@property(nonatomic,strong)NSArray *dataSource;

@end
@implementation KDUnhandleViewModel
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
        
        model.orderDetail = @[fm,fmm,ff];
        
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
        
        _dataSource = @[@[model,tttt]];
    }
    return self;
}
-(NSInteger)tableViewSections
{
    NSInteger sections = 0;
    
    if (_dataSource && _dataSource.count > 0)
    {
        sections = _dataSource.count;
    }
    return sections;
}

-(NSInteger)tableViewRowsForSection:(NSInteger)section
{
    NSInteger rows = 0;
    
    if (_dataSource && _dataSource.count > section)
    {
        NSArray *rowArray = _dataSource[section];
        if (rowArray && rowArray.count > 0)
        {
            rows = rowArray.count;
        }
    }
    return rows;
}

-(void)configureTableViewCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath
{
    if (cell && [cell isKindOfClass:[KDOrderTableViewCell class]] && indexPath)
    {
        if (_dataSource && _dataSource.count > indexPath.section)
        {
            NSArray *rowArray = _dataSource[indexPath.section];
            if (rowArray && rowArray.count > indexPath.row)
            {
                KDOrderModel *model = (KDOrderModel *)rowArray[indexPath.row];
                [((KDOrderTableViewCell *)cell) configureCellWithModel:model];
            }
        }
    }
}

-(id)tableViewModelForIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath)
    {
        if (_dataSource && _dataSource.count > indexPath.section)
        {
            NSArray *rowArray = _dataSource[indexPath.section];
            if (rowArray && rowArray.count > indexPath.row)
            {
                return rowArray[indexPath.row];
            }
        }
    }
    
    return nil;
}
@end
