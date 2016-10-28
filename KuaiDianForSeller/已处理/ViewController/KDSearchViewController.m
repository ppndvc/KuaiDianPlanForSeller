//
//  KDSearchViewController.m
//  KuaiDianForSeller
//
//  Created by ppnd on 16/9/25.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDSearchViewController.h"
#import "KDHandleListTableCell.h"
#import "KDSearchViewModel.h"
#import "KDHandleOrderDetailView.h"
#import "KDOrderModel.h"


#define SEARCH_ORDER_FAILED @"搜索订单失败"
#define BEING_SEARCH @"正在搜索..."
#define TIPS_TITLE(a) ([NSString stringWithFormat:@"未搜索到与'%@'相关订单",(a)])

@interface KDSearchViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>

//ViewModel
@property(nonatomic,strong)KDSearchViewModel *viewModel;

@property(nonatomic,strong)KDHandleOrderDetailView *detailView;

@end

@implementation KDSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _viewModel = [[KDSearchViewModel alloc] init];
    
    [self setupUI];
    // Do any additional setup after loading the view from its nib.
}
-(void)setupUI
{
    _searhBar.delegate = self;
    [_searhBar setBackgroundImage:[KDTools imageWithColor:APPD_RED_COLOR]];
    [_searhBar setBackgroundColor:[UIColor clearColor]];
    [[UIBarButtonItem appearanceWhenContainedIn: [UISearchBar class], nil] setTintColor:[UIColor whiteColor]];
    [[UIBarButtonItem appearanceWhenContainedIn: [UISearchBar class], nil] setTitle:BUTTON_TITLE_CLOSE];
    
    UINib *cellNib = [UINib nibWithNibName:@"KDHandleListTableCell" bundle:nil];
    [_tableView registerNib:cellNib forCellReuseIdentifier:kHandleListTableCell];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _tableView.rowHeight = TABLECELL_HEIGHT;
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}
-(void)viewDidAppear:(BOOL)animated
{
    [_searhBar becomeFirstResponder];
}

-(void)hideTipsLabel
{
    [self showTipsLabel:NO title:@""];
}
-(void)showTipsLabel:(BOOL)show title:(NSString *)title
{
    _tipsLabel.hidden = !show;
    _tipsLabel.text = title;
}
#pragma mark - searchbar delegate

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [_searhBar resignFirstResponder];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{    
    if (VALIDATE_STRING(searchBar.text))
    {
        WS(ws);
        [_viewModel startSearchWithKeywords:searchBar.text beginBlock:^{
            [ws showHUDWithStatus:BEING_SEARCH];
        } completeBlock:^(BOOL isSuccess, id params, NSError *error) {
            if (isSuccess)
            {
                if (params && [params isKindOfClass:[NSNumber class]] && [params boolValue])
                {
                    [ws.searhBar resignFirstResponder];
                    [ws.tableView reloadData];
                    [ws hideTipsLabel];
                }
                else
                {
                    [ws showTipsLabel:YES title:TIPS_TITLE(searchBar.text)];
                }
            }
            else
            {
                if (error)
                {
                    [ws showErrorHUDWithStatus:[error localizedDescription]];
                }
                else
                {
                    [ws showErrorHUDWithStatus:SEARCH_ORDER_FAILED];
                }
            }
        }];

    }
}

#pragma mark - tableview delegate method

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_viewModel tableViewRowsForSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KDHandleListTableCell *cell = [tableView dequeueReusableCellWithIdentifier:kHandleListTableCell];
    if (!cell)
    {
        cell = [[KDHandleListTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kHandleListTableCell];
    }
    
    [_viewModel configureTableViewCell:cell indexPath:indexPath];

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    KDOrderModel *model = (KDOrderModel *)[_viewModel tableViewModelForIndexPath:indexPath];
    
    if (model)
    {
        [self.detailView showDetailViewWithModel:model];
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
    DDLogInfo(@"-KDSearchViewController dealloc ");
}
@end
