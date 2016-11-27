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
#import "KDSaleStatisticInfoModel.h"

@interface KDManageViewModel()

@property(nonatomic,strong)NSArray *dataSource;

@property(nonatomic,strong)KDSaleStatisticInfoModel *todayStatisticInfo;

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

-(KDSaleStatisticInfoModel *)getTodayStatisticInfo
{
    return _todayStatisticInfo;
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
-(void)startRequestSaleStatisticInfoWithFromDate:(NSString *)fromDate toDate:(NSString *)toDate beginBlock:(KDViewModelBeginCallBackBlock)beginBlock completeBlock:(KDViewModelCompleteCallBackBlock)completeBlock
{
    if (!VALIDATE_STRING(fromDate) || !VALIDATE_STRING(toDate))
    {
        return;
    }
    
    if (beginBlock && !_todayStatisticInfo)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            beginBlock();
        });
    }
    NSDictionary *param = @{REQUEST_KEY_ORDER_START_DATE:fromDate,REQUEST_KEY_ORDER_END_DATE:toDate};
    
    WS(ws);
    [KDRequestAPI sendGetSaleStatisticInfoWithParam:param completeBlock:^(id responseObject, NSError *error) {
        
        if (error)
        {
            DDLogInfo(@"获取销售统计信息请求失败：%@",error.localizedDescription);
            
            if (completeBlock)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completeBlock(NO,nil,error);
                });
            }
        }
        else
        {
            NSArray *array = [responseObject objectForKey:RESPONSE_PAYLOAD];
            
            if (VALIDATE_ARRAY(array))
            {
                NSArray *saleArray = [NSArray yy_modelArrayWithClass:[KDSaleStatisticInfoModel class] json:array];
                
                if (VALIDATE_ARRAY(saleArray))
                {
//                    [[KDCacheManager userCache] setObject:ws.foodListArray forKey:UC_FOOD_LIST_KEY];
                    ws.todayStatisticInfo = [saleArray firstObject];
                    if (completeBlock)
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            completeBlock(YES,saleArray,nil);
                        });
                    }
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
    }];
}
@end
