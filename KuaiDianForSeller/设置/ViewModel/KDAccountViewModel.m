//
//  KDAccountViewModel.m
//  KuaiDianForSeller
//
//  Created by ppnd on 16/8/20.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDAccountViewModel.h"
#import "KDActionModel.h"
#import "KDUserManager.h"

#define IMAGE_NAME @"image_name"
#define ROW_NAME @"row_name"

#define IMAGE_WIDTH 20
#define NORMAL_ROW_HEIGHT 44

@interface KDAccountViewModel()

//数据源
@property(nonatomic,strong)NSArray *dataSource;

@end

@implementation KDAccountViewModel
-(instancetype)init
{
    self = [super init];
    if (self)
    {
        KDActionModel *model = [KDActionModel new];
        model.title = USER_NAME;
        KDActionModel *model2 = [KDActionModel new];
        model2.title = MY_MONEY; 
        model2.actionString = @"push://KDMyMoneyVC";
        KDActionModel *model3 = [KDActionModel new];
        model3.title = BIND_PHONE_NUMBER;
        model3.actionString = @"push://KDChangePhoneNumberVC";
        KDActionModel *model4 = [KDActionModel new];
        model4.title = CHANGE_PASSWORD;
        
        KDActionModel *model5 = [KDActionModel new];
        model5.title = LOGOU_CURRENT_USER;
        _dataSource = @[@[model,model2],@[model3,model4],@[model5]];
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
                
                if (indexPath.section == 1 && indexPath.row == 1)
                {
                    cell.textLabel.text = model.title;
                }
                else if (indexPath.section == 2)
                {
                    cell.accessoryType = UITableViewCellAccessoryNone;
                    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NORMAL_ROW_HEIGHT)];
                    label.font = [UIFont systemFontOfSize:TEXT_FONT_MEDIUM_SIZE];
                    label.textAlignment = NSTextAlignmentCenter;
                    [cell.contentView addSubview:label];
                    label.text = model.title;
                }
                else
                {
                    cell.textLabel.text = model.title;
                    cell.detailTextLabel.text = @"sds";
                }
            }
        }
    }
}

-(id)tableViewModelForIndexPath:(NSIndexPath *)indexPath
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

@end