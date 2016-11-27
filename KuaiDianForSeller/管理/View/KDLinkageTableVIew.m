//
//  KDLinkageTableVIew.m
//  TextViewDemo
//
//  Created by zy on 16/7/4.
//  Copyright © 2016年 ppnd. All rights reserved.
//

#import "KDLinkageTableVIew.h"
#import "KDLinkageTVModel.h"
#import "KDLeftLinkTableCell.h"
#import "KDLinkTableViewModel.h"
#import "UIButton+NSIndexPath.h"
#import "KDRightLinkTableCell.h"
#import "KDFoodCategoryModel.h"
#import "KDRouterManger.h"
#import "KDFoodItemModel.h"

#define RIGHT_TABLEVIEW_SECTION_HEIGHT 30.0f
#define SECTION_HEADER_LABEL_WIDTH_RATE 0.7

#define EDIT_BUTTON_TITLE @"编辑"

static NSString *kLeftTableCellIdentifier = @"kLeftTableCellIdentifier";
static NSString *kRightTableCellIdentifier = @"kRightTableCellIdentifier";


@interface KDLinkageTableView ()<UITableViewDataSource,UITableViewDelegate,KDLinkageTableRightSideDelegate>

//左侧
@property(nonatomic,strong)UITableView *leftTableView;

//右侧
@property(nonatomic,strong)UITableView *rightTableView;

//头部视图
@property(nonatomic,strong)UIView *headerView;

//数据源
@property(nonatomic,strong)NSMutableArray *dataSource;

//headerview高度
@property(nonatomic,assign)CGFloat headerViewHeight;

//ViewModel
@property(nonatomic,strong)KDLinkTableViewModel *viewModel;

//判断是否是用户点击
@property(nonatomic,assign)BOOL isClicked;

//判断是否第一次显示
@property(nonatomic,assign)BOOL isFirstShow;

//俯视图
@property(nonatomic,weak)UIViewController *superView;

@end

@implementation KDLinkageTableView
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        _viewModel = [[KDLinkTableViewModel alloc] init];
        [self setupUI];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _viewModel = [[KDLinkTableViewModel alloc] init];
        [self setupUI];
    }
    return self;
}
-(void)setSuperView:(UIViewController *)superView
{
    _superView = superView;
}
-(void)updateLeftTableData:(NSArray *)array
{
    [_viewModel updateLeftTableData:array];
    [_leftTableView reloadData];
}
-(void)updateRightTableData:(NSArray *)array atIndex:(NSInteger)index
{
    [_viewModel updateRightTableData:array atIndex:index];
    [_rightTableView reloadData];
}

-(void)reloadRightTableViewData
{
    [_rightTableView reloadData];
}

-(void)setupUI
{
    _leftTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _leftTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _leftTableView.rowHeight = LEFT_TABLEVIEW_CELL_HEIGHT;
    [_leftTableView registerClass:[KDLeftLinkTableCell class] forCellReuseIdentifier:kLeftTableCellIdentifier];
    _leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:_leftTableView];
    
    _rightTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    //group样式下，顶部会多出一块
    _rightTableView.contentInset = UIEdgeInsetsMake(-33, 0, 0, 0);
    _rightTableView.sectionFooterHeight = 0.0;
    _rightTableView.backgroundColor = [UIColor whiteColor];
    [_rightTableView registerNib:[UINib nibWithNibName:@"KDRightLinkTableCell" bundle:nil] forCellReuseIdentifier:kRightTableCellIdentifier];
    _rightTableView.rowHeight = RIGHT_TABLEVIEW_CELL_HEIGHT;
    [self addSubview:_rightTableView];
    
    _headerView = [[UIView alloc] init];
    _headerView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_headerView];
    
    _leftTableView.dataSource = self;
    _leftTableView.delegate = self;
    
    _rightTableView.dataSource = self;
    _rightTableView.delegate = self;
    
    [_leftTableView setTableHeaderView:[[UIView alloc] initWithFrame:CGRectZero]];
    [_rightTableView setTableHeaderView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    [_leftTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [_rightTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];

    _isFirstShow = YES;
    [self updateViews];
}

-(void)setHeaderViewHeight:(CGFloat)headerViewHeight
{
    _headerViewHeight = headerViewHeight;
    [self updateViews];
}

-(void)updateViews
{
    CGRect headerViewFrame = CGRectMake(0, 0, SCREEN_WIDTH, _headerViewHeight);
    CGRect leftTableFrame = CGRectMake(0, _headerViewHeight, SCREEN_WIDTH*LINK_TABLEVIEW_SEPERATE_POSITION_RATE, self.frame.size.height - _headerViewHeight);
    CGRect rightTableFrame = CGRectMake(leftTableFrame.size.width, _headerViewHeight, SCREEN_WIDTH*(1-LINK_TABLEVIEW_SEPERATE_POSITION_RATE), self.frame.size.height - _headerViewHeight);
    
    _headerView.frame = headerViewFrame;
    _leftTableView.frame = leftTableFrame;
    _rightTableView.frame = rightTableFrame;
}
#pragma mark - tableview delegates
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == _rightTableView)
    {
        return [_viewModel rightTableViewSections];
    }
    else
    {
        return 1;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _leftTableView)
    {
        return [_viewModel leftTableViewRowsForSection:section];
    }
    else
    {
        return [_viewModel rightTableViewRowsForSection:section];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _leftTableView)
    {
        KDLeftLinkTableCell *cell = [tableView dequeueReusableCellWithIdentifier:kLeftTableCellIdentifier];
        if (!cell)
        {
            cell = [[KDLeftLinkTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kLeftTableCellIdentifier];
        }
        
        [_viewModel configureLeftTableViewCell:cell indexPath:indexPath];
        
        return cell;
    }
    else
    {
        KDRightLinkTableCell *cell = [tableView dequeueReusableCellWithIdentifier:kRightTableCellIdentifier];
        
        if (!cell)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"KDRightLinkTableCell" owner:self options:nil] lastObject];
        }
        
        cell.linkTableDelegate = self;
        [_viewModel configureRightTableViewCell:cell indexPath:indexPath];
        
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _leftTableView && indexPath.row == 0 && _isFirstShow == YES)
    {
        [_leftTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionTop];
        _isFirstShow = NO;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == _rightTableView)
    {
        return RIGHT_TABLEVIEW_SECTION_HEIGHT;
    }
    else
    {
        return 0.0;
    }
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == _rightTableView)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:section inSection:0];
        KDFoodCategoryModel *model = [_viewModel leftTableViewModelForIndexPath:indexPath];
        if (model && [model isKindOfClass:[KDFoodCategoryModel class]])
        {
            NSString *title = model.name;
            if (VALIDATE_STRING(title))
            {
                return [self headerViewWithTitle:title indexPath:indexPath];
            }
            else
            {
                return nil;
            }
        }
        else
        {
            return nil;
        }
    }
    else
    {
        return nil;
    }
}
//一个方法就能搞定 右边滑动时跟左边的联动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 如果是 左侧的 tableView 直接return
    if (scrollView == _leftTableView)
    {
        return;
    }
    
    if (!_isClicked)
    {
        // 取出显示在 视图 且最靠上 的 cell 的 indexPath
        NSIndexPath *topHeaderViewIndexpath = [[_rightTableView indexPathsForVisibleRows] firstObject];
        
        // 左侧 talbelView 移动的 indexPath
        NSIndexPath *moveToIndexpath = [NSIndexPath indexPathForRow:topHeaderViewIndexpath.section inSection:0];
        
        // 移动 左侧 tableView 到 指定 indexPath 居中显示
        [_leftTableView selectRowAtIndexPath:moveToIndexpath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    }
    
    _isClicked = NO;
}

//点击 cell 的代理方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 选中 左侧 的 tableView
    if (tableView == _leftTableView)
    {
        if (_viewModel.rightTableViewSections > indexPath.row)
        {
            _isClicked = YES;
            NSIndexPath *moveToIndexPath = [NSIndexPath indexPathForRow:0 inSection:indexPath.row];
            
            // 将右侧 tableView 移动到指定位置
            [_rightTableView selectRowAtIndexPath:moveToIndexPath animated:NO scrollPosition:UITableViewScrollPositionTop];
            
            // 取消选中效果
            [_rightTableView deselectRowAtIndexPath:moveToIndexPath animated:NO];
        }
        else
        {
            if (_delegate && [_delegate respondsToSelector:@selector(didSelectedAtIndexPath:params:)])
            {
                id param = [_viewModel leftTableViewModelForIndexPath:indexPath];
                [_delegate didSelectedAtIndexPath:indexPath params:param];
            }
        }
    }
}

-(UIView *)headerViewWithTitle:(NSString *)title indexPath:(NSIndexPath *)indexPath
{
    if (VALIDATE_STRING(title) && indexPath)
    {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _rightTableView.frame.size.width, RIGHT_TABLEVIEW_SECTION_HEIGHT)];
        headerView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        CGFloat labelWidth = (_rightTableView.frame.size.width - 2*(VIEW_VERTICAL_PADDING)) * SECTION_HEADER_LABEL_WIDTH_RATE;
        CGFloat buttonWidth = (_rightTableView.frame.size.width - 2*(VIEW_VERTICAL_PADDING)) * (1 - SECTION_HEADER_LABEL_WIDTH_RATE);
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(VIEW_VERTICAL_PADDING, 0, labelWidth, RIGHT_TABLEVIEW_SECTION_HEIGHT)];
        label.font = [UIFont systemFontOfSize:TEXT_FONT_MEDIUM_SIZE];
        label.textColor = [UIColor darkGrayColor];
        label.text = title;
        [headerView addSubview:label];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(label.frame.size.width + label.frame.origin.x, 0, buttonWidth, RIGHT_TABLEVIEW_SECTION_HEIGHT);
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [button setTitleColor:APPD_RED_COLOR forState:UIControlStateNormal];
        [button setTitle:EDIT_BUTTON_TITLE forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:TEXT_FONT_MEDIUM_SIZE];
        [headerView addSubview:button];
        button.indexPath = indexPath;
        
        [button addTarget:self action:@selector(onTapEditButton:) forControlEvents:UIControlEventTouchUpInside
         ];
        
        return headerView;
    }
    
    return nil;
}
-(void)onTapEditButton:(UIButton *)btn
{
    if (btn)
    {
        NSIndexPath *indexPath = btn.indexPath;
        if (indexPath)
        {
            KDFoodCategoryModel *model = [_viewModel leftTableViewModelForIndexPath:indexPath];
            NSString *oldTitle = @"";
            
            if (model && [model isKindOfClass:[KDFoodCategoryModel class]])
            {
                if (VALIDATE_STRING(model.name))
                {
                    oldTitle = model.name;
                }
            }
            
            WS(ws);
            [[KDRouterManger sharedManager] pushVCWithKey:@"KDCommonTextEditVC" parentVC:_superView params:@{COMMON_INPUT_TITLE_KEY:oldTitle,COMMON_INPUT_INITSTRING_KEY:oldTitle,COMMON_INPUT_CHARACTER_CONSTRAIN_KEY:[NSNumber numberWithInteger:SHORT_TEXT_CHARACTER_CONSTRAIN],COMMON_INPUT_STYLE_KEY:[NSNumber numberWithInteger:KDCommonInputStyleOfSingleRow]} animate:YES vcDisappearBlock:^(NSString *vcKey, id params) {
                __strong __typeof(ws) strongSelf = ws;
                
                if (params && [params isKindOfClass:[NSDictionary class]])
                {
                    [strongSelf.viewModel updateFoodCategoryWithIndexPath:indexPath title:[params objectForKey:COMMON_INPUT_RESULT_STRING_KEY] beginBlock:^{
                        
                        if (strongSelf.delegate && [strongSelf.delegate respondsToSelector:@selector(showHUDWithFlag:)])
                        {
                            [strongSelf.delegate showHUDWithFlag:YES];
                        }
                    } completeBlock:^(BOOL isSuccess, id params, NSError *error) {
                        if (strongSelf.delegate && [strongSelf.delegate respondsToSelector:@selector(showHUDWithFlag:)])
                        {
                            [strongSelf.delegate showHUDWithFlag:NO];
                        }
                        
                        if (isSuccess)
                        {
                            [strongSelf.leftTableView reloadData];
                            [strongSelf.rightTableView reloadData];
                        }
                    }];
                }
            }];
            
            
        }
    }
}
-(NSArray *)getLeftTableData
{
    return [_viewModel leftTableData];
}

#pragma mark - link table delegate method
-(void)onTapEditWithCell:(UITableViewCell *)cell model:(KDFoodItemModel *)model
{
    if (VALIDATE_MODEL(model, @"KDFoodItemModel") && _delegate && [_delegate respondsToSelector:@selector(getFoodCategoryArray)])
    {
        NSArray *foodCateArray = [_delegate getFoodCategoryArray];
        if (VALIDATE_ARRAY(foodCateArray))
        {
            WS(ws);
            [[KDRouterManger sharedManager] pushVCWithKey:@"KDEditFoodItemVC" parentVC:_superView params:@{FOOD_CATEGORY_ARRAY_KEY:foodCateArray,FOOD_ITEM_KEY:model} animate:YES vcDisappearBlock:^(NSString *vcKey, id params) {
                
                [ws.rightTableView reloadData];
            }];
        }
    }
}

-(void)onTapDeleteWithCell:(UITableViewCell *)cell model:(KDFoodItemModel *)model
{
    if (VALIDATE_MODEL(model, @"KDFoodItemModel"))
    {
        WS(ws);
        [_viewModel deleteFoodItem:model beginBlock:^{
            [ws.delegate showHUDWithFlag:YES];
        } completeBlock:^(BOOL isSuccess, id params, NSError *error) {
            if (isSuccess)
            {
                [ws.delegate showHUDWithFlag:NO];
                [ws.rightTableView reloadData];
            }
            else
            {
                [ws.delegate showHUDWithFlag:NO];
            }
        }];
        
    }
}

-(void)onTapChangeStatusWithCell:(UITableViewCell *)cell model:(KDFoodItemModel *)model
{
    if (VALIDATE_MODEL(model, @"KDFoodItemModel"))
    {
        if (model.status == 0)
        {
            model.status = 1;
        }
        else
        {
            model.status = 0;
        }
        
        WS(ws);
        [_viewModel updateFoodItemRequestWithFood:model beginBlock:^{
            [ws.delegate showHUDWithFlag:YES];
        } completeBlock:^(BOOL isSuccess, id params, NSError *error) {
            if (isSuccess)
            {
                [ws.delegate showHUDWithFlag:NO];
                [ws.rightTableView reloadData];
            }
            else
            {
                [ws.delegate showHUDWithFlag:NO];
            }
        }];
    }
}

@end
