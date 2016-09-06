//
//  KDMainPageTableViewModel.m
//  KuaiDianPlan
//
//  Created by ppnd on 16/7/26.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDMainPageViewModel.h"
#import "KDShopModel.h"
#import "KDActivityModel.h"
#import "KDActionModel.h"
#import "KDShopCellTableViewCell.h"
#import "KDActionCollectionViewCell.h"
#import "KDMainPageModel.h"


@interface KDMainPageViewModel()

//主数据源
@property(nonatomic,strong)KDMainPageModel *mainModel;

//更新结束回调函数
@property(nonatomic,copy)KDMainPageUpdateCallBackBlock updateCallBackBlock;

@end

@implementation KDMainPageViewModel

-(instancetype)init
{
    self = [super init];
    if (self)
    {
        _mainModel = [[KDMainPageModel alloc] init];
    }
    return self;
}
-(void)beginUpdate
{
    NSMutableArray *tbArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < 20; i++)
    {
        
        KDShopModel *model = [[KDShopModel alloc] init];
        model.imageName = @"main_page_selected@3x";
        model.score = 4.3;
        model.address = @"这个是地址";
        model.name = [NSString stringWithFormat:@"%dXX店铺",i];
        model.minPrice = 12;
        model.salesVolume = 8888;
        model.activityPrice = 9.9;
        KDActivityModel *actModel = [KDActivityModel new];
        actModel.title = @"新用户8折";
        actModel.imageName = @"main_page_selected@3x";
        model.activityArray = @[actModel];
        
        if (i % 2 == 0)
        {
            KDActivityModel *actModel1 = [KDActivityModel new];
            actModel1.title = @"新用户8折dsdssd这要是打发而非是短发接发空间爱疯";
            actModel1.imageName = @"main_page_selected@3x";
            model.activityArray = @[actModel,actModel1];
        }
        else
        {
            KDActivityModel *actModel1 = [KDActivityModel new];
            actModel1.title = @"新用户8折dsdssd这要是打发而非是短发接发空间爱疯";
            actModel1.imageName = @"main_page_selected@3x";
            model.activityArray = @[actModel,actModel1];
            model.remainCount = 188;
            KDActivityModel *actModel2 = [KDActivityModel new];
            actModel2.title = @"新用户8折dsds888sd";
            actModel2.imageName = @"main_page_selected@3x";
            model.activityArray = @[actModel,actModel1,actModel2];
        }
        
        [tbArray addObject:model];
    }

    _mainModel.tableViewModelArray = tbArray;
    
    NSMutableArray *cvArray = [[NSMutableArray alloc] init];
//    for (int i = 0; i < 4; i++)
    {
        KDActionModel *model = [[KDActionModel alloc] init];
        model.title = @"美食";
        model.imageName = TABBAR_MANAGMENT_IMAGE_NORMAL;
        model.actionString = @"push://MallVC?type=1&title=美食";
        [cvArray addObject:model];
    }
    {
        KDActionModel *model = [[KDActionModel alloc] init];
        model.title = @"品牌馆";
        model.imageName = TABBAR_MANAGMENT_IMAGE_NORMAL;
        model.actionString = @"push://MallVC?type=2&title=品牌馆";
        [cvArray addObject:model];
    }
    {
        KDActionModel *model = [[KDActionModel alloc] init];
        model.title = @"早餐";
        model.imageName = TABBAR_MANAGMENT_IMAGE_NORMAL;
        model.actionString = @"push://MallVC?type=4&title=早餐";
        [cvArray addObject:model];
    }
    {
        KDActionModel *model = [[KDActionModel alloc] init];
        model.title = @"商城";
        model.imageName = TABBAR_MANAGMENT_IMAGE_NORMAL;
        model.actionString = @"push://MallVC?type=3&title=商城";
        [cvArray addObject:model];
    }
    
    _mainModel.collectionViewModelArray = cvArray;
    
    KDActionModel *model1 = [[KDActionModel alloc] init];
    model1.title = @"xxxx";
    model1.imageURL = @"http://img1.imgtn.bdimg.com/it/u=3995594144,3504136179&fm=206&gp=0.jpg";
    
    KDActionModel *model2 = [[KDActionModel alloc] init];
    model2.title = @"xxxx";
    model2.imageURL = @"http://pic2.ooopic.com/10/79/87/15b1OOOPIC40.jpg";
    
    _mainModel.headerViewModelArray = @[model1,model2];
    
    if (_updateCallBackBlock)
    {
        sleep(5);
        dispatch_async(dispatch_get_main_queue(), ^{
            _updateCallBackBlock(_mainModel.headerViewModelArray);
        });
    }
}

-(void)beginLoadMore
{
    
}

-(KDActionModel *)headerViewActionForIndex:(NSInteger)index
{
    KDActionModel *action = nil;
    
    if (_mainModel && _mainModel.headerViewModelArray && _mainModel.headerViewModelArray.count > index)
    {
        action = _mainModel.headerViewModelArray[index];
    }
    
    return action;
}

-(KDActionModel *)collectionViewActionForIndex:(NSInteger)index
{
    KDActionModel *action = nil;
    
    if (_mainModel && _mainModel.collectionViewModelArray && _mainModel.collectionViewModelArray.count > index)
    {
        action = _mainModel.collectionViewModelArray[index];
    }
    
    return action;
}
-(NSInteger)tableViewRowsForSection:(NSInteger)section
{
    NSInteger rows = 0;
    
    if (_mainModel && _mainModel.tableViewModelArray)
    {
        rows = _mainModel.tableViewModelArray.count;
    }
    return rows;
}

-(NSInteger)collectionViewRows
{
    NSInteger rows = 0;
    
    if (_mainModel && _mainModel.collectionViewModelArray)
    {
        rows = _mainModel.collectionViewModelArray.count;
    }
    return rows;
}


-(void)configureCollectionViewCell:(KDActionCollectionViewCell *)cell indexPath:(NSIndexPath *)indexPath
{
    if (cell && _mainModel && _mainModel.collectionViewModelArray && _mainModel.collectionViewModelArray.count > indexPath.row)
    {
        [cell configureCellWithModel:_mainModel.collectionViewModelArray[indexPath.row]];
    }
}

-(void)configureTableViewCell:(KDShopCellTableViewCell *)cell indexPath:(NSIndexPath *)indexPath
{
    if (cell && _mainModel && _mainModel.tableViewModelArray && _mainModel.tableViewModelArray.count > indexPath.row)
    {
        [cell configureCellWithModel:_mainModel.tableViewModelArray[indexPath.row]];
    }
}

-(void)updateViewWithCallBackBlock:(KDMainPageUpdateCallBackBlock)callBack
{
    if (callBack)
    {
        _updateCallBackBlock = callBack;
    }
}
@end
