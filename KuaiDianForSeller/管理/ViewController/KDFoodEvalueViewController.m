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
#import "KDEvalueFilterItemModel.h"
#import "KDEvalueFilterCollectionCell.h"
#import "KDCustomerReplyModel.h"
#import <MJRefresh.h>


#define COLLECTION_VIEW_HEIGHT 80

#define COLLECTION_CELL_INSET 20
#define COLLECTION_CELL_TOP_INSET 10
#define COLLECTION_CELL_BOTTOM_INSET 10

#define REPLY_TITLE @"回复评论"
#define REPLY_PLACE_HOLDER @"请填写评论"

static NSString *kEvalueTableCell = @"kEvalueTableCell";
static NSString *kEvauleCollectionViewCellIdentifier = @"kEvauleCollectionViewCellIdentifier";

@interface KDFoodEvalueViewController ()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,KDEvalueTableCellDelegate>

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

    [self setupUI];
    // Do any additional setup after loading the view from its nib.
}
-(void)setupUI
{
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerNib:[UINib nibWithNibName:@"KDEvalueTableCell" bundle:nil] forCellReuseIdentifier:kEvalueTableCell];
    [_tableView setTableHeaderView:self.headerView];
    
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
    KDEvalueTableCell *cell = [tableView dequeueReusableCellWithIdentifier:kEvalueTableCell];
    
    if (!cell)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"KDEvalueTableCell" owner:self options:nil] lastObject];
    }
    
    cell.evalueDelegate = self;
    
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
    return height;
}
-(UICollectionView *)headerView
{
    if (!_headerView)
    {
        //collectionView初始化
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        
        _headerView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, COLLECTION_VIEW_HEIGHT) collectionViewLayout:flowLayout];
        _headerView.delegate = self;
        _headerView.dataSource = self;
        
        _headerView.scrollEnabled = NO;
        
        _headerView.showsVerticalScrollIndicator = NO;
        _headerView.showsHorizontalScrollIndicator = NO;
        
        //注册
        UINib *cellNib = [UINib nibWithNibName:@"KDEvalueFilterCollectionCell" bundle:nil];
        [_headerView registerNib:cellNib forCellWithReuseIdentifier:kEvauleCollectionViewCellIdentifier];
        _headerView.backgroundColor = [UIColor whiteColor];
    }
    
    return _headerView;
}
#pragma mark - collection view delegate methods

//每个分区上的元素个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger rows = 0;
    
    if (_viewModel)
    {
        rows = [_viewModel collectionViewRowsForSection:section];
    }
    return rows;
}

//设置元素内容
- (UICollectionViewCell *)collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    KDEvalueFilterCollectionCell *cell = (KDEvalueFilterCollectionCell*)[collectionView dequeueReusableCellWithReuseIdentifier:kEvauleCollectionViewCellIdentifier forIndexPath:indexPath];
    
    [cell sizeToFit];
    
    if (_viewModel)
    {
        [_viewModel configureCollectionViewCell:cell indexPath:indexPath];
    }
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    KDEvalueFilterItemModel *model = [_viewModel collectionViewModelForIndexPath:indexPath setSelected:YES];
    if (VALIDATE_MODEL(model, @"KDEvalueFilterItemModel"))
    {
        [self.headerView reloadData];
        [_viewModel filterReplyWithStarLevel:model.level];
        [_tableView reloadData];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat cellWidth = SCREEN_WIDTH/6.5;
    CGFloat cellHeight = cellWidth/2.2;
    return CGSizeMake(cellWidth, cellHeight);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    if (_viewModel)
    {        
        return ((SCREEN_WIDTH/6.5)/2.0);
    }
    else
    {
        return 0;
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(COLLECTION_CELL_TOP_INSET, COLLECTION_CELL_INSET, COLLECTION_CELL_BOTTOM_INSET, COLLECTION_CELL_INSET);
}

#pragma mark - evalue delegate

-(void)onTapReplyButtonWithModel:(KDCustomerReplyModel *)model
{
    if (VALIDATE_MODEL(model, @"KDCustomerReplyModel"))
    {
        WS(ws);
        [[KDRouterManger sharedManager] pushVCWithKey:@"KDCommonTextEditVC" parentVC:self params:@{COMMON_INPUT_TITLE_KEY:REPLY_TITLE,COMMON_INPUT_STYLE_KEY:[NSNumber numberWithInteger:KDCommonInputStyleOfMultiRows]} animate:YES vcDisappearBlock:^(NSString *vcKey, id params) {
            if (params && [params isKindOfClass:[NSDictionary class]])
            {
                NSString *replyContent = [params objectForKey:COMMON_INPUT_RESULT_STRING_KEY];
                [ws replyWithContent:replyContent srcReplyModel:model];
            }
        }];
    }
}

-(void)replyWithContent:(NSString *)content srcReplyModel:(KDCustomerReplyModel *)model
{
    if (VALIDATE_STRING(content) && VALIDATE_MODEL(model, @"KDCustomerReplyModel") && VALIDATE_STRING(model.identifier))
    {
        NSDictionary *param = @{REQUEST_KEY_EVALUATE_ID:model.identifier,REQUEST_KEY_CONTENT:content};
        WS(ws);
        [_viewModel sendReplyWithParams:param beginBlock:^{
            [ws showHUD];
        } completeBlock:^(BOOL isSuccess, id params, NSError *error) {
            
            if (isSuccess)
            {
                [ws hideHUD];
                KDBaseReplyModel *sellerReply = [[KDBaseReplyModel alloc] init];
                sellerReply.content = content;
                sellerReply.date = [NSString getCurrentDateString];
                model.sellerReply = sellerReply;
                [ws.tableView reloadData];
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
