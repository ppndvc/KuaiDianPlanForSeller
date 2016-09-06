//
//  KDEditFoodViewController.m
//  KuaiDianForSeller
//
//  Created by ppnd on 16/8/24.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDEditFoodViewController.h"

#define HEADERVIEW_HEIGHT 120

@interface KDEditFoodViewController ()

//数据源
@property(nonatomic,strong)NSArray *dataSource;

//headerview
@property(nonatomic,strong)UIImageView *headerView;

//footerveiw
@property(nonatomic,strong)UIView *footerView;

//确定按钮
@property(nonatomic,strong)UIButton *sureButton;

//取消按钮
@property(nonatomic,strong)UIButton *cancelButton;

//菜品
@property(nonatomic,strong)UITextField *foodTextField;

//描述
@property(nonatomic,strong)UITextField *descriptionTextField;

//分类
@property(nonatomic,strong)UITextField *cateTextField;

//单价
@property(nonatomic,strong)UITextField *priceTextField;

//标签
@property(nonatomic,strong)UIView *labelView;

@end

@implementation KDEditFoodViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = FOOD_EDIT_TITLE;
    [self setNaviBarItemWithType:KDNavigationBackToPreviousVC];
    
    _dataSource = @[@[FOOD_NAME,FOOD_DESCRIPTION],@[FOOD_CATEFORY,FOOD_PRICE,FOOD_LABEL]];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIImageView *)headerView
{
    if (!_headerView)
    {
        _headerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, HEADERVIEW_HEIGHT)];
        _headerView.image = [UIImage imageNamed:@""];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapHeaderView)];
        _headerView.userInteractionEnabled = YES;
        [_headerView addGestureRecognizer:tap];
    }
    
    return _headerView;
}
-(UIView *)footerView
{
    if (!_footerView)
    {
        CGFloat viewHeight = 2*BUTTON_HEIGHT + 3*VIEW_VERTICAL_PADDING;
        
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, viewHeight)];
        
        _sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sureButton addTarget:self action:@selector(onTapSureButton) forControlEvents:UIControlEventTouchUpInside];
        _sureButton.layer.cornerRadius = CORNER_RADIUS;
        [_sureButton setTitle:BUTTON_TITLE_SURE forState:UIControlStateNormal];
        [_sureButton setBackgroundColor:APPD_RED_COLOR];
        [_sureButton setFrame:CGRectMake(VIEW_HORIZONTAL_PADDING_TO_SCREEN_BORDER, VIEW_VERTICAL_PADDING, SCREEN_WIDTH - 2*VIEW_HORIZONTAL_PADDING_TO_SCREEN_BORDER, BUTTON_HEIGHT)];
        [_footerView addSubview:_sureButton];
        
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton addTarget:self action:@selector(onTapCancelButton) forControlEvents:UIControlEventTouchUpInside];
        _cancelButton.layer.cornerRadius = CORNER_RADIUS;
        [_cancelButton setTitle:BUTTON_TITLE_CANCEL forState:UIControlStateNormal];
        [_cancelButton setBackgroundColor:TEXT_HIGH_COLOR];
        [_cancelButton setFrame:CGRectMake(VIEW_HORIZONTAL_PADDING_TO_SCREEN_BORDER, 2*VIEW_VERTICAL_PADDING + BUTTON_HEIGHT, SCREEN_WIDTH - 2*VIEW_HORIZONTAL_PADDING_TO_SCREEN_BORDER, BUTTON_HEIGHT)];
        [_footerView addSubview:_cancelButton];
    }
    
    return _footerView;
}
-(void)textFieldDidBeginEditing:(UITextField*)textField
{
    
    [textField resignFirstResponder];
    
}
-(void)onTapHeaderView
{
    DDLogInfo(@"--- onTapHeaderView ---");

}
-(void)onTapSureButton
{
    
}
-(void)onTapCancelButton
{
    
}
-(void)dealloc
{
    DDLogInfo(@"-KDEditFoodViewController dealloc");
}

- (IBAction)onTapFoodName:(id)sender
{
    DDLogInfo(@"--- onTapFoodName ---");
}

- (IBAction)onTapFoodDesc:(id)sender {
}

- (IBAction)onTapFoodCate:(id)sender {
}

- (IBAction)onTapFoodPrice:(id)sender {
}

- (IBAction)onTapDelete:(id)sender {
}

- (IBAction)onTapSure:(id)sender {
}
@end
