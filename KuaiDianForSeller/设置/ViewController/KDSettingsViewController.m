//
//  KDSettingsViewController.m
//  KuaiDianForSeller
//
//  Created by ppnd on 16/8/18.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDSettingsViewController.h"
#import "KDSettingViewModel.h"
#import "KDPayBrandView.h"
#import "KDUserModel.h"
#import "KDActionModel.h"
#import "JMActionSheet.h"

#define IMAGEVIEW_HEIGHT 60
#define PAYVIEW_HEIGHT 50
#define VERTICAL_PADDING 10

#define NO_BANK_CARD_TITLE @"点击添加"

@interface KDSettingsViewController ()<UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate,KDPayBrandViewDelegate>

//viewmodel
@property(nonatomic,strong)KDSettingViewModel *viewModel;

//imageView
@property(nonatomic,strong)UIImageView *imageView;

//namelabel
@property(nonatomic,strong)UILabel *nameLabel;

//银行卡label
@property(nonatomic,strong)KDPayBrandView *payView;

//红色背景view
@property(nonatomic,strong)UIView *bgRedView;

@end

@implementation KDSettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _viewModel = [KDSettingViewModel new];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [self setupUI];
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
    KDShopModel *shopModel = [[KDShopManager sharedInstance] getShopInfo];
    
    [_viewModel startRequestShopInfoWithBeginBlock:^{
        if (!shopModel)
        {
            [ws showHUD];
        }
    } completeBlock:^(BOOL isSuccess, id params, NSError *error) {
        
        [ws startRequestBankInfoWithCompleteBlock:^(BOOL isSuccess, id params, NSError *error) {
            
            __strong __typeof(ws) ss = ws;
            if (isSuccess)
            {
                [ss hideHUD];
            }
            else
            {
                if (!params)
                {
                    [ss showErrorHUDWithStatus:[error localizedDescription]];
                }
                else
                {
                    [ss showErrorHUDWithStatus:HTTP_REQUEST_ERROR];
                }
            }
            
            [ss updateHeaderView];
        }];
    }];
}

-(void)startRequestBankInfoWithCompleteBlock:(KDViewModelCompleteCallBackBlock)completeBlock
{
    KDUserModel *model = [_viewModel getUserInfoModel];

    WS(ws);
    [_viewModel startRequestBankInfoWithBeginBlock:^{
        if (!model)
        {
            [ws showHUD];
        }
    } completeBlock:completeBlock];
}
-(void)setupUI
{
    [_tableView setTableHeaderView:self.tableViewHeaderView];
   
    WS(ws);
    [_viewModel setFinishDownloadLogoHandler:^(UIImage *img) {
        [ws updateHeaderView];
    }];
    
    [self updateHeaderView];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger section = 0;
    
    if (_viewModel)
    {
        section = [_viewModel tableViewSections];
    }
    
    return section;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = 0;
    
    if (_viewModel)
    {
        rows = [_viewModel tableViewRowsForSection:section];
    }
    
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"settingCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:TEXT_FONT_MEDIUM_SIZE];
        cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    
    if (_viewModel)
    {
        [_viewModel configureTableViewCell:cell indexPath:indexPath];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    KDActionModel *model = [_viewModel tableViewModelForIndexPath:indexPath];
    if (model && [model isKindOfClass:[KDActionModel class]])
    {
        if ([model.title isEqualToString:MY_ACCOUNT])
        {
            [[KDRouterManger sharedManager] pushVCWithKey:@"MyAccountVC" parentVC:self];
        }
        else if ([model.title isEqualToString:CONNECT_US])
        {
            [self onTapConnectUS];
        }
        else if ([model.title isEqualToString:FEEDBACK])
        {
            
        }
    }
}

-(UIView *)tableViewHeaderView
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, IMAGEVIEW_HEIGHT + TEXT_FONT_BIG_SIZE + 2*VERTICAL_PADDING + PAYVIEW_HEIGHT + STATUS_BAR_HEIHT)];
    headerView.backgroundColor = APPD_RED_COLOR;
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - IMAGEVIEW_HEIGHT)/2, 0, IMAGEVIEW_HEIGHT, IMAGEVIEW_HEIGHT)];
    [headerView addSubview:_imageView];
    _imageView.layer.cornerRadius = (IMAGEVIEW_HEIGHT)/2.0;
    _imageView.layer.masksToBounds = YES;
    _imageView.image = [[KDShopManager sharedInstance] getShopLogo];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _imageView.frame.origin.y + _imageView.frame.size.height + VERTICAL_PADDING, SCREEN_WIDTH, TEXT_FONT_BIG_SIZE)];
    _nameLabel.font = [UIFont systemFontOfSize:TEXT_FONT_BIG_SIZE];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.textColor = [UIColor whiteColor];
    [headerView addSubview:_nameLabel];
    
    _payView = [[KDPayBrandView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/4.0, _nameLabel.frame.origin.y + _nameLabel.frame.size.height + VERTICAL_PADDING, SCREEN_WIDTH/2.0, PAYVIEW_HEIGHT)];
    [headerView addSubview:_payView];
    _payView.delegate = self;
    return headerView;
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    _payView.frame = CGRectMake(SCREEN_WIDTH/4.0, _nameLabel.frame.origin.y + _nameLabel.frame.size.height + VERTICAL_PADDING, SCREEN_WIDTH/2.0, PAYVIEW_HEIGHT);
}
-(void)updateHeaderView
{
    KDUserModel *model = [[KDUserManager sharedInstance] getUserInfo];
    KDBankModel *bankModel = [[KDUserManager sharedInstance] getUserBankInfo];
    
    _imageView.image = [[KDShopManager sharedInstance] getShopLogo];
    
    if (model && [model isKindOfClass:[KDUserModel class]])
    {
        _nameLabel.text = model.name;
    }
    
    if (VALIDATE_MODEL(bankModel, @"KDBankModel"))
    {
        [_payView setPayBrandViewType:KDPaymentTypeOfBankPay number:bankModel.formatedVertualCardNumber];
    }
    else
    {
        [_payView setPayBrandViewType:KDPaymentTypeOfBankPay number:NO_BANK_CARD_TITLE];
    }
}

-(void)onTapConnectUS
{
    JMActionSheetDescription *desc = [[JMActionSheetDescription alloc] init];
    desc.actionSheetTintColor = [UIColor grayColor];
    desc.actionSheetCancelButtonFont = [UIFont boldSystemFontOfSize:17.0f];
    desc.actionSheetOtherButtonFont = [UIFont systemFontOfSize:16.0f];
//    desc.title = @"Available actions for component";
    JMActionSheetItem *cancelItem = [[JMActionSheetItem alloc] init];
    cancelItem.title = BUTTON_TITLE_CANCEL;
    desc.cancelItem = cancelItem;
    
    NSMutableArray *items = [[NSMutableArray alloc] init];
    JMActionSheetItem *itemShare = [[JMActionSheetItem alloc] init];
    itemShare.title = @"联系客服";
    itemShare.action = ^(void){
        NSLog(@"classic button pressed");
    };
    [items addObject:itemShare];
    
    desc.items = items;
    [JMActionSheet showActionSheet:desc];
}

#pragma mark - paymentView delegate
-(void)onTapPayBrandViewWithPaymentType:(KDPaymentType)type
{
    KDBankModel *bankModel = [[KDUserManager sharedInstance] getUserBankInfo];
    if (VALIDATE_MODEL(bankModel, @"KDBankModel"))
    {
        [[KDRouterManger sharedManager] pushVCWithKey:@"KDMyBankCardVC" parentVC:self params:@{BANK_INFO_MODEL:bankModel}];
    }
    else
    {
        [[KDRouterManger sharedManager] pushVCWithKey:@"KDMyBankCardVC" parentVC:self];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    DDLogInfo(@"-KDSettingsViewController dealloc");
}
@end
