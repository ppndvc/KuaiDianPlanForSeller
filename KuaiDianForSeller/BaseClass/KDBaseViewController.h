//
//  KDBaseViewController.h
//  KuaiDianPlan
//
//  Created by ppnd on 16/6/11.
//  Copyright © 2016年 zy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KDRouterManger.h"
#import "KDCacheManager.h"

@interface KDBaseViewController : UIViewController

//页面参数
@property(nonatomic,strong) NSDictionary *parameters;


//网络是否可达
-(BOOL)isNetworkReachable;

-(void)showHUD;
-(void)hideHUD;

-(void)showHUDWithInfo:(NSString *)info;

//设置参数
-(void)setVCParams:(NSDictionary *)params;

//设置导航栏后退按钮
-(void)setNaviBarItemWithType:(KDNavigationBackType)type;

//返回事件
-(void)leftBarButtonAction;

@end
