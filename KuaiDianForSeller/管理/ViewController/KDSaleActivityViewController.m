//
//  KDSaleActivityViewController.m
//  KuaiDianForSeller
//
//  Created by ppnd on 16/9/7.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDSaleActivityViewController.h"
#import "KDSaleActivityViewModel.h"
#import "KDSaleActivityTableCell.h"

#define ROW_HEIGHT 120

static NSString *kSaleActivityTableCell = @"kSaleActivityTableCell";

@interface KDSaleActivityViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)KDSaleActivityViewModel *viewModel;

@end

@implementation KDSaleActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = SALE_ACTIVITY_TITLE;
    [self setNaviBarItemWithType:KDNavigationBackToPreviousVC];
    
    _viewModel = [[KDSaleActivityViewModel alloc] init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = ROW_HEIGHT;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    // Do any additional setup after loading the view from its nib.
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
    KDSaleActivityTableCell *cell = [tableView dequeueReusableCellWithIdentifier:kSaleActivityTableCell];
    
    if (!cell)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"KDSaleActivityTableCell" owner:self options:nil] lastObject];
    }
    if (_viewModel)
    {
        [_viewModel configureTableViewCell:cell indexPath:indexPath];
    }
    
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    DDLogInfo(@"- KDSaleActivityViewController dealloc");
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
