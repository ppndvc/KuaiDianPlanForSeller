//
//  KDFoodManageViewController.m
//  KuaiDianForSeller
//
//  Created by ppnd on 16/9/17.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDFoodManageViewController.h"
#import "KDLinkageTableView.h"
#import "JMActionSheet.h"
#import "KDFoodManageViewModel.h"
#import "KDFoodCategoryModel.h"

#define BUTTON_TITLE @"添加"
#define ADD_FOOD_BUTTON_TITLE @"添加菜品"
#define ADD_CATEGORY_BUTTON_TITLE @"添加菜品类别"

@interface KDFoodManageViewController ()<KDLinkTableViewDelegate>

@property(nonatomic,strong)KDLinkageTableView *linkTableView;

@property(nonatomic,strong)UIButton *actionButton;

@property(nonatomic,strong)KDFoodManageViewModel *viewModel;


@end

@implementation KDFoodManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNaviBarItemWithType:KDNavigationBackToPreviousVC];
    self.navigationItem.title = FOOD_EDIT_TITLE;
    _viewModel = [[KDFoodManageViewModel alloc] init];
    [self setupUI];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([_viewModel needRequestInitData])
    {
        [self requestInitDataWithFurterData:YES];
    }
}
-(void)requestInitDataWithFurterData:(BOOL)needFurther
{
    WS(ws);
    [_viewModel startRequestFoodCategoryInfoWithBeginBlock:^{
        [ws showHUD];
    } completeBlock:^(BOOL isSuccess, id params, NSError *error) {
        
        __strong __typeof(ws) strongSelf = ws;
        if (isSuccess && VALIDATE_ARRAY((NSArray *)params))
        {
            [strongSelf hideHUD];
            [strongSelf.linkTableView updateLeftTableData:params];
            
            if (needFurther)
            {
                KDFoodCategoryModel *model = [((NSArray *)params) firstObject];
                if (model && [model isKindOfClass:[KDFoodCategoryModel class]])
                {
                    [strongSelf requestFoodListWithCateID:model.category index:0];
                }
            }
        }
        else
        {
            [ws hideHUD];
        }
    }];
}
-(void)requestFoodListWithCateID:(NSString *)cateID index:(NSInteger)index
{
    if (VALIDATE_STRING(cateID))
    {
        WS(ws);
        [_viewModel startRequestFoodListWithID:cateID index:index beginBlock:^{
            [ws showHUD];
        } completeBlock:^(BOOL isSuccess, id params, NSError *error) {
            __strong __typeof(ws) strongSelf = ws;
            [strongSelf hideHUD];
            [strongSelf.linkTableView updateRightTableData:params atIndex:index];
        }];
    }
}
-(void)setupUI
{
    _linkTableView = [[KDLinkageTableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATION_BAR_HEIHT - 2*VIEW_VERTICAL_PADDING - BUTTON_HEIGHT)];
    _linkTableView.delegate = self;
    [_linkTableView setSuperView:self];

    [self.view addSubview:_linkTableView];
    
    _actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_actionButton setTitle:BUTTON_TITLE forState:UIControlStateNormal];
    [_actionButton addTarget:self action:@selector(onTapActionButton) forControlEvents:UIControlEventTouchUpInside];
    _actionButton.layer.cornerRadius = CORNER_RADIUS;
    [_actionButton setBackgroundColor:APPD_RED_COLOR];
    _actionButton.frame = CGRectMake(VIEW_HORIZONTAL_PADDING_TO_SCREEN_BORDER, _linkTableView.frame.size.height + VIEW_VERTICAL_PADDING, SCREEN_WIDTH - 2*VIEW_HORIZONTAL_PADDING_TO_SCREEN_BORDER, BUTTON_HEIGHT);
    _actionButton.titleLabel.font = [UIFont systemFontOfSize:TEXT_FONT_MEDIUM_SIZE];
    [self.view addSubview:_actionButton];
}
-(void)onTapActionButton
{
    JMActionSheetDescription *desc = [[JMActionSheetDescription alloc] init];
    desc.actionSheetTintColor = [UIColor grayColor];
    desc.actionSheetCancelButtonFont = [UIFont boldSystemFontOfSize:17.0f];
    desc.actionSheetOtherButtonFont = [UIFont systemFontOfSize:16.0f];

    JMActionSheetItem *cancelItem = [[JMActionSheetItem alloc] init];
    cancelItem.title = BUTTON_TITLE_CANCEL;
    desc.cancelItem = cancelItem;
    
    WS(ws);
    NSMutableArray *items = [[NSMutableArray alloc] init];
    JMActionSheetItem *addCate = [[JMActionSheetItem alloc] init];
    addCate.title = ADD_CATEGORY_BUTTON_TITLE;
    addCate.action = ^(void){
        [ws addCate];
    };
    [items addObject:addCate];
    
    JMActionSheetItem *addFood = [[JMActionSheetItem alloc] init];
    addFood.title = ADD_FOOD_BUTTON_TITLE;
    addFood.action = ^(void){
        [ws addFood];
    };
    
    [items addObject:addFood];
    
    desc.items = items;
    [JMActionSheet showActionSheet:desc];
}
-(void)addFood
{
    NSArray *cateArray = [_linkTableView getLeftTableData];
    
    if (VALIDATE_ARRAY(cateArray))
    {
        [[KDRouterManger sharedManager] pushVCWithKey:@"KDEditFoodItemVC" parentVC:self params:@{FOOD_CATEGORY_ARRAY_KEY:cateArray} animate:YES vcDisappearBlock:^(NSString *vcKey, id params) {
            if (params && [params isKindOfClass:[NSDictionary class]])
            {
                NSString *str = [params objectForKey:COMMON_INPUT_RESULT_STRING_KEY];
                DDLogInfo(@"%@",str);
            }
        }];
    }
    else
    {
        
    }
}
-(void)addCate
{
    WS(ws);
    [[KDRouterManger sharedManager] pushVCWithKey:@"KDCommonTextEditVC" parentVC:self params:@{COMMON_INPUT_TITLE_KEY:ADD_CATEGORY_BUTTON_TITLE,COMMON_INPUT_INITSTRING_KEY:@"",COMMON_INPUT_CHARACTER_CONSTRAIN_KEY:[NSNumber numberWithInteger:SHORT_TEXT_CHARACTER_CONSTRAIN],COMMON_INPUT_STYLE_KEY:[NSNumber numberWithInteger:KDCommonInputStyleOfSingleRow]} animate:YES vcDisappearBlock:^(NSString *vcKey, id params) {
        if (params && [params isKindOfClass:[NSDictionary class]])
        {
            NSString *name = [params objectForKey:COMMON_INPUT_RESULT_STRING_KEY];
            DDLogInfo(@"%@",name);
            [ws sendAddFoodCategoryRequestWithName:name];
        }
    }];
}

-(void)sendAddFoodCategoryRequestWithName:(NSString *)name
{
    if (VALIDATE_STRING(name))
    {
        NSDictionary *param = @{REQUEST_KEY_NAME:name};
        [self showHUD];
        WS(ws);
        [KDRequestAPI sendAddFoodCateRequestWithParam:param completeBlock:^(id responseObject, NSError *error) {
            if (error)
            {
                [self hideHUD];
            }
            else
            {
                [ws requestInitDataWithFurterData:NO];
            }
        }];
    }
}
#pragma mark - LinkTable delegate
-(void)didSelectedAtIndexPath:(NSIndexPath *)indexPath params:(KDFoodCategoryModel *)params
{
    if (indexPath && params && [params isKindOfClass:[KDFoodCategoryModel class]])
    {
        WS(ws);
        [_viewModel startRequestFoodListWithID:params.category index:indexPath.row beginBlock:^{
            [ws showHUD];
        } completeBlock:^(BOOL isSuccess, id params, NSError *error) {
            [ws hideHUD];
            [ws.linkTableView updateRightTableData:params atIndex:indexPath.row];
        }];
    }
}

-(void)showHUDWithFlag:(BOOL)shouldShow
{
    if (shouldShow)
    {
        [self showHUD];
    }
    else
    {
        [self hideHUD];
    }
}
-(NSArray *)getFoodCategoryArray
{
    return [_viewModel getAllTableData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    DDLogInfo(@"-KDFoodManageViewController dealloc");
}

@end
