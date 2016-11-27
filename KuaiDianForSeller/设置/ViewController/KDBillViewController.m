//
//  KDBillViewController.m
//  KuaiDianForSeller
//
//  Created by ppnd on 16/11/13.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDBillViewController.h"
#import "KDBillTableCell.h"
#import "KDBillViewModel.h"
#import "KDBillModel.h"

#define ROW_HEIGHT 60.f

@interface KDBillViewController ()<UITableViewDataSource>

//ViewModel
@property(nonatomic,strong)KDBillViewModel *viewModel;

@end

@implementation KDBillViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _viewModel = [[KDBillViewModel alloc] init];
    
    [self setupUI];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)setupUI
{
    self.navigationItem.title = MY_BILL_DETAIL;
    [self setNaviBarItemWithType:KDNavigationBackToPreviousVC];
    
    [_tableView registerNib:[UINib nibWithNibName:@"KDBillTableCell" bundle:nil] forCellReuseIdentifier:kBillTableCellIdentifier];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [_tableView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    
    _tableView.rowHeight = ROW_HEIGHT;
    _tableView.dataSource = self;
    
    WS(ws);
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [ws refreshTableViewData];
    }];
    
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [ws loadmoreTableViewData];
    }];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self startLoadTableViewData];
}

-(void)startLoadTableViewData
{
    if ([KDUserManager isUserLogin])
    {
        WS(ws);
        [_viewModel startLoadTableDataWithBeginBlock:^{
            [ws showHUD];
        } completeBlock:^(BOOL isSuccess, id params, NSError *error) {
            [ws hideHUD];
            
            if (isSuccess)
            {
                [ws hideErrorPage];
                [ws.tableView reloadData];
            }
            else
            {
                [ws showErrorPageWithCompleteBlock:^{
                    __strong __typeof(ws) strongSelf = ws;
                    [strongSelf startLoadTableViewData];
                }];
            }
        }];
    }
}
-(void)refreshTableViewData
{
    WS(ws);
    [_viewModel refreshTableDataWithBeginBlock:nil completeBlock:^(BOOL isSuccess, id params, NSError *error) {
        if (isSuccess)
        {
            [ws.tableView reloadData];
        }
        else
        {
            [ws showErrorHUDWithStatus:[error localizedDescription]];
        }
        
        [ws endRefreshWithNoMoreData:NO];
        
    }];
}
-(void)loadmoreTableViewData
{
    WS(ws);
    [_viewModel loadmoreTableDataWithBeginBlock:nil completeBlock:^(BOOL isSuccess, id params, NSError *error) {
        if (isSuccess)
        {
            [ws endRefreshWithNoMoreData:NO];
            [ws.tableView reloadData];
        }
        else
        {
            if (error)
            {
                [ws showErrorHUDWithStatus:[error localizedDescription]];
            }
            else
            {
                [ws endRefreshWithNoMoreData:YES];
            }
        }
    }];
}
-(void)endRefreshWithNoMoreData:(BOOL)noMoreData
{
    if (noMoreData)
    {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
    else
    {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }
}

#pragma mark - tableview delegate methods

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
    KDBillTableCell *cell = [tableView dequeueReusableCellWithIdentifier:kBillTableCellIdentifier];
    
    if (!cell)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"KDBillTableCell" owner:self options:nil] lastObject];
    }
    
    if (_viewModel)
    {
        [_viewModel configureTableViewCell:cell indexPath:indexPath];
    }
    
    return cell;
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

@end
