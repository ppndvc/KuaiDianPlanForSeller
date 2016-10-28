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
#import "KDDatePicker.h"
#import "KDCheckView.h"
#import "KDCheckViewItemModel.h"


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

@end

@implementation KDShopInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNaviBarItemWithType:KDNavigationBackToPreviousVC];
    self.navigationItem.title = RESTAURANT_INFO_TITLE;
    _viewModel = [[KDShopInfoViewModel alloc] init];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    // Do any additional setup after loading the view from its nib.
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
        UIImageView *headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, NORMAL_ROW_HEIGHT*HEADER_IMAGE_WIDTH_RATE, NORMAL_ROW_HEIGHT*HEADER_IMAGE_WIDTH_RATE)];
        cell.accessoryView = headerImageView;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    [_viewModel configureTableViewCell:cell indexPath:indexPath];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    KDShopModel *shopInfo = [_viewModel getShopInfoModel];
    switch (indexPath.row)
    {
        case 0:
        {
            [[KDRouterManger sharedManager] pushVCWithKey:@"KDAvatarVC" parentVC:self params:nil animate:YES vcDisappearBlock:^(NSString *vcKey, id params) {
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
            WS(ws);
            [KDDatePicker showDatePickerWithType:KDDatePickerTypeOfDoubleTime completeBlock:^(id date1, id date2) {
                if (date1 && date2)
                {
                    NSString *dateStr1 = [NSString getTimeStringWithDate:date1 formater:HH_MM_DATE_FORMATER];
                    NSString *dateStr2 = [NSString getTimeStringWithDate:date2 formater:HH_MM_DATE_FORMATER];
                    shopInfo.openTime = [NSString stringWithFormat:@"%@-%@",dateStr1,dateStr2];
                    [ws.tableView reloadData];
                }
            } superView:[UIApplication sharedApplication].keyWindow.rootViewController.view];
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
-(void)ShowPayView
{
    if (!_payView)
    {
        KDCheckViewItemModel *m1 = [[KDCheckViewItemModel alloc] init];
        m1.name = @"sdfed";
        m1.imageName = @"server";
        
        KDCheckViewItemModel *m2 = [[KDCheckViewItemModel alloc] init];
        m2.name = @"fssdf";
        m2.isSelected = YES;
        m2.imageName = @"server";
        
        KDCheckView *view = [[KDCheckView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 200, 80) dataSource:@[m1,m2] supportMultiSelect:NO];
        
        _payView = [[JCAlertView alloc] initWithCustomView:view ButtonType:JCAlertViewButtonTypeCancel ButtonTitle:BUTTON_TITLE_CANCEL Click:^{
            DDLogInfo(@"==============");
            
        } ButtonType:JCAlertViewButtonTypeDefault ButtonTitle:BUTTON_TITLE_SURE Click:^{
            
        } dismissWhenTouchedBackground:YES];
    }
    
    [_payView show];
}

-(void)ShowOpenSaleView
{
    if (!_openSaleView)
    {
        KDCheckViewItemModel *m1 = [[KDCheckViewItemModel alloc] init];
        m1.name = @"sdfed";
        m1.imageName = @"server";
        
        KDCheckViewItemModel *m2 = [[KDCheckViewItemModel alloc] init];
        m2.name = @"fssdf";
        m2.isSelected = YES;
        m2.imageName = @"server";
        
        KDCheckViewItemModel *m3 = [[KDCheckViewItemModel alloc] init];
        m3.name = @"sdae";
        m3.imageName = @"server";
        
        KDCheckView *view = [[KDCheckView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 200, 120) dataSource:@[m1,m2,m3] supportMultiSelect:NO];
        
        _openSaleView = [[JCAlertView alloc] initWithCustomView:view ButtonType:JCAlertViewButtonTypeCancel ButtonTitle:BUTTON_TITLE_CANCEL Click:^{
            DDLogInfo(@"==============");
            
        } ButtonType:JCAlertViewButtonTypeDefault ButtonTitle:BUTTON_TITLE_SURE Click:^{
            
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
