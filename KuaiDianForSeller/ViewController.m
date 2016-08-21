//
//  ViewController.m
//  KuaiDianPlan
//
//  Created by ppnd on 16/6/10.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "ViewController.h"
#import "KDEnvironmentManager.h"
#import "KDCacheManager.h"

@interface ViewController ()

@end

@implementation ViewController

//- (void)viewDidLoad {
//    [super viewDidLoad];
//    self.title = @"标题";
//    NSLog(@"viewDidLoad");
//    // Do any additional setup after loading the view, typically from a nib.
//}
-(void)loadView
{
    id env = [KDEnvironmentManager sharedInstance];
    id cac = [KDCacheManager sharedInstance];
    
    id env2 = [KDEnvironmentManager sharedInstance];
    id cac2 = [KDCacheManager sharedInstance];
    UIView *view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen]bounds]];
    view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    view.autoresizesSubviews = YES;
    view.backgroundColor = [UIColor grayColor];
    self.view = view;
    DDLogInfo(@"loadView");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
