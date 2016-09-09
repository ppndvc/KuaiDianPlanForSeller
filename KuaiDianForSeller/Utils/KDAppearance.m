//
//  KDAppearance.m
//  KuaiDianPlan
//
//  Created by ppnd on 16/6/11.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDAppearance.h"

@implementation KDAppearance
+ (void) setupAppearance
{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    [SVProgressHUD setBackgroundColor:HUD_BG_COLOR];
    [SVProgressHUD setForegroundColor:HUD_FG_COLOR];
    [SVProgressHUD setFont:[UIFont systemFontOfSize:HUD_FONT_SIZE]];

    //修改tabbar背景
    [[UITabBar appearance] setBarTintColor:TABBAR_BG_COLOR];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:TABBAR_SELECTED_TEXT_COLOR} forState:UIControlStateSelected];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:TEXT_FONT_SMALL_SIZE]} forState:UIControlStateNormal];
    
//    [[UINavigationBar appearance] setBarTintColor:NAVIBAR_BG_COLOR];
    [[UINavigationBar appearance] setTitleVerticalPositionAdjustment:0.0 forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:NAVIBAR_TITLE_COLOR,NSFontAttributeName:[UIFont systemFontOfSize:NAVIBAR_TITLE_FONT_SIZE],}];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:NAVIBAR_BG_IMAGE] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
}
@end
