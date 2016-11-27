//
//  KDFoodEvalueViewModel.m
//  KuaiDianForSeller
//
//  Created by ppnd on 16/9/5.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDFoodEvalueViewModel.h"
#import "KDCustomerReplyModel.h"
#import "KDEvalueTableCell.h"
#import "KDEvalueFilterCollectionCell.h"
#import "KDEvalueFilterItemModel.h"

#define INIT_POSITION 1
#define PAGE @"page"
#define ROWS @"rows"


@interface KDFoodEvalueViewModel ()

@property(nonatomic,strong)NSMutableArray *dataSource;

@property(nonatomic,strong)NSArray *collectionViewDataSource;

@property(nonatomic,assign)NSInteger lastPosition;

@property(nonatomic,strong)NSMutableArray *showDataSource;

@property(nonatomic,assign)KDEvalueStarLevel currentFilterLevel;

@end

@implementation KDFoodEvalueViewModel

-(instancetype)init
{
    self = [super init];
    if (self)
    {
        _dataSource = [NSMutableArray new];
        _showDataSource = [NSMutableArray new];
        _currentFilterLevel = KDNoneSpecific;
        _lastPosition = INIT_POSITION;
        
        KDEvalueFilterItemModel *m1 = [[KDEvalueFilterItemModel alloc] init];
        m1.title = @"一星";
        m1.level = KDOneStar;
        
        KDEvalueFilterItemModel *m2 = [[KDEvalueFilterItemModel alloc] init];
        m2.title = @"二星";
        m2.level = KDTwoStar;
        
        KDEvalueFilterItemModel *m3 = [[KDEvalueFilterItemModel alloc] init];
        m3.title = @"三星";
        m3.level = KDThreeStar;
        
        KDEvalueFilterItemModel *m4 = [[KDEvalueFilterItemModel alloc] init];
        m4.title = @"四星";
        m4.level = KDFourStar;
        
        KDEvalueFilterItemModel *m5 = [[KDEvalueFilterItemModel alloc] init];
        m5.title = @"五星";
        m5.level = KDFiveStar;
        
        KDEvalueFilterItemModel *m6 = [[KDEvalueFilterItemModel alloc] init];
        m6.title = @"全部";
        m6.level = KDNoneSpecific;
        m6.isSelected = YES;
        
        _collectionViewDataSource = @[m6,m1,m2,m3,m4,m5];
    }
    
    return self;
}

-(NSInteger)tableViewRowsForSection:(NSInteger)section
{
    NSInteger rows = 0;
    if (_showDataSource && _showDataSource.count > 0)
    {
        rows = _showDataSource.count;
    }
    return rows;
}

-(void)configureTableViewCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath
{
    if (cell && indexPath)
    {
        if (_showDataSource && _showDataSource.count > indexPath.row)
        {
            [((KDEvalueTableCell *)cell) configureCellWithModel:_showDataSource[indexPath.row]];
        }
    }
}
-(id)collectionViewModelForIndexPath:(NSIndexPath *)indexPath
{
    if (_collectionViewDataSource && _collectionViewDataSource.count > indexPath.row)
    {
        return _collectionViewDataSource[indexPath.row];
    }
    return nil;
}
-(id)collectionViewModelForIndexPath:(NSIndexPath *)indexPath setSelected:(BOOL)selected
{
    if (_collectionViewDataSource && _collectionViewDataSource.count > indexPath.row)
    {
        [_collectionViewDataSource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            KDEvalueFilterItemModel *m = obj;
            m.isSelected = NO;
        }];
        
        KDEvalueFilterItemModel *model = _collectionViewDataSource[indexPath.row];
        model.isSelected = selected;
        return model;
    }
    return nil;
}

-(NSInteger)collectionViewRowsForSection:(NSInteger)section
{
    NSInteger rows = 0;
    if (_collectionViewDataSource && _collectionViewDataSource.count > 0)
    {
        rows = _collectionViewDataSource.count;
    }
    return rows;
}
-(void)configureCollectionViewCell:(UICollectionViewCell *)cell indexPath:(NSIndexPath *)indexPath
{
    if (cell && indexPath)
    {
        if (_collectionViewDataSource && _collectionViewDataSource.count > indexPath.row)
        {
            KDEvalueFilterItemModel *model = _collectionViewDataSource[indexPath.row];
            [((KDEvalueFilterCollectionCell *)cell) configureCellWithModel:model];
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
     {
     anonymous = 1;
     content = "\U95f2\U6765\U901b\U901b\U3002";
     createtime = 1474550040000;
     customerid = 1;
     customername = "\U8363";
     id = 7;
     level = 2;
     replies =             (
     {
     content = "\U4f7f\U52b2\U52a0\U6cb9";
     createtime = 1475354559000;
     evaluateid = 7;
     id = 23;
     sellerid = 13;
     }
     );
     storeid = 1;
     storename = "\U725b\U8089\U9762\U9986";
     }
     */

    [KDRequestAPI sendGetFoodEvalueInfoWithParam:dict completeBlock:^(id responseObject, NSError *error) {
       
        __strong __typeof(ws) ss = ws;
        if (error)
        {
            DDLogInfo(@"获取食品评价信息请求失败：%@",error.localizedDescription);
            
            if (completeBlock)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completeBlock(NO,nil,error);
                });
            }
        }
        else
        {
            NSArray *array = [NSArray yy_modelArrayWithClass:[KDCustomerReplyModel class] json:[responseObject objectForKey:RESPONSE_PAYLOAD]];
            
            if (array && [array isKindOfClass:[NSArray class]] && array.count > 0)
            {
                [ss.dataSource addObjectsFromArray:array];
                ss.lastPosition += array.count;
                ss.showDataSource = [ss getFilterdDataArrayWithLevel:ss.currentFilterLevel];
                
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

-(void)filterReplyWithStarLevel:(KDEvalueStarLevel)level
{
    if (level >= KDOneStar && level <= KDNoneSpecific)
    {
        if (level != _currentFilterLevel)
        {
            _currentFilterLevel = level;
            _showDataSource = [self getFilterdDataArrayWithLevel:level];
        }
    }
}
-(NSMutableArray *)getFilterdDataArrayWithLevel:(KDEvalueStarLevel)level
{
    NSMutableArray *newArray = [[NSMutableArray alloc] init];
    
    if (level >= KDOneStar && level <= KDNoneSpecific && VALIDATE_ARRAY(_dataSource))
    {
        if (level == KDNoneSpecific)
        {
            newArray = _dataSource;
        }
        else
        {
            NSPredicate *pre = [NSPredicate predicateWithFormat:@"score == %d",(int)level];
            newArray = [[NSMutableArray alloc] initWithArray:[_dataSource filteredArrayUsingPredicate:pre]];
        }
    }
    return newArray;
}
@end
