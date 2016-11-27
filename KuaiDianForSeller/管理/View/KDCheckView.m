//
//  KDCheckView.m
//  KuaiDianForSeller
//
//  Created by ppnd on 16/10/23.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDCheckView.h"
#import "KDCheckViewItemModel.h"
#import "KDCheckViewCell.h"
#import "KDFoodLabelModel.h"
#import <KTCenterFlowLayout/KTCenterFlowLayout.h>

#define ITEM_WIDTH 120
#define ITEM_HEIGHT 30

@interface KDCheckView ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property(nonatomic,strong)NSArray *dataSourceArray;

@property(nonatomic,assign)BOOL supportMultiSelect;

@end

@implementation KDCheckView

-(instancetype)initWithFrame:(CGRect)frame dataSource:(NSArray *)dataSource supportMultiSelect:(BOOL)supportMultiSelect
{
//    KTCenterFlowLayout *layout = [KTCenterFlowLayout new];
//    layout.minimumInteritemSpacing = 10.f;
//    layout.minimumLineSpacing = 10.f;
    
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self)
    {
        _dataSourceArray = dataSource;
        _supportMultiSelect = supportMultiSelect;
        
        [self registerNib:[UINib nibWithNibName:@"KDCheckViewCell" bundle:nil]  forCellWithReuseIdentifier:kCheckViewCell];
        
        self.dataSource = self;
        self.delegate = self;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
#pragma mark - collection view delegate methods

//每个分区上的元素个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger rows = 0;
    
    if (VALIDATE_ARRAY(_dataSourceArray))
    {
        rows = _dataSourceArray.count;
    }
    
    return rows;
}

//设置元素内容
- (UICollectionViewCell *)collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    KDCheckViewCell *cell = (KDCheckViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:kCheckViewCell forIndexPath:indexPath];
    
    [cell sizeToFit];
    
    if (VALIDATE_ARRAY(_dataSourceArray) && _dataSourceArray.count > indexPath.row)
    {
        id model = _dataSourceArray[indexPath.row];
        [cell configureCellWithModel:model];
    }
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (VALIDATE_ARRAY(_dataSourceArray) && _dataSourceArray.count > indexPath.row)
    {
        id model = _dataSourceArray[indexPath.row];
        
        if (VALIDATE_MODEL(model, @"KDCheckViewItemModel"))
        {
            if (_supportMultiSelect)
            {
                ((KDCheckViewItemModel *)model).isSelected = !((KDCheckViewItemModel *)model).isSelected;
                [self reloadItemsAtIndexPaths:@[indexPath]];
            }
            else
            {
                ((KDCheckViewItemModel *)model).isSelected = !((KDCheckViewItemModel *)model).isSelected;

                NSArray *selectedArray = [self getSelectedItems];
                
                if (VALIDATE_ARRAY(selectedArray))
                {
                    [self reSetDataSource:NO butIndexPath:indexPath];
                    [self reloadData];
                }
                else
                {
                    ((KDCheckViewItemModel *)model).isSelected = !((KDCheckViewItemModel *)model).isSelected;
                }
            }
        }
        else if (VALIDATE_MODEL(model, @"KDFoodLabelModel"))
        {
            if (_supportMultiSelect)
            {
                ((KDFoodLabelModel *)model).isSelected = !((KDFoodLabelModel *)model).isSelected;
                [self reloadItemsAtIndexPaths:@[indexPath]];
            }
            else
            {
                ((KDFoodLabelModel *)model).isSelected = !((KDFoodLabelModel *)model).isSelected;

                NSArray *selectedArray = [self getSelectedItems];
                
                if (VALIDATE_ARRAY(selectedArray))
                {
                    [self reSetDataSource:NO butIndexPath:indexPath];
                    [self reloadData];
                }
                else
                {
                    ((KDFoodLabelModel *)model).isSelected = !((KDFoodLabelModel *)model).isSelected;
                }
            }
        }

    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.frame.size.width, ITEM_HEIGHT);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsZero;
}
-(void)reSetDataSource:(BOOL)isSelected butIndexPath:(NSIndexPath *)indexPath
{
    if (VALIDATE_ARRAY(_dataSourceArray) && indexPath)
    {
        [_dataSourceArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if (idx != indexPath.row)
            {
                if (VALIDATE_MODEL(obj, @"KDCheckViewItemModel"))
                {
                    ((KDCheckViewItemModel *)obj).isSelected = isSelected;
                }
                else if (VALIDATE_MODEL(obj, @"KDFoodLabelModel"))
                {
                    ((KDFoodLabelModel *)obj).isSelected = isSelected;
                }
            }
        }];
    }
}
-(NSArray *)getSelectedItems
{
    NSMutableArray *selectedItems = [[NSMutableArray alloc] init];
    
    if (VALIDATE_ARRAY(_dataSourceArray))
    {
        [_dataSourceArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            BOOL isSelected = NO;
            
            if (VALIDATE_MODEL(obj, @"KDCheckViewItemModel"))
            {
                isSelected = ((KDCheckViewItemModel *)obj).isSelected;
            }
            else if (VALIDATE_MODEL(obj, @"KDFoodLabelModel"))
            {
                isSelected = ((KDFoodLabelModel *)obj).isSelected;
            }
            
            if (isSelected)
            {
                [selectedItems addObject:obj];
            }
        }];
    }

    return selectedItems;
}

@end
