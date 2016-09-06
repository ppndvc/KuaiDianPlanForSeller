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

#define SEGMENT_CONTROL_HEIGHT 50
#define ROWS_PER_PAGE 50

#define TODAY_TITLE @"今日"
#define HISTORY_TITLE @"历史"

static NSString *kHandleListTableCell = @"kHandleListTableCell";

@interface KDHandleListViewController ()<UITableViewDataSource,UITableViewDelegate,KDScrollViewDelegate>

@property(nonatomic,strong)KDScrollView *scrollView;

@property(nonatomic,strong)UITableView *todayTableView;

@property(nonatomic,strong)UITableView *historyTableView;

@property(nonatomic,strong)KDHandleListViewModel *todayViewModel;

@property(nonatomic,strong)KDHandleListViewModel *historyViewModel;

@property(nonatomic,strong)KDHandleOrderDetailView *detailView;

@property(nonatomic,strong)UISearchBar *todaySearchBar;

@end

@implementation KDHandleListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = HANDLE_LIST_TITLE;
    _todayViewModel = [[KDHandleListViewModel alloc] init];
    _historyViewModel = [[KDHandleListViewModel alloc] init];
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
    _todaySearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    [_todayTableView setTableHeaderView:_todaySearchBar];
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

}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    WS(ws);
    [_todayViewModel startLoadTableDataWithPage:0 rowsPerPage:ROWS_PER_PAGE beginBlock:^{
        [ws showHUD];
    } completeBlock:^(BOOL isSuccess, id params, NSError *error) {
       
        [_todayTableView reloadData];
        [ws hideHUD];
    }];
}
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
-(void)didSelectedAtPageIndex:(NSInteger)index
{
    DDLogInfo(@"---- index:%d",index);
//    
//    switch (index)
//    {
//        case 0:
//        {
//            [_todayViewModel startLoadTableDataWithPage:0 rowsPerPage:ROWS_PER_PAGE beginBlock:^{
//                
//            } completeBlock:^(BOOL isSuccess, id params, NSError *error) {
//                
//            }];
//        }
//            break;
//        case 1:
//        {
//            [_historyViewModel startLoadTableDataWithPage:0 rowsPerPage:ROWS_PER_PAGE beginBlock:^{
//                
//            } completeBlock:^(BOOL isSuccess, id params, NSError *error) {
//                
//            }];
//        }
//            break;
//            
//        default:
//            break;
//    }
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
