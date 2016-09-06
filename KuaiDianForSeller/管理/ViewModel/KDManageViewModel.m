//
//  KDManageViewModel.m
//  KuaiDianForSeller
//
//  Created by ppnd on 16/8/29.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDManageViewModel.h"
#import "KDActionModel.h"
#import "KDManageCollectionCell.h"

@interface KDManageViewModel()

@property(nonatomic,strong)NSArray *dataSource;

@end

@implementation KDManageViewModel
-(instancetype)init
{
    self = [super init];
    if (self)
    {
        KDActionModel *m1 = [KDActionModel new];
        m1.title = FOOD_MANAGE_TITLE;
        m1.imageName = @"edit_food_icon";
        
        KDActionModel *m2 = [KDActionModel new];
        m2.title = FOOD_EVALUE_TITLE;
        m2.imageName = @"food_evalue_icon";
        
        KDActionModel *m3 = [KDActionModel new];
        m3.title = SALE_ACTIVITY_TITLE;
        m3.imageName = @"sale_activity_icon";
        
        KDActionModel *m4 = [KDActionModel new];
        m4.title = RESTAURANT_INFO_TITLE;
        m4.imageName = @"restaurant_info_icon";
        
        _dataSource = @[m1,m2,m3,m4];
    }
    return self;
}
-(NSInteger)dataSourceCount
{
    NSInteger rows = 0;
    if (_dataSource && _dataSource.count > 0)
    {
        rows = _dataSource.count;
    }
    return rows;
}
-(NSInteger)collectionViewRowsForSection:(NSInteger)section
{
    NSInteger rows = 0;
    if (_dataSource && _dataSource.count > 0)
    {
        rows = _dataSource.count;
    }
    return rows;
}
-(void)configureCollectionViewCell:(UICollectionViewCell *)cell indexPath:(NSIndexPath *)indexPath
{
    if (cell && [cell isKindOfClass:[KDManageCollectionCell class]] && indexPath)
    {
        if (_dataSource.count > indexPath.row)
        {
            KDActionModel *model = _dataSource[indexPath.row];
            [(KDManageCollectionCell *)cell configureCellWithModel:model];
        }
    }
}

@end
