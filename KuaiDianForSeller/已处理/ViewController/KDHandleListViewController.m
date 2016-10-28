//
//  KDHandleListViewController.m
//  KuaiDianForSeller
//
//  Created by ppnd on 16/8/31.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDHandleListViewController.h"
#import "KDScrollView.h"
#import "KDHandleListTableCell.h"
#import "KDHandleListViewModel.h"
#import "KDHandleOrderDetailView.h"
#import "KDOrderModel.h"
#import <MJRefresh.h>

#define SEGMENT_CONTROL_HEIGHT 50

#define TODAY_TITLE @"今日"
#define HISTORY_TITLE @"历史"
#define UPDATE_ORDER_SUCCESS @"确认订单成功"
#define UPDATE_ORDER_FAILED @"确认订单失败"

#define SEARCH_BUTTON_IMAGE @"search_icon"

typedef NS_ENUM(NSInteger,KDLoadTableDataType)
{
    //今日记录
    KDLoadTableDataTypeOfToday = 0,
    //历史记录
    KDLoadTableDataTypeOfHistory = 1,
};

@interface KDHandleListViewController ()<UITableViewDataSource,UITableViewDelegate,KDScrollViewDelegate,KDCellDelegate>

@property(nonatomic,strong)KDScrollView *scrollView;

@property(nonatomic,strong)UITableView *todayTableView;

@property(nonatomic,strong)UITableView *historyTableView;

@property(nonatomic,strong)KDHandleListViewModel *todayViewModel;

@property(nonatomic,strong)KDHandleListViewModel *historyViewModel;

@property(nonatomic,strong)KDHandleOrderDetailView *detailView;

//@property(nonatomic,strong)UISearchBar *todaySearchBar;

@end

@implementation KDHandleListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = HANDLE_LIST_TITLE;
    _todayViewModel = [[KDHandleListViewModel alloc] initWithOrderStatus:KDOrderStatusOfAlreadyAccepted];
    _historyViewModel = [[KDHandleListViewModel alloc] initWithOrderStatus:KDOrderStatusOfSuccess];
    [self setupUI];
    // Do any additional setup after loading the view from its nib.
}

-(void)setupUI
{
    _scrollView = [[KDScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.frame.size.height) segmentControllHeight:SEGMENT_CONTROL_HEIGHT];
    _scrollView.kdScrollViewDelegate = self;
    [self.view addSubview:_scrollView];
    
    UINib *cellNib = [UINib nibWithNibName:@"KDHandleListTableCell" bundle:nil];
    
    _todayTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.frame.size.height - SEGMENT_CONTROL_HEIGHT) style:UITableViewStylePlain];
    [_todayTableView registerNib:cellNib forCellReuseIdentifier:kHandleListTableCell];
    _todayTableView.dataSource = self;
    _todayTableView.delegate = self;
//    _todaySearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
//    _todaySearchBar.delegate = self;

//    [_todayTableView setTableHeaderView:_todaySearchBar];
    [_todayTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    [_scrollView addView:_todayTableView title:TODAY_TITLE];
    
    _historyTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.frame.size.height - SEGMENT_CONTROL_HEIGHT) style:UITableViewStylePlain];
    [_historyTableView registerNib:cellNib forCellReuseIdentifier:kHandleListTableCell];
    _historyTableView.dataSource = self;
    _historyTableView.delegate = self;
    [_historyTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];

    [_scrollView addView:_historyTableView title:HISTORY_TITLE];
    _todayTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _historyTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    _todayTableView.rowHeight = TABLECELL_HEIGHT;
    _historyTableView.rowHeight = TABLECELL_HEIGHT;
    _todayTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _historyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    
    WS(ws);
    _todayTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [ws refreshTableViewDataWithDataType:KDLoadTableDataTypeOfToday];
    }];
    
    _todayTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [ws loadmoreTableViewDataWithDataType:KDLoadTableDataTypeOfToday];
    }];
    
    _historyTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [ws refreshTableViewDataWithDataType:KDLoadTableDataTypeOfHistory];
    }];
    
    _historyTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [ws loadmoreTableViewDataWithDataType:KDLoadTableDataTypeOfHistory];
    }];

    UIButton *rightBTN = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, BUTTON_HEIGHT, BUTTON_HEIGHT)];
    [rightBTN setImage:[UIImage imageNamed:SEARCH_BUTTON_IMAGE] forState:UIControlStateNormal];
    [rightBTN addTarget:self action:@selector(onTapRightBTN) forControlEvents:UIControlEventTouchUpInside];
    rightBTN.backgroundColor = [UIColor clearColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBTN];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self startLoadTableViewData];
}
 
-(void)startLoadTableViewData
{
    if ([KDUserManager isUserLogin])
    {
        WS(ws);
        [_todayViewModel startLoadTodayTableDataWithBeginBlock:^{
            [ws showHUD];
        } completeBlock:^(BOOL isSuccess, id params, NSError *error) {
            
            [ws hideHUD];

            if (isSuccess)
            {
                [ws.todayTableView reloadData];
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
-(void)refreshTableViewDataWithDataType:(KDLoadTableDataType)type
{
    WS(ws);
    if (type == KDLoadTableDataTypeOfToday)
    {
        [_todayViewModel refreshTodayTableDataWithBeginBlock:nil completeBlock:^(BOOL isSuccess, id params, NSError *error) {
            [ws endRefreshWithNoMoreData:NO];
            
            if (isSuccess)
            {
                [ws.todayTableView reloadData];
            }
            else
            {
                [ws showErrorHUDWithStatus:[error localizedDescription]];
            }
        }];
    }
    else
    {
        [_historyViewModel refreshHistoryTableDataWithBeginBlock:nil completeBlock:^(BOOL isSuccess, id params, NSError *error) {
            
            [ws endRefreshWithNoMoreData:NO];
            
            if (isSuccess)
            {
                [ws.historyTableView reloadData];
            }
            else
            {
                [ws showErrorHUDWithStatus:[error localizedDescription]];
            }
        }];
    }
}
-(void)loadmoreTableViewDataWithDataType:(KDLoadTableDataType)type
{
    WS(ws);
    if (type == KDLoadTableDataTypeOfToday)
    {
        [_todayViewModel loadmoreTodayTableDataWithBeginBlock:nil completeBlock:^(BOOL isSuccess, id params, NSError *error) {
            if (isSuccess)
            {
                [ws endRefreshWithNoMoreData:NO];
                [ws.historyTableView reloadData];
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
    else
    {
        [_historyViewModel loadmoreHistoryTableDataWithBeginBlock:nil completeBlock:^(BOOL isSuccess, id params, NSError *error) {
            if (isSuccess)
            {
                [ws endRefreshWithNoMoreData:NO];
                [ws.historyTableView reloadData];
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
}
-(void)endRefreshWithNoMoreData:(BOOL)noMoreData
{
    if (noMoreData)
    {
        [self.todayTableView.mj_footer endRefreshingWithNoMoreData];
        [self.historyTableView.mj_footer endRefreshingWithNoMoreData];
    }
    else
    {
        [self.todayTableView.mj_footer endRefreshing];
        [self.historyTableView.mj_footer endRefreshing];
    }
    
    [self.todayTableView.mj_header endRefreshing];
    [self.historyTableView.mj_header endRefreshing];
}


- (BOOL)onTapRightBTN
{
    [[KDRouterManger sharedManager] presentVCWithKey:@"KDSearchVC" parentVC:self hasNavigator:NO animate:YES];
    return YES;
}

#pragma mark - tableview delegate method

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:_todayTableView])
    {
        return [_todayViewModel tableViewRowsForSection:section];
    }
    else if ([tableView isEqual:_historyTableView])
    {
        return [_historyViewModel tableViewRowsForSection:section];
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KDHandleListTableCell *cell = [tableView dequeueReusableCellWithIdentifier:kHandleListTableCell];
    if (!cell)
    {
        cell = [[KDHandleListTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kHandleListTableCell];
    }
    
    cell.cellDelegate = self;
    if ([tableView isEqual:_todayTableView])
    {
        [_todayViewModel configureTableViewCell:cell indexPath:indexPath];
    }
    else if ([tableView isEqual:_historyTableView])
    {
        [_historyViewModel configureTableViewCell:cell indexPath:indexPath];;
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    KDOrderModel *model = nil;
    if ([tableView isEqual:_todayTableView])
    {
        model = (KDOrderModel *)[_todayViewModel tableViewModelForIndexPath:indexPath];
    }
    else if ([tableView isEqual:_historyTableView])
    {
        model = (KDOrderModel *)[_historyViewModel tableViewModelForIndexPath:indexPath];
    }
    
    if (model)
    {
        [self.detailView showDetailViewWithModel:model];
    }
    
}

#pragma mark - KDScrollViewDelegate
-(void)didSelectedAtPageIndex:(NSInteger)index
{
    if (index == 1)
    {
        WS(ws);
        [_historyViewModel startLoadTodayTableDataWithBeginBlock:^{
            [ws showHUD];
        } completeBlock:^(BOOL isSuccess, id params, NSError *error) {
            
            [ws hideHUD];
            
            if (isSuccess)
            {
                [ws.historyTableView reloadData];
            }
        }];
    }
}

#pragma mark - KDCellDelegate
-(void)onTapTableCell:(UITableViewCell *)cell model:(id)model
{
    if (model && [model isKindOfClass:[KDOrderModel class]])
    {
        WS(ws);
        [_todayViewModel confirmOrder:model beginBlock:^{
            [ws showHUD];
        } completeBlock:^(BOOL isSuccess, id params, NSError *error) {
            if (isSuccess)
            {
                [ws showSuccessHUDWithStatus:UPDATE_ORDER_SUCCESS];
                ((KDOrderModel *)model).orderStatus = KDOrderStatusOfSuccess;
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
        indexPath = [_todayTableView indexPathForCell:cell];
    }
    
    if (indexPath)
    {
        [_todayTableView beginUpdates];
        [_todayTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [_todayTableView endUpdates];
    }
    else
    {
        [_todayTableView reloadData];
    }
}
-(KDHandleOrderDetailView *)detailView
{
    if (!_detailView)
    {
        _detailView = [KDHandleOrderDetailView detailView];
        _detailView.hidden = YES;
        UIView *keyView = [[UIApplication sharedApplication] keyWindow].rootViewController.view;
        [keyView addSubview:_detailView];
    }
    
    return _detailView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc
{
    DDLogInfo(@"-KDHandleListViewController dealloc");
}
@end
