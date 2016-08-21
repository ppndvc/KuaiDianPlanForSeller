//
//  KDMallViewController.m
//  KuaiDianPlan
//
//  Created by ppnd on 16/8/5.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDMallViewController.h"
#import "KDDropMenu.h"

#define DROPMENU_HEIGHT 33.5f

@interface KDMallViewController ()<UITableViewDataSource,UITableViewDelegate>

//下拉菜单
@property(nonatomic,strong)KDDropMenu *dropMnu;

//tableview
@property(nonatomic,strong)UITableView *tableView;

@end

@implementation KDMallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = [self getTitleWithTypeStr:[self.parameters objectForKey:@"type"]];
    [self setNaviBarItemWithType:KDNavigationBackToPreviousVC];
    [self setupUI];
    // Do any additional setup after loading the view.
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_dropMnu hideDropMenuAnimated:NO];
}
-(void)setupUI
{
    _dropMnu = [[KDDropMenu alloc] initDropMenuWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, DROPMENU_HEIGHT) clipsBackground:YES];
    
    UIView *v1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 100)];
    v1.backgroundColor = [UIColor yellowColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, v1.frame.size.width, 40)];
    label.text = @"sdfadfaaffsf";
    [v1 addSubview:label];
    [_dropMnu addDropMenuItemWith:CATEGORY_SEARCH customView:v1];
    UIView *v2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 150)];
    v2.backgroundColor = [UIColor redColor];
    [_dropMnu addDropMenuItemWith:SORT_SEARCH customView:v2];
    
    UIView *v3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 150)];
    v3.backgroundColor = [UIColor greenColor];
    [_dropMnu addDropMenuItemWith:FILTER_SEARCH customView:v3];
    
    [self.view addSubview:_dropMnu];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, DROPMENU_HEIGHT, SCREEN_WIDTH, self.view.frame.size.height - DROPMENU_HEIGHT) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    
//    _tableView.dataSource = self;
//    _tableView.delegate = self;
}
-(NSString *)getTitleWithTypeStr:(NSString *)str
{
    NSString *title = APP_NAME;
    
    if (VALIDATE_STRING(str))
    {
        KDMallType type = [str integerValue];
        switch (type)
        {
            case KDMallTypeOfDeliciousFood:
            {
                title = DELICIOUS_FOOD;
            }
                break;
            case KDMallTypeOfBrandShop:
            {
                title = BRAND_SHOP;
            }
                break;
            case KDMallTypeOfNormalShop:
            {
                title = NORMAL_SHOP;
            }
                break;
            case KDMallTypeOfBreakFast:
            {
                title = BREAKFAST;
            }
                break;
            default:
                break;
        }
    }
    return title;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
