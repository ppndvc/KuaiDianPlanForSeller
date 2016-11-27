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

@property(nonatomic,strong)KDUserModel *userInfo;

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
        model4.actionString = @"push://KDChangePWDVC";
        
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
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

                switch (indexPath.section)
                {
                    case 0:
                    {
                        cell.textLabel.text = model.title;

                        if (indexPath.row == 0)
                        {
                            cell.detailTextLabel.text = [_userInfo name];
                            cell.accessoryType = UITableViewCellAccessoryNone;
                        }
                        else if (indexPath.row == 1)
                        {
                            cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f",[_userInfo money]];
                        }
                        
                    }
                        break;
                    case 1:
                    {
                        cell.textLabel.text = model.title;

                        if (indexPath.row == 0)
                        {
                            cell.detailTextLabel.text = [_userInfo telephone];
                        }
                    }
                        break;
                    case 2:
                    {
                        cell.accessoryType = UITableViewCellAccessoryNone;
                        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NORMAL_ROW_HEIGHT)];
                        label.font = [UIFont systemFontOfSize:TEXT_FONT_MEDIUM_SIZE];
                        label.textAlignment = NSTextAlignmentCenter;
                        [cell.contentView addSubview:label];
                        label.text = model.title;
                    }
                        break;
                    default:
                        break;
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

-(void)startRequestUserInfoWithBeginBlock:(KDViewModelBeginCallBackBlock)beginBlock completeBlock:(KDViewModelCompleteCallBackBlock)completeBlock
{
    if (!_userInfo)
    {
        if (beginBlock)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                beginBlock();
            });
        }
    }

    WS(ws);
    
    [KDRequestAPI sendGetUserInfoRequestWithCompleteBlock:^(id responseObject, NSError *error) {
        if (error)
        {
            DDLogInfo(@"获取用户信息请求失败：%@",error.localizedDescription);
            ws.userInfo = [[KDUserManager sharedInstance] getUserInfo];
            
            if (completeBlock)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completeBlock(NO,ws.userInfo,error);
                });
            }
        }
        else
        {
            NSDictionary *dict = [responseObject objectForKey:RESPONSE_PAYLOAD];
            
            if (VALIDATE_DICTIONARY(dict))
            {
                KDUserModel *model = [KDUserModel yy_modelWithDictionary:dict];
                ws.userInfo = model;

                if (VALIDATE_MODEL(model, @"KDUserModel"))
                {
                    [[KDUserManager sharedInstance] updateUserInfo:model];
                    
                    if (completeBlock)
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            completeBlock(YES,model,nil);
                        });
                    }
                }
                else
                {
                    ws.userInfo = [[KDUserManager sharedInstance] getUserInfo];
                    if (completeBlock)
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            completeBlock(NO,ws.userInfo,nil);
                        });
                    }
                    
                }
            }
            else
            {
                ws.userInfo = [[KDUserManager sharedInstance] getUserInfo];
                if (completeBlock)
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completeBlock(NO,ws.userInfo,nil);
                    });
                }
                
            }
        }
    }];
}
@end