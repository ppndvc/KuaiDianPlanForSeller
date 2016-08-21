//
//  KDSettingViewModel.m
//  KuaiDianForSeller
//
//  Created by ppnd on 16/8/18.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDSettingViewModel.h"
#import "KDActionModel.h"
#import "KDUserManager.h"

#define IMAGE_NAME @"image_name"
#define ROW_NAME @"row_name"

#define IMAGE_WIDTH 20

@interface KDSettingViewModel()

//数据源
@property(nonatomic,strong)NSArray *dataSource;

@end

@implementation KDSettingViewModel
-(instancetype)init
{
    self = [super init];
    if (self)
    {
        KDActionModel *model = [KDActionModel new];
        model.title = MY_ACCOUNT;
        model.imageName = @"b27_icon_star_yellow";
        KDActionModel *model2 = [KDActionModel new];
        model2.title = CONNECT_US;
        model2.imageName = @"b27_icon_star_yellow";
        KDActionModel *model3 = [KDActionModel new];
        model3.title = FEEDBACK;
        model3.imageName = @"b27_icon_star_yellow";
        _dataSource = @[@[model],@[model2,model3]];
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
    
    if (_dataSource && _dataSource.count > section)
    {
        NSArray *rowArray = _dataSource[section];
        if (rowArray && rowArray.count > 0)
        {
            rows = rowArray.count;
        }
    }
    return rows;
}

-(void)configureTableViewCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath
{
    if (cell && indexPath)
    {
        if (_dataSource && _dataSource.count > indexPath.section)
        {
            NSArray *rowArray = _dataSource[indexPath.section];
            if (rowArray && rowArray.count > indexPath.row)
            {
                KDActionModel *model = (KDActionModel *)rowArray[indexPath.row];
                cell.imageView.image = [UIImage imageNamed:model.imageName];
                cell.textLabel.text = model.title;
                CGSize itemSize = CGSizeMake(IMAGE_WIDTH, IMAGE_WIDTH);
                UIGraphicsBeginImageContext(itemSize);
                CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
                [cell.imageView.image drawInRect:imageRect];
                cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
            }
        }
    }
}

-(KDActionModel *)tableViewActionModelForIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath)
    {
        if (_dataSource && _dataSource.count > indexPath.section)
        {
            NSArray *rowArray = _dataSource[indexPath.section];
            if (rowArray && rowArray.count > indexPath.row)
            {
                return rowArray[indexPath.row];
            }
        }
    }
    
    return nil;
}
-(KDUserModel *)getUserInfoModel
{
    return [[KDUserManager sharedInstance] getUserInfo];
}
@end
