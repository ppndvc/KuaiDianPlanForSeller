//
//  KDMyAccountViewController.m
//  KuaiDianForSeller
//
//  Created by ppnd on 16/8/20.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDMyAccountViewController.h"
#import "KDAccountViewModel.h"

@interface KDMyAccountViewController ()<UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate>

//viewmodel
@property(nonatomic,strong)KDAccountViewModel *viewModel;

@end

@implementation KDMyAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = MY_ACCOUNT;
    
    _viewModel = [KDAccountViewModel new];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView setTableHeaderView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)]];
    [self setNaviBarItemWithType:KDNavigationBackToPreviousVC];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    WS(ws);
    [_viewModel startRequestUserInfoWithBeginBlock:^{
        [ws showHUD];
    } completeBlock:^(BOOL isSuccess, id params, NSError *error) {
        if (isSuccess)
        {
            [ws.tableView reloadData];
            [ws hideHUD];
        }
        else if (params)
        {
            [ws.tableView reloadData];
            [ws hideHUD];
        }
        else
        {
            if (error)
            {
                [ws showErrorHUDWithStatus:error.localizedDescription];
            }
            else
            {
                [ws showErrorHUDWithStatus:HTTP_REQUEST_ERROR];
            }
        }
    }];
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:TEXT_FONT_MEDIUM_SIZE];
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
    
    if (VALIDATE_MODEL(model, @"KDActionModel") && VALIDATE_STRING(model.actionString))
    {
        [[KDRouterManger sharedManager] routeVCWithURL:model.actionString];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    DDLogInfo(@"-KDMyAccountViewController dealloc");
}
@end
