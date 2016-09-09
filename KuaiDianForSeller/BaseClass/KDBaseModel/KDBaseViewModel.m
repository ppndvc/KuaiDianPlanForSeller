//
//  KDBaseViewModel.m
//  KuaiDianForSeller
//
//  Created by ppnd on 16/8/21.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDBaseViewModel.h"
#import "KDUserManager.h"

@implementation KDBaseViewModel

-(NSInteger)dataSourceCount
{
    //子类实现
    return 0;
}

-(NSInteger)tableViewSections
{
    //子类实现
    return 0;
}

-(NSInteger)tableViewRowsForSection:(NSInteger)section
{
    //子类实现
    return 0;
}

-(void)configureTableViewCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath
{
    //子类实现
}

-(id)tableViewModelForIndexPath:(NSIndexPath *)indexPath
{
    //子类实现
    return nil;
}
-(id)collectionViewModelForIndexPath:(NSIndexPath *)indexPath
{
    //子类实现
    return nil;
}
-(NSInteger)collectionViewRowsForSection:(NSInteger)section
{
    //子类实现
    return 0;
}
-(void)configureCollectionViewCell:(UICollectionViewCell *)cell indexPath:(NSIndexPath *)indexPath
{
    //子类实现
}

-(KDUserModel *)getUserInfoModel
{
    return [[KDUserManager sharedInstance] getUserInfo];
}
@end
