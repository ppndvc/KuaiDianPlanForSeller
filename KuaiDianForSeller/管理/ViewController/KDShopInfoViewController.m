//
//  KDRestaurantInfoViewController.m
//  KuaiDianForSeller
//
//  Created by ppnd on 16/9/11.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDShopInfoViewController.h"
#import "KDShopInfoViewModel.h"
#import "KDShopModel.h"
#import "KDCheckView.h"
#import "KDCheckViewItemModel.h"
#import "KDPickerView.h"


#define NORMAL_ROW_HEIGHT 44
#define HEADER_IMAGE_WIDTH_RATE 0.76f

static NSString *kShopInfoTableViewCellIdentifier = @"kShopInfoTableViewCellIdentifier";

@interface KDShopInfoViewController ()<UITableViewDataSource,UITableViewDelegate>

//viewmodel
@property(nonatomic,strong)KDShopInfoViewModel *viewModel;
//
@property(nonatomic,strong)JCAlertView *payView;
//
@property(nonatomic,strong)JCAlertView *openSaleView;

@property(nonatomic,strong)UIImageView *headerImageView;

@end

@implementation KDShopInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNaviBarItemWithType:KDNavigationBackToPreviousVC];
    self.navigationItem.title = RESTAURANT_INFO_TITLE;
    _viewModel = [[KDShopInfoViewModel alloc] init];

    [self setupUI];
    // Do any additional setup after loading the view from its nib.
}

-(void)setupUI
{
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    WS(ws);
    [_viewModel setFinishDownloadLogoHandler:^(UIImage *img) {
        if (img)
        {
            [ws.tableView reloadData];
        }
    }];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([KDUserManager isUserLogin])
    {
        [self startRequestShopInfo];
    }
}
-(void)startRequestShopInfo
{
    WS(ws);
    [_viewModel startRequestShopInfoWithBeginBlock:^{
        [ws showHUD];
    } completeBlock:^(BOOL isSuccess, id params, NSError *error) {
        
        [ws hideHUD];
        
        if (isSuccess)
        {
            [ws reloadTableView];
        }
        else
        {
            if (params)
            {
                [ws reloadTableView];
            }
            else
            {
                [ws showErrorPageWithCompleteBlock:^{
                    __strong __typeof(ws) strongSelf = ws;
                    [strongSelf startRequestShopInfo];
                }];
            }
        }
    }];

}
-(void)reloadTableView
{
    [_tableView reloadData];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_viewModel tableViewRowsForSection:section];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kShopInfoTableViewCellIdentifier];
   
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kShopInfoTableViewCellIdentifier];
        cell.textLabel.textColor = TEXT_HIGH_COLOR;
        cell.textLabel.font = [UIFont systemFontOfSize:TEXT_FONT_MEDIUM_SIZE];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:TEXT_FONT_MEDIUM_SIZE];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    //第一个头像cell
    if (indexPath.row == 0)
    {
        cell.accessoryView = self.headerImageView;
    }
    else
    {
        cell.accessoryView = nil;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    [_viewModel configureTableViewCell:cell indexPath:indexPath];
    
    return cell;
}
-(UIImageView *)headerImageView
{
    if (!_headerImageView)
    {
        _headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, NORMAL_ROW_HEIGHT*HEADER_IMAGE_WIDTH_RATE, NORMAL_ROW_HEIGHT*HEADER_IMAGE_WIDTH_RATE)];
        _headerImageView.layer.cornerRadius = (NORMAL_ROW_HEIGHT*HEADER_IMAGE_WIDTH_RATE)/2.0;
        _headerImageView.layer.masksToBounds = YES;
    }
    return _headerImageView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    KDShopModel *shopInfo = [_viewModel getShopInfoModel];
    switch (indexPath.row)
    {
        case 0:
        {
            NSDictionary *param = nil;
            
            if (VALIDATE_MODEL(_viewModel.getLogoImage, @"UIImage"))
            {
                param = @{VIEWCONTROLLER_IMAGE_KEY:_viewModel.getLogoImage};
            }
            
            [[KDRouterManger sharedManager] pushVCWithKey:@"KDAvatarVC" parentVC:self params:param animate:YES vcDisappearBlock:^(NSString *vcKey, id params) {
                if (params && [params isKindOfClass:[NSDictionary class]])
                {
                    shopInfo.name = [params objectForKey:COMMON_INPUT_RESULT_STRING_KEY];
                }
            }];
        }
            break;
        case 1:
        {
            WS(ws);
            [[KDRouterManger sharedManager] pushVCWithKey:@"KDCommonTextEditVC" parentVC:self params:@{COMMON_INPUT_TITLE_KEY:SHOP_NAME,COMMON_INPUT_INITSTRING_KEY:(shopInfo.name?shopInfo.name:@""),COMMON_INPUT_CHARACTER_CONSTRAIN_KEY:[NSNumber numberWithInteger:SHORT_TEXT_CHARACTER_CONSTRAIN],COMMON_INPUT_STYLE_KEY:[NSNumber numberWithInteger:KDCommonInputStyleOfSingleRow]} animate:YES vcDisappearBlock:^(NSString *vcKey, id params) {
                if (params && [params isKindOfClass:[NSDictionary class]])
                {
                    shopInfo.name = [params objectForKey:COMMON_INPUT_RESULT_STRING_KEY];
                    [ws.tableView reloadData];
                }
            }];
        }
            break;
        case 5:
        {
            [self showDatePickerWithModel:shopInfo];
        }
            break;
        case 6:
        {
            WS(ws);
            [[KDRouterManger sharedManager] pushVCWithKey:@"KDCommonTextEditVC" parentVC:self params:@{COMMON_INPUT_TITLE_KEY:SHOP_NOTICE,COMMON_INPUT_INITSTRING_KEY:(shopInfo.notice?shopInfo.notice:@""),COMMON_INPUT_CHARACTER_CONSTRAIN_KEY:[NSNumber numberWithInteger:LONG_TEXT_CHARACTER_CONSTRAIN],COMMON_INPUT_STYLE_KEY:[NSNumber numberWithInteger:KDCommonInputStyleOfMultiRows]} animate:YES vcDisappearBlock:^(NSString *vcKey, id params) {
                if (params && [params isKindOfClass:[NSDictionary class]])
                {
                    shopInfo.notice = [params objectForKey:COMMON_INPUT_RESULT_STRING_KEY];
                    [ws.tableView reloadData];
                }
            }];
        }
            break;
        case 7:
        {
            WS(ws);
            [[KDRouterManger sharedManager] pushVCWithKey:@"KDCommonTextEditVC" parentVC:self params:@{COMMON_INPUT_TITLE_KEY:SHOP_TELEPHONE,COMMON_INPUT_INITSTRING_KEY:(shopInfo.telephone?shopInfo.telephone:@""),COMMON_INPUT_CHARACTER_CONSTRAIN_KEY:[NSNumber numberWithInteger:SHORT_TEXT_CHARACTER_CONSTRAIN],COMMON_INPUT_STYLE_KEY:[NSNumber numberWithInteger:KDCommonInputStyleOfSingleRowPhoneNumber]} animate:YES vcDisappearBlock:^(NSString *vcKey, id params) {
                if (params && [params isKindOfClass:[NSDictionary class]])
                {
                    shopInfo.telephone = [params objectForKey:COMMON_INPUT_RESULT_STRING_KEY];
                    [ws.tableView reloadData];
                }
            }];
        }
            break;
        case 8:
        {
            [self ShowPayView];
        }
            break;
        case 9:
        {
            [self ShowOpenSaleView];
        }
            break;
        default:
            break;
    }

}
-(void)showDatePickerWithModel:(KDShopModel *)shopInfo
{
    KDPickerView *datePicker = [[KDPickerView alloc] initWithType:KDDatePickerTypeOfDoubleTime];
    
    WS(ws);
    JCAlertView *alertView = [[JCAlertView alloc] initWithCustomView:datePicker ButtonType:JCAlertViewButtonTypeCancel ButtonTitle:BUTTON_TITLE_CANCEL Click:^{
        
    } ButtonType:JCAlertViewButtonTypeDefault ButtonTitle:BUTTON_TITLE_SURE Click:^{
        NSArray *resultArray = [datePicker getPickerData];
        if (VALIDATE_ARRAY(resultArray))
        {
            NSDate *date1 = resultArray[0];
            NSDate *date2 = resultArray[1];
            if (VALIDATE_MODEL(date1, @"NSDate") && VALIDATE_MODEL(date2, @"NSDate"))
            {
                NSString *dateStr1 = [NSString getTimeStringWithDate:date1 formater:HH_MM_DATE_FORMATER];
                NSString *dateStr2 = [NSString getTimeStringWithDate:date2 formater:HH_MM_DATE_FORMATER];
                shopInfo.openTime = [NSString stringWithFormat:@"%@-%@",dateStr1,dateStr2];
                [ws.tableView reloadData];
            }
        }
        
    } dismissWhenTouchedBackground:YES];
    
    [alertView show];
}

-(void)ShowPayView
{
    if (!_payView)
    {
        KDCheckViewItemModel *opening = [[KDCheckViewItemModel alloc] init];
        opening.name = SHOP_OPENING_STATUS_STRING;
        opening.imageName = @"server";
        
        KDCheckViewItemModel *closed = [[KDCheckViewItemModel alloc] init];
        closed.name = SHOP_CLOSED_STATUS_STRING;
        closed.imageName = @"server";
        
        KDShopModel *shopInfo = [[KDShopManager sharedInstance] getShopInfo];
        
        if (VALIDATE_MODEL(shopInfo, @"KDShopModel"))
        {
            opening.isSelected = (shopInfo.shopStatus == KDShopOpeningStatus);
            closed.isSelected = !opening.isSelected;
        }
        
        KDCheckView *view = [[KDCheckView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 220, 80) dataSource:@[opening,closed] supportMultiSelect:NO];
        
        WS(ws);
        _payView = [[JCAlertView alloc] initWithCustomView:view ButtonType:JCAlertViewButtonTypeCancel ButtonTitle:BUTTON_TITLE_CANCEL Click:^{
            DDLogInfo(@"==============");
            
        } ButtonType:JCAlertViewButtonTypeDefault ButtonTitle:BUTTON_TITLE_SURE Click:^{
            
            KDCheckViewItemModel *selectedItem = [[view getSelectedItems] firstObject];
            
            if (VALIDATE_MODEL(selectedItem, @"KDCheckViewItemModel"))
            {
                KDShopStatus status = KDShopOpeningStatus;
                
                if ([selectedItem.name isEqualToString:SHOP_CLOSED_STATUS_STRING])
                {
                    status = KDShopClosedStatus;
                }
                else
                {
                    status = KDShopOpeningStatus;
                }
                
                [ws.viewModel changeValue:[NSNumber numberWithInteger:status] forPropety:@"shopStatus"];
                [ws.tableView reloadData];
            }
            
        } dismissWhenTouchedBackground:YES];
    }
    
    [_payView show];
}

-(void)ShowOpenSaleView
{
    if (!_openSaleView)
    {
        KDCheckViewItemModel *offline = [[KDCheckViewItemModel alloc] init];
        offline.name = SHOP_OFFLINE_PAY;
        offline.imageName = @"server";
        
        KDCheckViewItemModel *online = [[KDCheckViewItemModel alloc] init];
        online.name = SHOP_ONLINE_PAY;
        online.imageName = @"server";
        
        KDShopModel *shopInfo = [[KDShopManager sharedInstance] getShopInfo];
        
        if (VALIDATE_MODEL(shopInfo, @"KDShopModel"))
        {
            offline.isSelected = (shopInfo.payStyle == KDPayStyleOfOffline);
            online.isSelected = !offline.isSelected;
        }
        
        KDCheckView *view = [[KDCheckView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 200, 80) dataSource:@[offline,online] supportMultiSelect:NO];
        
        WS(ws);
        _openSaleView = [[JCAlertView alloc] initWithCustomView:view ButtonType:JCAlertViewButtonTypeCancel ButtonTitle:BUTTON_TITLE_CANCEL Click:^{
            DDLogInfo(@"==============");
            
        } ButtonType:JCAlertViewButtonTypeDefault ButtonTitle:BUTTON_TITLE_SURE Click:^{
            
            KDCheckViewItemModel *selectedItem = [[view getSelectedItems] firstObject];

            if (VALIDATE_MODEL(selectedItem, @"KDCheckViewItemModel"))
            {
                KDPayStyle payStyle = KDPayStyleOfOffline;
                
                if ([selectedItem.name isEqualToString:SHOP_OFFLINE_PAY])
                {
                    payStyle = KDPayStyleOfOffline;
                }
                else
                {
                    payStyle = KDPayStyleOfOnline;
                }
                
                [ws.viewModel changeValue:[NSNumber numberWithInteger:payStyle] forPropety:@"payStyle"];
                [ws.tableView reloadData];
            }
            
        } dismissWhenTouchedBackground:YES];
    }
    
    [_openSaleView show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc
{
    DDLogInfo(@"-KDShopInfoViewController dealloc");
}


@end
