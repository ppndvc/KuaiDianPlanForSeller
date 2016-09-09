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

@interface KDUnhandleOrderViewController ()<UITableViewDataSource,UITableViewDelegate>

//viewmodel
@property(nonatomic,strong)KDUnhandleViewModel *viewModel;

@end

@implementation KDUnhandleOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = UNHANDLE_TITLE;
    _viewModel = [[KDUnhandleViewModel alloc] init];
    [_tableView registerNib:[UINib nibWithNibName:@"KDOrderTableViewCell" bundle:nil] forCellReuseIdentifier:kOrderTableViewCell];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [_tableView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //防止和登录页面冲突，延迟加载
    [self performSelector:@selector(loadingView) withObject:nil afterDelay:0.5];

//    [self showHUD];
    // Do any additional setup after loading the view from its nib.
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
//    _tableView.delegate = self;
//    _tableView.dataSource = self;
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
    KDOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kOrderTableViewCell];
    
    if (!cell)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"KDOrderTableViewCell" owner:self options:nil] lastObject];
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
    CGFloat height = [tableView fd_heightForCellWithIdentifier:kOrderTableViewCell cacheByIndexPath:indexPath configuration:^(id cell) {
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
    DDLogInfo(@"-KDUnhandleOrderViewController dealloc");
}

@end
