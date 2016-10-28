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

@interface KDSettingsViewController ()<UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate>

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
    KDUserModel *model = [_viewModel getUserInfoModel];
    
    [_viewModel startRequestUserInfoWithBeginBlock:^{
        if (!model)
        {
            [ws showHUD];
        }
    } completeBlock:^(BOOL isSuccess, id params, NSError *error) {
        
        if (isSuccess)
        {
            [ws updateHeaderView];
            [ws hideHUD];
        }
        else
        {
            if (!model)
            {
                [ws showErrorHUDWithStatus:[error localizedDescription]];
            }
        }
    }];
    
    [self updateHeaderView];
}
-(void)setupUI
{
    [_tableView setTableHeaderView:self.tableViewHeaderView];
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
    _imageView.backgroundColor = [UIColor whiteColor];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _imageView.frame.origin.y + _imageView.frame.size.height + VERTICAL_PADDING, SCREEN_WIDTH, TEXT_FONT_BIG_SIZE)];
    _nameLabel.font = [UIFont systemFontOfSize:TEXT_FONT_BIG_SIZE];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.textColor = [UIColor whiteColor];
    [headerView addSubview:_nameLabel];
    
    _payView = [[KDPayBrandView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/4.0, _nameLabel.frame.origin.y + _nameLabel.frame.size.height + VERTICAL_PADDING, SCREEN_WIDTH/2.0, PAYVIEW_HEIGHT)];
    [headerView addSubview:_payView];
    return headerView;
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    _payView.frame = CGRectMake(SCREEN_WIDTH/4.0, _nameLabel.frame.origin.y + _nameLabel.frame.size.height + VERTICAL_PADDING, SCREEN_WIDTH/2.0, PAYVIEW_HEIGHT);
}
-(void)updateHeaderView
{
    KDUserModel *model = [_viewModel getUserInfoModel];
    if (model && [model isKindOfClass:[KDUserModel class]])
    {
//        _imageView.image = [UIImage imageNamed:model.ima];
        _nameLabel.text = model.name;
        [_payView setPayBrandViewType:KDPaymentTypeOfBankPay number:model.cardNumber];
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
  
//    itemShare = [[JMActionSheetItem alloc] init];
//    itemShare.title = @"联系客服dd";
//    itemShare.action = ^(void){
//        NSLog(@"classic button pressed");
//    };
//    [items addObject:itemShare];
    
    desc.items = items;
    [JMActionSheet showActionSheet:desc];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)dealloc
{
    DDLogInfo(@"-KDSettingsViewController dealloc");
}
@end
