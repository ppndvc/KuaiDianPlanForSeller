//
//  KDMainPageController.m
//  KuaiDianPlan
//
//  Created by ppnd on 16/7/24.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDMainPageController.h"
#import "KDShopCellTableViewCell.h"
#import "SDCycleScrollView.h"
#import "KDMainPageViewModel.h"
#import "KDShopModel.h"
#import "KDActionModel.h"
#import "KDActivityModel.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "KDActionCollectionViewCell.h"

#define COLLECTION_VIEW_HEIGHT 100
#define HEADERVIEW_VIEW_HEIGHT 100

#define COLLECTION_CELL_WIDTH 52
#define COLLECTION_CELL_HEIGHT 75

#define COLLECTION_CELL_INSET 20
#define COLLECTION_CELL_TOP_INSET 11
#define COLLECTION_CELL_BOTTOM_INSET 14


static NSString *kTableViewCellIdentifier = @"MainPageTableViewCell";
static NSString *kCollectionViewCellIdentifier = @"MainPageCollectionViewCell";

@interface KDMainPageController()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,SDCycleScrollViewDelegate>

//主tableview
@property(nonatomic,strong)UITableView *tableView;

//操作面板vm
@property(nonatomic,strong)KDMainPageViewModel *mainViewModel;

//轮播图
@property(nonatomic,strong)SDCycleScrollView *scrollImageView;

//操作面板
@property(nonatomic,strong)UICollectionView *actionPanelView;

//title view
@property(nonatomic,strong)UIButton *titleView;

@end

@implementation KDMainPageController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.titleView = [self titleViewWithTitle:@"第一食堂测试字符"];
    //tableview
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - TAB_BAR_HEIHT - NAVIGATION_BAR_HEIHT) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = APP_BG_COLOR;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.1)];
    [_tableView setTableFooterView:view];
    [_tableView registerClass:[KDShopCellTableViewCell class] forCellReuseIdentifier:kTableViewCellIdentifier];
    [self.view addSubview:_tableView];
    
    _mainViewModel = [[KDMainPageViewModel alloc] init];
    
    WS(ws);
    [_mainViewModel updateViewWithCallBackBlock:^(NSArray *headerViewModels) {
        [ws updateViewWithHeaderViewModels:headerViewModels];
    }];

    [self beginUpdateViewData];    
}

#pragma mark - tableview delegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = 0;
    
    if (_mainViewModel)
    {
        rows = [_mainViewModel tableViewRowsForSection:section];
    }
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KDShopCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableViewCellIdentifier];
    
    if (!cell)
    {
        cell = [[KDShopCellTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kTableViewCellIdentifier];
    }
    if (_mainViewModel)
    {
        [_mainViewModel configureTableViewCell:cell indexPath:indexPath];
    }
    
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [self sectionHeaderView];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WS(ws);
    CGFloat height = [tableView fd_heightForCellWithIdentifier:kTableViewCellIdentifier cacheByIndexPath:indexPath configuration:^(id cell) {
        if (ws.mainViewModel)
        {
            [ws.mainViewModel configureTableViewCell:cell indexPath:indexPath];
        }
    }];
    DDLogInfo(@"height:%.0f",height);
    return height;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return COLLECTION_VIEW_HEIGHT + TEXT_FONT_SMALL_SIZE;
}

#pragma mark - collection view delegate methods

//每个分区上的元素个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger rows = 0;
    
    if (_mainViewModel)
    {
        rows = [_mainViewModel collectionViewRows];
    }
    return rows;
}

//设置元素内容
- (UICollectionViewCell *)collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    KDActionCollectionViewCell *cell = (KDActionCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:kCollectionViewCellIdentifier forIndexPath:indexPath];

    [cell sizeToFit];
    
    if (_mainViewModel)
    {
        [_mainViewModel configureCollectionViewCell:cell indexPath:indexPath];
    }
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    KDActionModel *action = [_mainViewModel collectionViewActionForIndex:indexPath.row];
    if (action)
    {
        [[KDRouterManger sharedManager] routeVCWithURL:action.actionString];
    }
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(COLLECTION_CELL_WIDTH, COLLECTION_CELL_HEIGHT);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    if (_mainViewModel)
    {
        NSInteger rows = [_mainViewModel collectionViewRows];
        
        return (SCREEN_WIDTH - rows*COLLECTION_CELL_WIDTH - 2*COLLECTION_CELL_INSET)/(1.0*(rows + 1));
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
#pragma mark - cycleview delegate methods
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    KDActionModel *action = [_mainViewModel headerViewActionForIndex:index];
    if (action)
    {
        [[KDRouterManger sharedManager] routeVCWithURL:action.actionString];
    }
}
#pragma mark - private methods
-(void)beginUpdateViewData
{
    if(_mainViewModel)
    {
        [self showHUD];
        [_mainViewModel beginUpdate];
    }
}
-(void)updateViewWithHeaderViewModels:(NSArray *)headerViewModels
{
    DDLogInfo(@"update main page view!");
    [self hideHUD];
    
    if (headerViewModels && [headerViewModels isKindOfClass:[NSArray class]] && headerViewModels.count > 0)
    {
        SDCycleScrollView *cycleView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, HEADERVIEW_VIEW_HEIGHT) actionModels:headerViewModels];
        [cycleView setDelegate:self];
        
        [_tableView beginUpdates];
        [_tableView setTableHeaderView:cycleView];
        [_tableView endUpdates];
    }
    else
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.1)];
        [_tableView setTableHeaderView:view];
    }
 
    
    //刷新表格
    [_tableView reloadData];
    [_actionPanelView reloadData];

}
-(UICollectionView *)actionPanelView
{
    if (!_actionPanelView)
    {
        //collectionView初始化
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        
        _actionPanelView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, COLLECTION_VIEW_HEIGHT) collectionViewLayout:flowLayout];
        _actionPanelView.delegate = self;
        _actionPanelView.dataSource = self;
        
        _actionPanelView.scrollEnabled = NO;
        
        _actionPanelView.showsVerticalScrollIndicator = NO;
        _actionPanelView.showsHorizontalScrollIndicator = NO;
        
        //注册
        UINib *cellNib = [UINib nibWithNibName:@"KDActionCollectionViewCell" bundle:nil];
        [_actionPanelView registerNib:cellNib forCellWithReuseIdentifier:kCollectionViewCellIdentifier];
        _actionPanelView.backgroundColor = [UIColor whiteColor];
    }
    
    return _actionPanelView;
}
-(UIView *)sectionHeaderView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, COLLECTION_VIEW_HEIGHT + GENERAL_SEPERATOR_HEIGHT)];
    view.backgroundColor = APP_BG_COLOR;
    
    [view addSubview:self.actionPanelView];
    
    return view;
}

-(UIButton *)titleViewWithTitle:(NSString *)title
{
    if (!title || title.length <= 0)
    {
        title = @"主页";
    }
    
    CGFloat width = (title.length + 1) * NAVIBAR_TITLE_FONT_SIZE;
    
    _titleView = [UIButton buttonWithType:UIButtonTypeCustom];
//    _titleView.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _titleView.titleEdgeInsets = UIEdgeInsetsMake(0, -40, 0, 0);
    _titleView.frame = CGRectMake(0, 0, width, NAVIBAR_TITLE_FONT_SIZE);
//    _titleView.titleLabel.textAlignment = NSTextAlignmentLeft;
//    _titleView.titleLabel.text = title;
    [_titleView setTitle:title forState:UIControlStateNormal];
    
    [_titleView setImage:[UIImage imageNamed:@"b27_icon_star_gray"] forState:UIControlStateNormal];
    _titleView.imageEdgeInsets = UIEdgeInsetsMake(0, width, 0, 0);
    return _titleView;
}
@end
