//
//  KDRouterManger.h
//  KuaiDianPlan
//
//  Created by ppnd on 16/6/23.
//  Copyright © 2016年 zy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KDRouterManger : NSObject

+(instancetype __null_unspecified)new NS_UNAVAILABLE;
//类方法
+(instancetype __null_unspecified)sharedManager;

//初始化路由表
-(void)configureRouterPlist;


//根据url路由
-(void)routeVCWithURL:(NSString *__null_unspecified)urlString;

//以push的方式加载视图
-(void)pushVCWithKey:(NSString *__null_unspecified)vcKey parentVC:(UIViewController *__null_unspecified)parentVC;
//以push的方式加载视图
-(void)pushVCWithKey:(NSString *__null_unspecified)vcKey parentVC:(UIViewController *__null_unspecified)parentVC  params:(id __null_unspecified)params;
//以push的方式加载视图，有结束回调
-(void)pushVCWithKey:(NSString *__null_unspecified)vcKey parentVC:(UIViewController *__null_unspecified)parentVC  params:(id __null_unspecified)params animate:(BOOL)animate vcDisappearBlock:(KDRouterVCDisappearBlock __null_unspecified)vcDisappearBlock;


//以模态视图的方式加载视图
-(void)presentVCWithKey:(NSString *__null_unspecified)vcKey parentVC:(UIViewController *__null_unspecified)parentVC hasNavigator:(BOOL)hasNavigator animate:(BOOL)animate;

//以模态视图的方式加载视图，有dismiss回调
-(void)presentVCWithKey:(NSString *__null_unspecified)vcKey parentVC:(UIViewController *__null_unspecified)parentVC params:(id __null_unspecified)params hasNavigator:(BOOL)hasNavigator vcDisappearBlock:(KDRouterVCDisappearBlock __null_unspecified)vcDisappearBlock;

//以模态视图的方式加载视图，有dismiss回调
-(void)presentVCWithKey:(NSString *__null_unspecified)vcKey parentVC:(UIViewController *__null_unspecified)parentVC params:(id __null_unspecified)params hasNavigator:(BOOL)hasNavigator animate:(BOOL)animate vcAppearBlock:(KDRouterVCAppearBlock __null_unspecified)vcAppearBlock vcDisappearBlock:(KDRouterVCDisappearBlock __null_unspecified)vcDisappearBlock;
@end