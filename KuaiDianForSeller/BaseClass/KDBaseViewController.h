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
#import "KDErrorPageView.h"
#import <JCAlertView/JCAlertView.h>
#import "UINavigationController+FDFullscreenPopGesture.h"

@interface KDBaseViewController : UIViewController

//页面参数
@property(nonatomic,strong) NSDictionary *parameters;
//视图消息回调
@property(nonatomic,copy) KDRouterVCDisappearBlock vcDisappearBlock;
//试图出现回调
@property(nonatomic,copy) KDRouterVCAppearBlock vcAppearBlock;
//错误页面
@property(nonatomic,strong)KDErrorPageView *errorPage;

//网络是否可达
-(BOOL)isNetworkReachable;

-(void)showHUD;
-(void)hideHUD;

//菊花并有文字
-(void)showHUDWithStatus:(NSString *)status;

//显示提示信息
-(void)showHUDWithInfo:(NSString *)info;
//显示成功信息
-(void)showSuccessHUDWithStatus:(NSString *)status;
//显示失败信息
-(void)showErrorHUDWithStatus:(NSString *)status;

//设置参数
-(void)setVCParams:(NSDictionary *)params;

//设置结束回调
-(void)setVCDisappearBlock:(KDRouterVCDisappearBlock)block;

//设置导航栏后退按钮
-(void)setNaviBarItemWithType:(KDNavigationBackType)type;

//返回事件
-(void)leftBarButtonAction;

//显示错误页面
-(void)showErrorPageWithCompleteBlock:(KDNetworkErrorPageTapBlock)tapBlock;

//隐藏错误页面
-(void)hideErrorPage;
@end
