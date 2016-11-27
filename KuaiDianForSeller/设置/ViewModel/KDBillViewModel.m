//
//  KDBillViewModel.m
//  KuaiDianForSeller
//
//  Created by ppnd on 16/11/13.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDBillViewModel.h"
#import "KDBillTableCell.h"
#import "KDBillModel.h"

#define INIT_POSITION 1
#define PAGE @"page"
#define ROWS @"rows"


@interface KDBillViewModel ()

@property(nonatomic,strong)NSMutableArray *dataSource;

@property(nonatomic,assign)NSInteger lastPosition;

@property(nonatomic,assign)KDEvalueStarLevel currentFilterLevel;

@end
@implementation KDBillViewModel

-(NSInteger)tableViewRowsForSection:(NSInteger)section
{
    NSInteger rows = 0;
    if (VALIDATE_ARRAY(_dataSource))
    {
        rows = _dataSource.count;
    }
    return rows;
}

-(void)configureTableViewCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath
{
    if (cell && indexPath)
    {
        if (_dataSource && _dataSource.count > indexPath.row)
        {
            [((KDBillTableCell *)cell) configureCellWithModel:_dataSource[indexPath.row]];
        }
    }
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
    [dict setObject:[NSNumber numberWithInteger:page] forKey:PAGE];
    [dict setObject:[NSNumber numberWithInteger:rows] forKey:ROWS];
    
    WS(ws);
    
    /*
     
     */
    
    [KDRequestAPI sendGetBillDetailRequestWithParam:dict completeBlock:^(id responseObject, NSError *error) {
        
        __strong __typeof(ws) ss = ws;
        if (error)
        {
            DDLogInfo(@"获取账单信息请求失败：%@",error.localizedDescription);
            
            if (completeBlock)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completeBlock(NO,nil,error);
                });
            }
        }
        else
        {
            NSArray *array = [NSArray yy_modelArrayWithClass:[KDBillModel class] json:[responseObject objectForKey:RESPONSE_PAYLOAD]];
            
            if (array && [array isKindOfClass:[NSArray class]] && array.count > 0)
            {
                [ss.dataSource addObjectsFromArray:array];
                ss.lastPosition += array.count;
                
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

-(void)sendReplyWithParams:(NSDictionary *)params beginBlock:(KDViewModelBeginCallBackBlock)beginBlock completeBlock:(KDViewModelCompleteCallBackBlock)completeBlock
{
    
    if (beginBlock)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            beginBlock();
        });
    }
    
    [KDRequestAPI sendAddReplyRequestWithParam:params completeBlock:^(id responseObject, NSError *error) {
        if (error)
        {
            DDLogInfo(@"添加回复请求失败：%@",error.localizedDescription);
            
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

@end
