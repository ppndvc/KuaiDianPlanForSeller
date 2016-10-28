//
//  KDSearchViewModel.m
//  KuaiDianForSeller
//
//  Created by ppnd on 16/9/25.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDSearchViewModel.h"
#import "KDOrderModel.h"
#import "KDHandleListTableCell.h"

@interface KDSearchViewModel ()

@property(nonatomic,strong) NSArray *dataSource;

@end

@implementation KDSearchViewModel
//-(instancetype)init
//{
//    self = [super init];
//    
//    if (self)
//    {
//        _dataSource = [[NSArray alloc] init];
//    }
//    
//    return  self;
//}

-(void)startSearchWithKeywords:(NSString *)keywords beginBlock:(KDViewModelBeginCallBackBlock)beginBlock completeBlock:(KDViewModelCompleteCallBackBlock)completeBlock
{
    if (VALIDATE_STRING(keywords))
    {
        if (beginBlock)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                beginBlock();
            });
        }
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:keywords forKey:REQUEST_KEY_FOOD_NAME];
        
        WS(ws);
        [KDRequestAPI sendGetOrderRequestWithParam:dict completeBlock:^(id responseObject, NSError *error) {
            if (error)
            {
                DDLogInfo(@"搜索订单请求失败：%@",error.localizedDescription);
                
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
                
                if (VALIDATE_ARRAY(array))
                {
                    ws.dataSource = [[NSArray alloc] initWithArray:array];
                    
                    if (completeBlock)
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            completeBlock(YES,[NSNumber numberWithBool:YES],nil);
                        });
                    }
                    
                }
                else
                {
                    if (completeBlock)
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            completeBlock(YES,[NSNumber numberWithBool:NO],nil);
                        });
                    }
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
    
    if (VALIDATE_ARRAY(_dataSource))
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
@end
