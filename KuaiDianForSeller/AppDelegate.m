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
//#import "KDVCViewController.h"

@interface AppDelegate ()

//tabbar
@property(nonatomic,strong)UITabBarController *tabBarController;

//登陆页面
@property(nonatomic,strong)UINavigationController *loginVC;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//    [[KDUserManager sharedInstance] logout];
    
    //设置主题颜色
    [KDAppearance setupAppearance];
    
    //开始日志
    [[KDLoggerManager sharedInstance] startLoggingWithOptions:launchOptions];
    
    //设置window
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    

    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    
    if (![KDUserManager isUserLogin])
    {
        [self.tabBarController presentViewController:self.loginVC animated:NO completion:nil];
    }
    
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
        [vc setDisapperBlock:^(NSString *vcKey, id params) {
            ws.window.rootViewController = ws.tabBarController;
        }];
        
        _loginVC = [[UINavigationController alloc] initWithRootViewController:vc];
    }
    
    return _loginVC;
}
- (UITabBarController *)tabBarController
{
    if (!_tabBarController)
    {
        _tabBarController = [[UITabBarController alloc] init];
//        _tabBarController.delegate = self;
        _tabBarController.tabBar.backgroundColor = [UIColor whiteColor];
        
        
        //
        KDMainPageController * mainPage =[[KDMainPageController alloc] init];
        UINavigationController *mainPageNavi = [[UINavigationController alloc] initWithRootViewController:mainPage];
        mainPageNavi.navigationBar.translucent = NO;
        mainPageNavi.tabBarItem.title = TABBAR_UNHANDLE_TITLE;
        //创建图片
        mainPageNavi.tabBarItem.image = [UIImage imageNamed:TABBAR_MAINPAGE_IMAGE_SELECTED];
        mainPageNavi.tabBarItem.selectedImage = [[UIImage imageNamed:TABBAR_MAINPAGE_IMAGE_SELECTED]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        
        //创建
        UIViewController * vc2 =[[UIViewController alloc] init];
        UINavigationController *orderPageNavi = [[UINavigationController alloc] initWithRootViewController:vc2];
        orderPageNavi.navigationBar.translucent = NO;
        orderPageNavi.tabBarItem.title = TABBAR_HANDLE_TITLE;
        //创建图片
        orderPageNavi.tabBarItem.image = [UIImage imageNamed:TABBAR_ORDER_IMAGE_SELECTED];
        orderPageNavi.tabBarItem.selectedImage = [[UIImage imageNamed:TABBAR_ORDER_IMAGE_SELECTED] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        //创建
        KDLoginViewController * vc3 =[[KDLoginViewController alloc] init];
        UINavigationController *secKillPageNavi = [[UINavigationController alloc] initWithRootViewController:vc3];
        secKillPageNavi.navigationBar.translucent = NO;
        secKillPageNavi.tabBarItem.title = TABBAR_MANAGEMENT_TITLE;
        //创建图片
        secKillPageNavi.tabBarItem.image = [UIImage imageNamed:TABBAR_FASTMEAL_IMAGE_SELECTED];
        secKillPageNavi.tabBarItem.selectedImage = [[UIImage imageNamed:TABBAR_FASTMEAL_IMAGE_SELECTED] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        //创建
        KDSettingsViewController * vc4 =[[KDSettingsViewController alloc] init];
        UINavigationController *myPageNavi = [[UINavigationController alloc] initWithRootViewController:vc4];
        myPageNavi.navigationBar.translucent = NO;
        myPageNavi.tabBarItem.title = TABBAR_SETTING_TITLE;
        //创建图片
        myPageNavi.tabBarItem.image = [UIImage imageNamed:TABBAR_MINE_IMAGE_SELECTED];
        myPageNavi.tabBarItem.selectedImage = [[UIImage imageNamed:TABBAR_MINE_IMAGE_SELECTED] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

        
        _tabBarController.viewControllers = @[mainPageNavi,orderPageNavi,secKillPageNavi,myPageNavi];
        [_tabBarController setSelectedViewController:mainPageNavi];
    }
    
    return _tabBarController;
}
@end
