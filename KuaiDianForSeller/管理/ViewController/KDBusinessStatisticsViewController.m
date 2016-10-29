//
//  KDBusinessStatisticsViewController.m
//  KuaiDianForSeller
//
//  Created by ppnd on 16/10/27.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDBusinessStatisticsViewController.h"

@interface KDBusinessStatisticsViewController ()

@end

@implementation KDBusinessStatisticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNaviBarItemWithType:KDNavigationBackToPreviousVC];
    self.navigationItem.title = SALE_DETAIL_TITLE;
    // Do any additional setup after loading the view from its nib.
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
