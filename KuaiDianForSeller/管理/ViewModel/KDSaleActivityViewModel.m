//
//  KDSaleActivityViewModel.m
//  KuaiDianForSeller
//
//  Created by ppnd on 16/9/7.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDSaleActivityViewModel.h"
#import "KDActivityModel.h"
#import "KDSaleActivityTableCell.h"

@interface KDSaleActivityViewModel ()

@property(nonatomic,strong)NSArray *dataSource;

@end

@implementation KDSaleActivityViewModel

-(instancetype)init
{
    self = [super init];
    if (self)
    {
        KDActivityModel *m1 = [[KDActivityModel alloc] init];
        m1.type = KDActivityTypeOfReduce;
        m1.title = @"减免";
        m1.descriptionString = @"满20减10，买的越多，减得越多";
        
        KDActivityModel *m2 = [[KDActivityModel alloc] init];
        m2.type = KDActivityTypeOfNew;
        m2.title = @"新品";
        m2.descriptionString = @"新品上市，优惠多多";
        
        KDActivityModel *m3 = [[KDActivityModel alloc] init];
        m3.type = KDActivityTypeOfPresent;
        m3.title = @"赠送";
        m3.descriptionString = @"买一送一，买的越多，送得越多";
        
        KDActivityModel *m4 = [[KDActivityModel alloc] init];
        m4.type = KDActivityTypeOfSpecialOffer;
        m4.title = @"特价";
        m4.descriptionString = @"指定商品，打五折";
        
        _dataSource = @[m1,m2,m3,m4];
    }
    return self;
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
    if (cell && indexPath)
    {
        if (_dataSource && _dataSource.count > indexPath.row)
        {
            [((KDSaleActivityTableCell *)cell) configureCellWithModel:_dataSource[indexPath.row]];
        }
    }
}
@end
