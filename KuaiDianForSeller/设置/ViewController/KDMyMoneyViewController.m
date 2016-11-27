//
//  KDMyMoneyViewController.m
//  KuaiDianForSeller
//
//  Created by ppnd on 16/8/23.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDMyMoneyViewController.h"


#define BUTTON_WIDTH 60

@interface KDMyMoneyViewController ()

@end

@implementation KDMyMoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationItem.title = MY_MONEY;
    [self setNaviBarItemWithType:KDNavigationBackToPreviousVC];
    [self setupRightButton];
    
    // Do any additional setup after loading the view from its nib.
}
-(void)setupRightButton
{
    UIButton *rightBTN = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, BUTTON_WIDTH, TEXT_FONT_BIG_SIZE)];
    rightBTN.titleLabel.font = [UIFont systemFontOfSize:TEXT_FONT_MEDIUM_SIZE];
    [rightBTN setTitle:SEE_DETAIL forState:UIControlStateNormal];
    [rightBTN addTarget:self action:@selector(onTapRightBTN) forControlEvents:UIControlEventTouchUpInside];
    rightBTN.backgroundColor = [UIColor clearColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBTN];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)onTapRightBTN
{
    [[KDRouterManger sharedManager] pushVCWithKey:@"KDBillVC" parentVC:self];
}
- (IBAction)onTapChargeButton:(id)sender
{
    
}
@end
