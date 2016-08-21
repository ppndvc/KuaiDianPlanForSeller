//
//  AppDelegate.h
//  KuaiDianPlan
//
//  Created by ppnd on 16/6/10.
//  Copyright © 2016年 zy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

//获取tabbar
-(UITabBarController *)getTabbarVC;

@end

