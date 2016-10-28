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

#define INIT_POSITION 1
#define COMFIRM_ORDER_STATE @"3"

@interface KDHandleListViewModel()

@property(nonatomic,strong)NSMutableArray *dataSource;

@property(nonatomic,assign)NSInteger lastPosition;

@property(nonatomic,assign)KDOrderStatus orderStatus;

@end

@implementation KDHandleListViewModel

-(instancetype)initWithOrderStatus:(KDOrderStatus)orderStatus
{
    self = [super init];
    if (self)
    {
        _dataSource = [[NSMutableArray alloc] init];
        _lastPosition = INIT_POSITION;
        _orderStatus = orderStatus;
    }
    
    return self;
}
-(void)refreshTodayTableDataWithBeginBlock:(KDViewModelBeginCallBackBlock)beginBlock completeBlock:(KDViewModelCompleteCallBackBlock)completeBlock
{
    [_dataSource removeAllObjects];
    _lastPosition = INIT_POSITION;
    [self startLoadTodayTableDataWithBeginBlock:beginBlock completeBlock:completeBlock];
}

-(void)startLoadTodayTableDataWithBeginBlock:(KDViewModelBeginCallBackBlock)beginBlock completeBlock:(KDViewModelCompleteCallBackBlock)completeBlock
{
    //如果本地没有数据，就去请求，否则不作处理
    if (!_dataSource || _dataSource.count <= 0)
    {
        [self startLoadTableDataWithPage:_lastPosition rowsPerPage:ROWS_PER_PAGE startDate:[NSString getTodayStartDateString] endDate:[NSString getCurrentDateString] beginBlock:beginBlock completeBlock:completeBlock];
    }
}

-(void)loadmoreTodayTableDataWithBeginBlock:(KDViewModelBeginCallBackBlock)beginBlock completeBlock:(KDViewModelCompleteCallBackBlock)completeBlock
{
    [self startLoadTableDataWithPage:_lastPosition rowsPerPage:ROWS_PER_PAGE startDate:[NSString getTodayStartDateString] endDate:[NSString getCurrentDateString] beginBlock:beginBlock completeBlock:completeBlock];
}

-(void)refreshHistoryTableDataWithBeginBlock:(KDViewModelBeginCallBackBlock)beginBlock completeBlock:(KDViewModelCompleteCallBackBlock)completeBlock
{
    [_dataSource removeAllObjects];
    _lastPosition = 0;
    [self startLoadHistoryTableDataWithBeginBlock:beginBlock completeBlock:completeBlock];
}

-(void)startLoadHistoryTableDataWithBeginBlock:(KDViewModelBeginCallBackBlock)beginBlock completeBlock:(KDViewModelCompleteCallBackBlock)completeBlock
{
    //如果本地没有数据，就去请求，否则不作处理
    if (!_dataSource || _dataSource.count <= 0)
    {
        [self startLoadTableDataWithPage:_lastPosition rowsPerPage:ROWS_PER_PAGE startDate:[NSString getInitDateString] endDate:[NSString getCurrentDateString] beginBlock:beginBlock completeBlock:completeBlock];
    }
}

-(void)loadmoreHistoryTableDataWithBeginBlock:(KDViewModelBeginCallBackBlock)beginBlock completeBlock:(KDViewModelCompleteCallBackBlock)completeBlock
{
    [self startLoadTableDataWithPage:_lastPosition rowsPerPage:ROWS_PER_PAGE startDate:[NSString getInitDateString] endDate:[NSString getCurrentDateString] beginBlock:beginBlock completeBlock:completeBlock];
}

-(void)startLoadTableDataWithPage:(NSInteger)page rowsPerPage:(NSInteger)rows startDate:(NSString *)startDate endDate:(NSString *)endDate beginBlock:(KDViewModelBeginCallBackBlock)beginBlock completeBlock:(KDViewModelCompleteCallBackBlock)completeBlock
{
    if (beginBlock)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            beginBlock();
        });
    }
    
    NSString *status = [NSString stringWithFormat:@"%d",(int)_orderStatus];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[NSNumber numberWithInteger:page] forKey:REQUEST_KEY_PAGING_PAGE];
    [dict setObject:[NSNumber numberWithInteger:rows] forKey:REQUEST_KEY_PAGING_ROWS];
    [dict setObject:status forKey:REQUEST_KEY_ORDER_STATES(status)];
    
    if (VALIDATE_STRING(startDate) && VALIDATE_STRING(endDate))
    {
        [dict setObject:@"2016-08-13 08:00:34" forKey:REQUEST_KEY_ORDER_START_DATE];
        [dict setObject:@"2016-08-21 08:00:34" forKey:REQUEST_KEY_ORDER_END_DATE];
    }
    
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
        if (_dataSource && _dataSource.count > indexPath.row)
        {
            KDOrderModel *model = _dataSource[indexPath.row];
            [((KDHandleListTableCell *)cell) configureCellWithModel:model];
        }
    }
}
-(void)onUserLogout
{
    [_dataSource removeAllObjects];
    _lastPosition = 0;
}
@end
