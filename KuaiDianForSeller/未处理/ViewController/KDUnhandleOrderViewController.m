//
//  KDUnhandleOrderViewController.m
//  KuaiDianForSeller
//
//  Created by ppnd on 16/8/21.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDUnhandleOrderViewController.h"
#import "KDOrderTableViewCell.h"
#import "KDUnhandleViewModel.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "KDUserManager.h"
#import <MJRefresh.h>

#define UPDATE_ORDER_SUCCESS @"确认订单成功"
#define UPDATE_ORDER_FAILED @"确认订单失败"

@interface KDUnhandleOrderViewController ()<UITableViewDataSource,UITableViewDelegate,KDCellDelegate>

//viewmodel
@property(nonatomic,strong)KDUnhandleViewModel *viewModel;

@end

@implementation KDUnhandleOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = UNHANDLE_TITLE;
    _viewModel = [[KDUnhandleViewModel alloc] init];
 
    [self setupUI];
}
-(void)setupUI
{
    [_tableView registerNib:[UINib nibWithNibName:@"KDOrderTableViewCell" bundle:nil] forCellReuseIdentifier:kOrderTableViewCell];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [_tableView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    if ([KDUserManager isUserLogin])
    {
        [self loadingView];
    }
    else
    {
        //防止和登录页面冲突，延迟加载
        [self performSelector:@selector(loadingView) withObject:nil afterDelay:0.5];
    }
    
    WS(ws);
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [ws refreshTableViewData];
    }];
    
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [ws loadmoreTableViewData];
    }];
}
- (void)loadingView
{
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView reloadData];

}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [self startLoadTableViewData];
    [[KDRouterManger sharedManager] pushVCWithKey:@"KDBusinessStatisticsVC" parentVC:self];
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

#pragma mark - TableView Delegate
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
    KDOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kOrderTableViewCell];
    
    if (!cell)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"KDOrderTableViewCell" owner:self options:nil] lastObject];
    }

    if (_viewModel)
    {
        cell.cellDelegate = self;
        [_viewModel configureTableViewCell:cell indexPath:indexPath];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WS(ws);
    CGFloat height = [tableView fd_heightForCellWithIdentifier:kOrderTableViewCell cacheByIndexPath:indexPath configuration:^(id cell) {
        if (ws.viewModel)
        {
            [ws.viewModel configureTableViewCell:cell indexPath:indexPath];
        }
    }];
    return height;
}

#pragma mark - KDCellDelegate

-(void)onTapTableCell:(UITableViewCell *)cell model:(id)model
{
    if (model && [model isKindOfClass:[KDOrderModel class]])
    {
        WS(ws);
        [_viewModel confirmOrder:model beginBlock:^{
            [ws showHUD];
        } completeBlock:^(BOOL isSuccess, id params, NSError *error) {
            if (isSuccess)
            {
                [ws showSuccessHUDWithStatus:UPDATE_ORDER_SUCCESS];
                ((KDOrderModel *)model).orderStatus = KDOrderStatusOfConfirmed;
                [ws reloadTableCell:cell];
            }
            else
            {
                if (error)
                {
                    [ws showErrorHUDWithStatus:[error localizedDescription]];
                }
                else
                {
                    [ws showErrorHUDWithStatus:UPDATE_ORDER_FAILED];
                }
            }
        }];
    }
}


-(void)reloadTableCell:(UITableViewCell *)cell
{
    NSIndexPath *indexPath = nil;
    if (cell && [cell isKindOfClass:[UITableViewCell class]])
    {
        indexPath = [_tableView indexPathForCell:cell];
    }
    
    if (indexPath)
    {
        [_tableView beginUpdates];
        [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [_tableView endUpdates];
    }
    else
    {
        [_tableView reloadData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    DDLogInfo(@"-KDUnhandleOrderViewController dealloc");
}

@end
