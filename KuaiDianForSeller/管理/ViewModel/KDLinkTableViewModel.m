//
//  KDEditFoodViewModel.m
//  KuaiDianForSeller
//
//  Created by ppnd on 16/9/13.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDLinkTableViewModel.h"
#import "KDLeftLinkTableCell.h"
#import "KDRightLinkTableCell.h"
#import "KDFoodItemModel.h"
#import "KDFoodCategoryModel.h"


#define PLACEHOLDER_STRING (@"place_holder")
#define FOOD_SOLD @"0"

@interface KDLinkTableViewModel ()

//
@property(nonatomic,strong)NSMutableArray *leftDataSource;

//
@property(nonatomic,strong)NSMutableArray *rightDataSource;

@end

@implementation KDLinkTableViewModel

-(instancetype)init
{
    self = [super init];
    if (self)
    {
//        _leftDataSource = @[@"米饭",@"面食",@"炒菜",@"盖浇饭"];
//        KDFoodItemModel *m1 = [[KDFoodItemModel alloc] init];
//        m1.name = @"大米饭";
//        m1.price = 1.5;
//        
//        KDFoodItemModel *m2 = [[KDFoodItemModel alloc] init];
//        m2.name = @"水饺";
//        m2.price = 8.5;
//        m2.tasteType = KDTasteSour;
//        
//        KDFoodItemModel *m3 = [[KDFoodItemModel alloc] init];
//        m3.name = @"糖醋里脊";
//        m3.price = 12;
//        m3.tasteType = KDTasteSour | KDTasteSweet;
//        
//        KDFoodItemModel *m4 = [[KDFoodItemModel alloc] init];
//        m4.name = @"大米饭";
//        m4.price = 1.5;
//        
//        KDFoodItemModel *m5 = [[KDFoodItemModel alloc] init];
//        m5.name = @"水饺";
//        m5.price = 8.5;
//        
//        KDFoodItemModel *m6 = [[KDFoodItemModel alloc] init];
//        m6.name = @"糖醋里脊";
//        m6.price = 12;
//        m6.tasteType = KDTasteSweet | KDTasteSpicy;
//        
//        KDFoodItemModel *m7 = [[KDFoodItemModel alloc] init];
//        m7.name = @"大米饭";
//        m7.price = 1.5;
//        
//        KDFoodItemModel *m8 = [[KDFoodItemModel alloc] init];
//        m8.name = @"水饺";
//        m8.price = 8.5;
//        m8.tasteType = KDTasteSour;
//        
//        KDFoodItemModel *m9 = [[KDFoodItemModel alloc] init];
//        m9.name = @"糖醋里脊";
//        m9.price = 12;
//        m9.tasteType = KDTasteSour | KDTasteSweet | KDTasteSpicy;
//        _rightDataSource = @[@[m1,m2,m3,m4,m5],@[m2,m6,m7],@[m3,m8,m9]];
    }
    
    return self;
}

-(void)updateLeftTableData:(NSArray *)array
{
    if (VALIDATE_ARRAY(array))
    {
        _leftDataSource = [[NSMutableArray alloc] initWithArray:array];
        
        if (_rightDataSource)
        {
            [_rightDataSource addObject:PLACEHOLDER_STRING];
        }
        else
        {
            _rightDataSource = [[NSMutableArray alloc] initWithCapacity:_leftDataSource.count];
            for (int i = 0; i < _leftDataSource.count; i++)
            {
                [_rightDataSource addObject:PLACEHOLDER_STRING];
            }
        }
    }
}
-(void)updateRightTableData:(NSArray *)array atIndex:(NSInteger)index
{
    if (VALIDATE_ARRAY(array))
    {
        if (VALIDATE_ARRAY(_rightDataSource))
        {
            [_rightDataSource replaceObjectAtIndex:index withObject:array];
        }
    }
}
-(NSArray *)leftTableData
{
    return _leftDataSource;
}
-(NSInteger)leftTableViewRowsForSection:(NSInteger)section
{
    return [self tableViewRowsForSection:section isLeftTableView:YES];
}
-(NSInteger)rightTableViewRowsForSection:(NSInteger)section
{
    return [self tableViewRowsForSection:section isLeftTableView:NO];
}
-(NSInteger)rightTableViewSections
{
    NSInteger section = 0;
    
    if (_rightDataSource && _rightDataSource.count > 0)
    {
        for (id param in _rightDataSource)
        {
            if ([param isKindOfClass:[NSArray class]])
            {
                section ++;
            }
        }
    }
    return section;
}
-(NSInteger)tableViewRowsForSection:(NSInteger)section isLeftTableView:(BOOL)isLeftTableView
{
    NSInteger rows = 0;
    
    if (isLeftTableView)
    {
        if (_leftDataSource && _leftDataSource.count > 0)
        {
            rows = _leftDataSource.count;
        }
    }
    else
    {
        if (_rightDataSource && _rightDataSource.count > section)
        {
            NSArray *rowArray = _rightDataSource[section];
            
            if (VALIDATE_ARRAY(rowArray))
            {
                rows = rowArray.count;
            }
        }
    }
    
    return rows;
}

-(id)leftTableViewModelForIndexPath:(NSIndexPath *)indexPath
{
    if (_leftDataSource && _leftDataSource.count > indexPath.row)
    {
        return _leftDataSource[indexPath.row];
    }
    
    return nil;
}
-(void)configureLeftTableViewCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath
{
    [self configureTableViewCell:cell indexPath:indexPath isLeftTableView:YES];
}
-(void)configureRightTableViewCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath
{
    [self configureTableViewCell:cell indexPath:indexPath isLeftTableView:NO];
}
-(void)configureTableViewCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath  isLeftTableView:(BOOL)isLeftTableView
{
    if (isLeftTableView)
    {
        if (cell && _leftDataSource && _leftDataSource.count > indexPath.row)
        {
            KDFoodCategoryModel *model = _leftDataSource[indexPath.row];
            if (model && [model isKindOfClass:[KDFoodCategoryModel class]])
            {
                NSString *title = model.name;
                [((KDLeftLinkTableCell *)cell) configureCellWithTitle:title];
            }
        }
    }
    else
    {
        if (cell && _rightDataSource && _rightDataSource.count > indexPath.section)
        {
            NSArray *rowsArray = _rightDataSource[indexPath.section];
            if (rowsArray && rowsArray.count > indexPath.row)
            {
                [((KDRightLinkTableCell *)cell) configureCellWithModel:rowsArray[indexPath.row]];
            }
        }
    }
}
-(void)updateFoodCategoryWithID:(NSString *)identifier title:(NSString *)title
{
    if (VALIDATE_STRING(title))
    {
        KDFoodCategoryModel *model = [self getFoodCategoryModelWithID:identifier];
        
        if (model)
        {
            model.name = title;
            [[KDCacheManager userCache] setObject:_leftDataSource forKey:UC_FOOD_CATEGORY_KEY];
        }
    }
}
-(KDFoodCategoryModel *)getFoodCategoryModelWithID:(NSString *)identifier
{
    __block KDFoodCategoryModel *model = nil;
    if (VALIDATE_STRING(identifier) && VALIDATE_ARRAY(_leftDataSource))
    {
        [_leftDataSource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            KDFoodCategoryModel *tmp = obj;
            if ([tmp.category isEqualToString:identifier])
            {
                model = tmp;
                *stop = YES;
            }
        }];
    }
    
    return model;
}

-(void)updateFoodCategoryWithIndexPath:(NSIndexPath *)indexPath title:(NSString *)title beginBlock:(KDViewModelBeginCallBackBlock)beginBlock completeBlock:(KDViewModelCompleteCallBackBlock)completeBlock
{
    if (indexPath && _leftDataSource && _leftDataSource.count > indexPath.row)
    {
        KDFoodCategoryModel *model = _leftDataSource[indexPath.row];
        
        if (!model || !VALIDATE_STRING(model.category) || !VALIDATE_STRING(title))
        {
            if (completeBlock)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completeBlock(NO,nil,nil);
                });
            }
            return;
        }
        
        if (beginBlock)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                beginBlock();
            });
        }
        
        WS(ws);
        
        [KDRequestAPI sendModifyFoodCateTitleWithParam:@{REQUEST_KEY_ORDER_ID:model.category,REQUEST_KEY_NAME:title} completeBlock:^(id responseObject, NSError *error) {
            if (error)
            {
                DDLogInfo(@"修改食品分类信息请求失败：%@",error.localizedDescription);
                
                if (completeBlock)
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completeBlock(NO,nil,error);
                    });
                }
            }
            else
            {
                [ws updateFoodCategoryWithID:model.category title:title];
                
                if (completeBlock)
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completeBlock(YES,nil,nil);
                    });
                }
            }
        }];
    }
    else
    {
        if (completeBlock)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                completeBlock(NO,nil,nil);
            });
        }
    }
}
-(void)deleteFoodItem:(KDFoodItemModel *)foodModel beginBlock:(KDViewModelBeginCallBackBlock)beginBlock completeBlock:(KDViewModelCompleteCallBackBlock)completeBlock
{
    if (!VALIDATE_MODEL(foodModel, @"KDFoodItemModel"))
    {
        return;
    }
    
    if (!VALIDATE_STRING(foodModel.category) || !VALIDATE_STRING(foodModel.foodID))
    {
        if (completeBlock)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                completeBlock(NO,nil,nil);
            });
        }
        return;
    }
    
    if (beginBlock)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            beginBlock();
        });
    }
    
    WS(ws);
    
    [KDRequestAPI sendModifyFoodCateTitleWithParam:@{REQUEST_KEY_ORDER_ID:foodModel.foodID,REQUEST_KEY_CLASSIFY_ID:foodModel.category} completeBlock:^(id responseObject, NSError *error) {
        if (error)
        {
            DDLogInfo(@"删除食品请求失败：%@",error.localizedDescription);
            
            if (completeBlock)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completeBlock(NO,nil,error);
                });
            }
        }
        else
        {
            [ws removeModel:foodModel inArray:ws.rightDataSource];
            
            if (completeBlock)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completeBlock(YES,nil,nil);
                });
            }
        }
    }];
}
-(void)updateFoodItemRequestWithFood:(KDFoodItemModel *)foodModel beginBlock:(KDViewModelBeginCallBackBlock)beginBlock completeBlock:(KDViewModelCompleteCallBackBlock)completeBlock
{
    if (!VALIDATE_MODEL(foodModel, @"KDFoodItemModel"))
    {
        return;
    }
    
    if (beginBlock)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            beginBlock();
        });
    }
    
    WS(ws);
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    if (VALIDATE_STRING(foodModel.name))
    {
        [params setObject:foodModel.name forKey:REQUEST_KEY_NAME];
    }
    
    if (VALIDATE_STRING(foodModel.category))
    {
        [params setObject:foodModel.category forKey:REQUEST_KEY_CLASSIFY_ID];
    }
    
    if (VALIDATE_STRING(foodModel.descriptionString))
    {
        [params setObject:foodModel.descriptionString forKey:REQUEST_KEY_DESCRIPITION];
    }
    
    if (foodModel.tasteType != KDTasteNone)
    {
        [params setObject:[NSString stringWithFormat:@"%d",(int)foodModel.tasteType] forKey:REQUEST_KEY_FOOD_LABEL];
    }
    
    if (VALIDATE_STRING(foodModel.name))
    {
        [params setObject:foodModel.name forKey:REQUEST_KEY_NAME];
    }
    
    if (VALIDATE_STRING(foodModel.name))
    {
        [params setObject:foodModel.name forKey:REQUEST_KEY_NAME];
    }
    
    [params setObject:FOOD_SOLD forKey:REQUEST_KEY_FOOD_SOLD_IN_MONTH];
    [params setObject:[NSString stringWithFormat:@"%d",(int)foodModel.status] forKey:REQUEST_KEY_STATE];
    [params setObject:[NSString stringWithFormat:@"%.2f",foodModel.price] forKey:REQUEST_KEY_PRICE];
    
    [KDRequestAPI sendUpdateFoodItemWithParam:params completeBlock:^(id responseObject, NSError *error) {
        if (error)
        {
            DDLogInfo(@"更新食品请求失败：%@",error.localizedDescription);
            
            if (completeBlock)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completeBlock(NO,nil,error);
                });
            }
        }
        else
        {
            //            NSDictionary *dict = [responseObject objectForKey:RESPONSE_PAYLOAD];
            if (completeBlock)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completeBlock(YES,nil,nil);
                });
            }
        }
    }];
}
-(void)removeModel:(id)model inArray:(NSMutableArray *)array
{
    if (VALIDATE_ARRAY(array) && model)
    {
        for (NSMutableArray *tmpArray in array)
        {
            if (VALIDATE_MODEL(tmpArray, @"NSMutableArray"))
            {
                if ([tmpArray containsObject:model])
                {
                    [tmpArray removeObject:model];
                }
                else
                {
                    __block id targetModel = nil;
                    
                    [tmpArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if ([obj isKindOfClass:[KDFoodItemModel class]])
                        {
                            KDFoodItemModel *sm = obj;
                            
                            if ([sm.foodID isEqualToString:((KDFoodItemModel*)model).foodID] && [sm.category isEqualToString:((KDFoodItemModel*)model).category])
                            {
                                targetModel = sm;
                                *stop = YES;
                            }
                        }
                    }];
                    
                    if (targetModel)
                    {
                        [tmpArray removeObject:targetModel];
                    }
                }
            }
        }
        
    }
}
@end
