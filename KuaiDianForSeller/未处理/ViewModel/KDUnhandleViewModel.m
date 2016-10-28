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

#define UNFINISHED_ORDER_STATE @"0"
#define COMFIRM_ORDER_STATE @"1"
#define INIT_POSITION 1

@interface KDUnhandleViewModel()

//数据源
@property(nonatomic,strong)NSMutableArray *dataSource;

@property(nonatomic,assign)NSInteger lastPosition;

@end

@implementation KDUnhandleViewModel
-(instancetype)init
{
    self = [super init];
    if (self)
    {
        _dataSource = [[NSMutableArray alloc] init];
        _lastPosition = INIT_POSITION;
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
    
    if (_dataSource && _dataSource.count > 0)
    {
        rows = _dataSource.count;
    }
    return rows;
}

-(void)configureTableViewCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath
{
    if (cell && [cell isKindOfClass:[KDOrderTableViewCell class]] && indexPath)
    {
        if (_dataSource && _dataSource.count > indexPath.row)
        {
            KDOrderModel *model = (KDOrderModel *)_dataSource[indexPath.row];
            [((KDOrderTableViewCell *)cell) configureCellWithModel:model];
        }
    }
}

-(id)tableViewModelForIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath)
    {
        if (_dataSource && _dataSource.count > indexPath.row)
        {
            return _dataSource[indexPath.row];
        }
    }
    
    return nil;
}

#pragma mark - 网络请求

-(void)refreshTableDataWithBeginBlock:(KDViewModelBeginCallBackBlock)beginBlock completeBlock:(KDViewModelCompleteCallBackBlock)completeBlock
{
    [_dataSource removeAllObjects];
    _lastPosition = INIT_POSITION;
    [self startLoadTableDataWithBeginBlock:beginBlock completeBlock:completeBlock];
}

-(void)startLoadTableDataWithBeginBlock:(KDViewModelBeginCallBackBlock)beginBlock completeBlock:(KDViewModelCompleteCallBackBlock)completeBlock
{
    //如果本地没有数据，就去请求，否则不作处理
    if (!_dataSource || _dataSource.count <= 0)
    {
        [self startLoadTableDataWithPage:_lastPosition rowsPerPage:ROWS_PER_PAGE beginBlock:beginBlock completeBlock:completeBlock];
    }
}

-(void)loadmoreTableDataWithBeginBlock:(KDViewModelBeginCallBackBlock)beginBlock completeBlock:(KDViewModelCompleteCallBackBlock)completeBlock
{
    [self startLoadTableDataWithPage:_lastPosition rowsPerPage:ROWS_PER_PAGE beginBlock:beginBlock completeBlock:completeBlock];
}

-(void)startLoadTableDataWithPage:(NSInteger)page rowsPerPage:(NSInteger)rows beginBlock:(KDViewModelBeginCallBackBlock)beginBlock completeBlock:(KDViewModelCompleteCallBackBlock)completeBlock
{
    
    if (beginBlock)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            beginBlock();
        });
    }
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[NSNumber numberWithInteger:page] forKey:REQUEST_KEY_PAGING_PAGE];
    [dict setObject:[NSNumber numberWithInteger:rows] forKey:REQUEST_KEY_PAGING_ROWS];
    [dict setObject:UNFINISHED_ORDER_STATE forKey:REQUEST_KEY_ORDER_STATES(UNFINISHED_ORDER_STATE)];
    
    WS(ws);
    [KDRequestAPI sendGetOrderRequestWithParam:dict completeBlock:^(id responseObject, NSError *error) {
        if (error)
        {
            DDLogInfo(@"获取订单请求失败：%@",error.localizedDescription);
            
            if (completeBlock)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completeBlock(NO,nil,error);
                });
            }
        }
        else
        {
            NSArray *array = [NSArray yy_modelArrayWithClass:[KDOrderModel class] json:[responseObject objectForKey:RESPONSE_PAYLOAD]];

            if (array && [array isKindOfClass:[NSArray class]] && array.count > 0)
            {
                [ws.dataSource addObjectsFromArray:array];
                ws.lastPosition += array.count;
                
                if (completeBlock)
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completeBlock(YES,nil,nil);
                    });
                }

            }
            else
            {
                if (completeBlock)
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completeBlock(YES,nil,nil);
                    });
                }
            }
            
        }
    }];
}

-(void)confirmOrder:(KDOrderModel *)orderModel beginBlock:(KDViewModelBeginCallBackBlock)beginBlock completeBlock:(KDViewModelCompleteCallBackBlock)completeBlock
{
    if (orderModel && [orderModel isKindOfClass:[KDOrderModel class]] && VALIDATE_STRING(orderModel.orderID))
    {
        if (beginBlock)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                beginBlock();
            });
        }
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:orderModel.orderID forKey:REQUEST_KEY_ORDER_ID];
        [dict setObject:COMFIRM_ORDER_STATE forKey:REQUEST_KEY_STATE];
        
        [KDRequestAPI sendModifyOrderStatusRequestWithParam:dict completeBlock:^(id responseObject, NSError *error) {
            if (error)
            {
                DDLogInfo(@"修改订单状态失败：%@",error.localizedDescription);
                
                if (completeBlock)
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completeBlock(NO,nil,error);
                    });
                }
            }
            else
            {
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


-(void)onUserLogout
{
    [_dataSource removeAllObjects];
    _lastPosition = 0;
}
@end
