//
//  AppDelegate.m
//  KuaiDianPlan
//
//  Created by ppnd on 16/6/10.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "AppDelegate.h"
#import "KDAppearance.h"
#import "ViewController.h"
#import "KDLoggerManager.h"
#import "KDMainPageController.h"
#import "KDLoginViewController.h"
#import "KDUserManager.h"
#import "KDSettingsViewController.h"
#import "KDUnhandleOrderViewController.h"
#import "KDEditFoodViewController.h"
#import "KDManageViewController.h"
#import "KDHandleListViewController.h"
#import "KDTabBarController.h"
#import "KDMallViewController.h"

@interface AppDelegate ()

//tabbar
@property(nonatomic,strong)UITabBarController *tabBarController;

//登陆页面
@property(nonatomic,strong)UINavigationController *loginVC;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //设置主题颜色
    [KDAppearance setupAppearance];
    
    //开始日志
    [[KDLoggerManager sharedInstance] startLoggingWithOptions:launchOptions];
    
    //设置window
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [self initTabBarController];
    
    // Override point for customization after application launch.
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
-(UITabBarController *)getTabbarVC
{
    return self.tabBarController;
}
-(UINavigationController *)loginVC
{
    if (!_loginVC)
    {
        WS(ws);
        KDLoginViewController *vc = [[KDLoginViewController alloc] init];
        _loginVC = [[UINavigationController alloc] initWithRootViewController:vc];
        [_loginVC.navigationBar setBarTintColor:NAVIBAR_BG_COLOR];
    }
    
    return _loginVC;
}
- (void)initTabBarController
{
    if (!_tabBarController)
    {
        _tabBarController = [[UITabBarController alloc] init];
//        _tabBarController.delegate = self;
        _tabBarController.tabBar.backgroundColor = [UIColor whiteColor];
        
        
        //
        KDHandleListViewController * mainPage =[[KDHandleListViewController alloc] init];
        UINavigationController *mainPageNavi = [[UINavigationController alloc] initWithRootViewController:mainPage];
        mainPageNavi.navigationBar.translucent = NO;
        mainPageNavi.tabBarItem.title = TABBAR_HANDLE_TITLE;
        //创建图片
        mainPageNavi.tabBarItem.image = [UIImage imageNamed:TABBAR_UNHANDLED_IMAGE_NORMAL];
        mainPageNavi.tabBarItem.selectedImage = [[UIImage imageNamed:TABBAR_UNHANDLED_IMAGE_SELECTED]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        
        //创建
        KDUnhandleOrderViewController * vc2 =[[KDUnhandleOrderViewController alloc] init];
        UINavigationController *orderPageNavi = [[UINavigationController alloc] initWithRootViewController:vc2];
        orderPageNavi.navigationBar.translucent = NO;
        orderPageNavi.tabBarItem.title = TABBAR_UNHANDLE_TITLE;
        //创建图片
        orderPageNavi.tabBarItem.image = [UIImage imageNamed:TABBAR_HANDLED_IMAGE_NORMAL];
        orderPageNavi.tabBarItem.selectedImage = [[UIImage imageNamed:TABBAR_HANDLED_IMAGE_SELECTED] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        //创建
        KDManageViewController * vc3 =[[KDManageViewController alloc] init];
        UINavigationController *secKillPageNavi = [[UINavigationController alloc] initWithRootViewController:vc3];
        secKillPageNavi.navigationBar.translucent = NO;
        secKillPageNavi.tabBarItem.title = TABBAR_MANAGEMENT_TITLE;
        //创建图片
        secKillPageNavi.tabBarItem.image = [UIImage imageNamed:TABBAR_MANAGMENT_IMAGE_NORMAL];
        secKillPageNavi.tabBarItem.selectedImage = [[UIImage imageNamed:TABBAR_MANAGMENT_IMAGE_SELECTED] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        //创建
        KDSettingsViewController * vc4 =[[KDSettingsViewController alloc] init];
        UINavigationController *myPageNavi = [[UINavigationController alloc] initWithRootViewController:vc4];
        myPageNavi.navigationBar.translucent = NO;
        myPageNavi.tabBarItem.title = TABBAR_SETTING_TITLE;
        //创建图片
        myPageNavi.tabBarItem.image = [UIImage imageNamed:TABBAR_SETTING_IMAGE_NORMAL];
        myPageNavi.tabBarItem.selectedImage = [[UIImage imageNamed:TABBAR_SETTING_IMAGE_SELECTED] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

        
        _tabBarController.viewControllers = @[orderPageNavi,mainPageNavi,secKillPageNavi,myPageNavi];
        [_tabBarController setSelectedViewController:orderPageNavi];
        [self.window setRootViewController:_tabBarController];
        
//        if (![KDUserManager isUserLogin])
        {
            [self.window.rootViewController presentViewController:self.loginVC animated:NO completion:nil];
        }
    }
}
@end
