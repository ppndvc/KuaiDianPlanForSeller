//
//  KDSetFoodLabelViewModel.m
//  KuaiDianForSeller
//
//  Created by ppnd on 16/10/15.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDSetFoodLabelViewModel.h"
#import "KDCheckViewCell.h"
#import "KDFoodLabelModel.h"

@interface KDSetFoodLabelViewModel ()

//数据源
@property(nonatomic,strong)NSArray *dataSource;

@end

@implementation KDSetFoodLabelViewModel
-(instancetype)init
{
    self = [super init];
    if (self)
    {
        KDFoodLabelModel *m1 = [[KDFoodLabelModel alloc] init];
        m1.name = FOOD_TASTE_SOUR;
        m1.tasteType = KDTasteSour;
        m1.isSelected = NO;
        
        KDFoodLabelModel *m2 = [[KDFoodLabelModel alloc] init];
        m2.name = FOOD_TASTE_SWEET;
        m2.tasteType = KDTasteSweet;
        m2.isSelected = NO;
        
        KDFoodLabelModel *m3 = [[KDFoodLabelModel alloc] init];
        m3.name = FOOD_TASTE_HOT;
        m3.tasteType = KDTasteHot;
        m3.isSelected = NO;
        
        KDFoodLabelModel *m4 = [[KDFoodLabelModel alloc] init];
        m4.name = FOOD_TASTE_SPICY;
        m4.tasteType = KDTasteSpicy;
        m4.isSelected = NO;
        
        _dataSource = @[m1,m2,m3,m4];
    }
    return self;
}
-(void)setModelSelectWithTasteType:(KDTasteType)type
{
    if (VALIDATE_ARRAY(_dataSource) && type != KDTasteNone)
    {
        [_dataSource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            KDFoodLabelModel *model = obj;
            model.isSelected = (model.tasteType & type);
        }];
    }
}
-(KDTasteType)getSelectedTaste
{
    __block KDTasteType type = KDTasteNone;
    
    if (VALIDATE_ARRAY(_dataSource))
    {
        [_dataSource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            KDFoodLabelModel *model = obj;
            if (model.isSelected)
            {
                if (type == KDTasteNone)
                {
                    type = model.tasteType;
                }
                else
                {
                    type = (type | model.tasteType);
                }
            }
        }];
    }
    
    return type;
}
-(id)collectionViewModelForIndexPath:(NSIndexPath *)indexPath
{
    if (VALIDATE_ARRAY(_dataSource) && _dataSource.count > indexPath.row)
    {
        return _dataSource[indexPath.row];
    }
    else
    {
        return nil;
    }
}
-(NSInteger)collectionViewRowsForSection:(NSInteger)section
{
    NSInteger rows = 0;
    
    if (VALIDATE_ARRAY(_dataSource))
    {
        rows = _dataSource.count;
    }
    
    return rows;
}
-(void)configureCollectionViewCell:(UICollectionViewCell *)cell indexPath:(NSIndexPath *)indexPath
{
    //子类实现
    if (cell && VALIDATE_ARRAY(_dataSource) && _dataSource.count > indexPath.row)
    {
        [((KDCheckViewCell *)cell) configureCellWithModel:_dataSource[indexPath.row]];;
    }
}

-(NSArray *)getAllTableData
{
    return _dataSource;
}
@end
