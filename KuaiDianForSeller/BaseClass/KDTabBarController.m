//
//  KDTabBarController.m
//  KuaiDianForSeller
//
//  Created by ppnd on 16/9/9.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDTabBarController.h"
#import "KDLoginViewController.h"


@interface KDTabBarController ()

@end

@implementation KDTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
//    KDLoginViewController *vc = [[KDLoginViewController alloc] initWithNibName:nil bundle:nil];
//    
//    UINavigationController *loginVC = [[UINavigationController alloc] initWithRootViewController:vc];
//    [self presentViewController:loginVC animated:NO completion:nil];
    
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
