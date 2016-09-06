//
//  KDFoodEvalueViewController.m
//  KuaiDianForSeller
//
//  Created by ppnd on 16/9/5.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDFoodEvalueViewController.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "KDEvalueTableCell.h"
#import "KDFoodEvalueViewModel.h"

static NSString *kEvalueTableCell = @"kEvalueTableCell";

@interface KDFoodEvalueViewController ()<UITableViewDataSource,UITableViewDelegate>

//viewmodel
@property(nonatomic,strong)KDFoodEvalueViewModel *viewModel;

//headerview
@property(nonatomic,strong)UICollectionView *headerView;

@end

@implementation KDFoodEvalueViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNaviBarItemWithType:KDNavigationBackToPreviousVC];
    self.navigationItem.title = FOOD_EVALUE_TITLE;
    
    _viewModel = [[KDFoodEvalueViewModel alloc] init];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerNib:[UINib nibWithNibName:@"KDEvalueTableCell" bundle:nil] forCellReuseIdentifier:kEvalueTableCell];
    
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
    KDEvalueTableCell *cell = [tableView dequeueReusableCellWithIdentifier:kEvalueTableCell];
    
    if (!cell)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"KDEvalueTableCell" owner:self options:nil] lastObject];
    }
    if (_viewModel)
    {
        [_viewModel configureTableViewCell:cell indexPath:indexPath];
    }
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WS(ws);
    CGFloat height = [tableView fd_heightForCellWithIdentifier:kEvalueTableCell cacheByIndexPath:indexPath configuration:^(id cell) {
        if (ws.viewModel)
        {
            [ws.viewModel configureTableViewCell:cell indexPath:indexPath];
        }
    }];
    DDLogInfo(@"height:%.0f",height);
    return height;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    DDLogInfo(@"-KDFoodEvalueViewController dealloc");
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
