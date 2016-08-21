//
//  KDRouterManger.m
//  KuaiDianPlan
//
//  Created by ppnd on 16/6/23.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDRouterManger.h"
#import "AppDelegate.h"

#define ROUTER_FILES @"RouterFiles"
#define CLASS_NAME @"ClassName"

#define SCHEME_SEPERATOR @"://"
#define PARAMETER_SEPERATOR @"?"
#define VALUE_SEPERATOR @"&"
#define EQUAL_SEPERATOR @"="

#define HTTP @"http://"
#define HTTPS @"https://"

#define PUSH @"push"
#define PRESENT @"present"

#define METHOD @"method"
#define VIEW_CONTROLLER @"vc"
#define PARAMS @"params"

#define PerformSelectorWithIgnoreWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

@interface KDRouterManger ()
//保存路由表的字典
@property(nonatomic,strong)NSMutableDictionary *routerDictionary;

@end

@implementation KDRouterManger

static KDRouterManger *sharedInstance;
+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[KDRouterManger alloc] init];
    });
    
    return sharedInstance;
}
-(instancetype)init
{
    self = [super init];
    
    if (self)
    {
        [self configureRouterPlist];
    }
    
    return self;
}
-(void)configureRouterPlist
{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:ROUTER_FILES ofType:@"plist"];
    if(VALIDATE_STRING(plistPath))
    {
        _routerDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    }
}

//以push的方式加载视图
-(void)pushVCWithKey:(NSString *)vcKey parentVC:(UIViewController *)parentVC
{
    [self pushVCWithKey:vcKey parentVC:parentVC params:nil animate:YES vcDisappearBlock:nil];
}

//以push的方式加载视图
-(void)pushVCWithKey:(NSString *)vcKey parentVC:(UIViewController *)parentVC  params:(id)params
{
    [self pushVCWithKey:vcKey parentVC:parentVC params:params animate:YES vcDisappearBlock:nil];
}

//以push的方式加载视图，有结束回调
-(void)pushVCWithKey:(NSString *)vcKey parentVC:(UIViewController *)parentVC  params:(id)params animate:(BOOL)animate vcDisappearBlock:(KDRouterVCDisappearBlock)vcDisappearBlock
{
    if (parentVC && [parentVC isKindOfClass:[UIViewController class]])
    {
        id vc = [self getVCFromVCKey:vcKey];
        if (vc)
        {
            //设置页面间传递的参数
            SEL setParamMethod = NSSelectorFromString(@"setVCParams:");
            
            if ([vc respondsToSelector:setParamMethod] && params)
            {
                PerformSelectorWithIgnoreWarning([vc performSelector:setParamMethod withObject:params]);
            }
            
            //默认设置代理（如果有）
            //            SEL setDelegate = NSSelectorFromString(@"setDelegate:");
            //
            //            if ([vc respondsToSelector:setDelegate])
            //            {
            //                PerformSelectorWithIgnoreWarning([vc performSelector:setDelegate withObject:parentVC]);
            //            }
            
            //设置页面pop回来的回调
            SEL setBlockMethod = NSSelectorFromString(@"setVCDisappearBlock:");
            
            if ([vc respondsToSelector:setBlockMethod] && vcDisappearBlock)
            {
                PerformSelectorWithIgnoreWarning([vc performSelector:setBlockMethod withObject:vcDisappearBlock]);
            }
            
            if ([[NSThread currentThread] isMainThread])
            {
                ((UIViewController *)vc).hidesBottomBarWhenPushed = YES;
                if ([parentVC.navigationController.viewControllers containsObject:vc])
                {
                    [parentVC.navigationController popToViewController:vc animated:animate];
                }
                else
                {
                    [parentVC.navigationController pushViewController:vc animated:animate];
                }
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    ((UIViewController *)vc).hidesBottomBarWhenPushed = YES;
                    if ([parentVC.navigationController.viewControllers containsObject:vc])
                    {
                        [parentVC.navigationController popToViewController:vc animated:animate];
                    }
                    else
                    {
                        [parentVC.navigationController pushViewController:vc animated:animate];
                    }
                });
            }
        }
    }
}

//以模态视图的方式加载视图
-(void)presentVCWithKey:(NSString *)vcKey parentVC:(UIViewController *)parentVC
{
    [self presentVCWithKey:vcKey parentVC:parentVC params:nil  animate:YES vcAppearBlock:nil vcDisappearBlock:nil];
}

//以模态视图的方式加载视图，有dismiss回调
-(void)presentVCWithKey:(NSString *)vcKey parentVC:(UIViewController *)parentVC params:(id)params vcDisappearBlock:(KDRouterVCDisappearBlock)vcDisappearBlock
{
    [self presentVCWithKey:vcKey parentVC:parentVC params:params animate:YES vcAppearBlock:nil vcDisappearBlock:vcDisappearBlock];
}

//以模态视图的方式加载视图，有dismiss回调
-(void)presentVCWithKey:(NSString *)vcKey parentVC:(UIViewController *)parentVC params:(id)params animate:(BOOL)animate vcAppearBlock:(KDRouterVCAppearBlock)vcAppearBlock vcDisappearBlock:(KDRouterVCDisappearBlock)vcDisappearBlock
{
    if (parentVC && [parentVC isKindOfClass:[UIViewController class]])
    {
        id vc = [self getVCFromVCKey:vcKey];
        if (vc)
        {
            //设置页面间传递的参数
            SEL setParamMethod = NSSelectorFromString(@"setVCParams:");
            
            if ([vc respondsToSelector:setParamMethod] && params)
            {
                PerformSelectorWithIgnoreWarning([vc performSelector:setParamMethod withObject:params]);
            }
            
            //设置页面dismiss回来的回调
            SEL setBlockMethod = NSSelectorFromString(@"setVCDisappearBlock:");
            
            if ([vc respondsToSelector:setBlockMethod] && vcDisappearBlock)
            {
                PerformSelectorWithIgnoreWarning([vc performSelector:setBlockMethod withObject:vcDisappearBlock]);
            }
            
            
            if (![[NSThread currentThread] isMainThread])
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [parentVC presentViewController:vc animated:animate completion:vcAppearBlock];
                });
            }
            else
            {
                [parentVC presentViewController:vc animated:animate completion:vcAppearBlock];
            }
        }
    }
}

-(id)getVCFromVCKey:(NSString *)vcKey
{
    id vc = nil;
    if (VALIDATE_STRING(vcKey) && _routerDictionary)
    {
        NSDictionary *classDict = [_routerDictionary objectForKey:vcKey];
        if (classDict)
        {
            NSString *classString = [classDict objectForKey:CLASS_NAME];
            if (VALIDATE_STRING(classString))
            {
                Class classFromString = NSClassFromString(classString);
                vc = [[classFromString alloc] init];
            }
        }
    }
    
    return vc;
}
-(UIViewController *)currentSelectedVC
{
    UIViewController *vc = nil;
    
    UITabBarController *tabbarVC = [(AppDelegate*)[[UIApplication sharedApplication] delegate] getTabbarVC];
    if (tabbarVC)
    {
        UINavigationController *navi = tabbarVC.selectedViewController;
        if (navi)
        {
            vc = [navi.viewControllers lastObject];
        }
    }
    
    return vc;
}
-(void)routeVCWithURL:(NSString *__null_unspecified)urlString
{
    if (VALIDATE_STRING(urlString))
    {
        NSDictionary *params = [KDRouterManger getParametersFromUELString:urlString];
        if (params && [params isKindOfClass:[NSDictionary class]])
        {
            UIViewController *currentVC = [self currentSelectedVC];
            if (currentVC)
            {
                NSString *methodStr = [params objectForKey:METHOD];
                
                if (VALIDATE_STRING(methodStr))
                {
                    if ([methodStr isEqualToString:PUSH])
                    {
                        [self pushVCWithKey:[params objectForKey:VIEW_CONTROLLER] parentVC:currentVC params:[params objectForKey:PARAMS]];
                    }
                    else if([methodStr isEqualToString:PRESENT])
                    {
                        [self presentVCWithKey:[params objectForKey:VIEW_CONTROLLER] parentVC:currentVC params:[params objectForKey:PARAMS] animate:YES vcAppearBlock:nil vcDisappearBlock:nil];
                    }
                    else
                    {
                        DDLogInfo(@"无法识别的跳转方式");
                    }
                }
            }
        }
    }
}
+(NSDictionary *)getParametersFromUELString:(NSString *)urlString
{
    __block NSMutableDictionary *dict = nil;
    if (VALIDATE_STRING(urlString))
    {
        dict = [[NSMutableDictionary alloc] init];
        
        dispatch_sync(dispatch_get_global_queue(0, 0), ^{
            
            if ([urlString hasPrefix:HTTP] || [urlString hasPrefix:HTTPS])
            {
                [dict setObject:PUSH forKey:METHOD];
                [dict setObject:@"WebVC" forKey:VIEW_CONTROLLER];
                [dict setObject:@{@"url":urlString} forKey:PARAMS];
            }
            else
            {
                if ([urlString containSubStr:SCHEME_SEPERATOR])
                {
                    NSArray *schemeArray = [urlString componentsSeparatedByString:SCHEME_SEPERATOR];
                    
                    if (schemeArray && schemeArray.count == 2)
                    {
                        [dict setObject:schemeArray[0] forKey:METHOD];
                        
                        if ([((NSString *)schemeArray[1]) containSubStr:PARAMETER_SEPERATOR])
                        {
                            NSArray *vcArray = [((NSString *)schemeArray[1]) componentsSeparatedByString:PARAMETER_SEPERATOR];
                            
                            if (vcArray)
                            {
                                [dict setObject:vcArray[0] forKey:VIEW_CONTROLLER];
                                NSString *paramStr = vcArray[1];
                                
                                if (VALIDATE_STRING(paramStr))
                                {
                                    NSArray *paramArray = [paramStr componentsSeparatedByString:VALUE_SEPERATOR];
                                    NSDictionary *paramDict = [KDRouterManger getEqualParamFromArray:paramArray];
                                    if (paramDict)
                                    {
                                        [dict setObject:paramDict forKey:PARAMS];
                                    }
                                }
                            }
                        }
                        else
                        {
                            [dict setObject:schemeArray[1] forKey:VIEW_CONTROLLER];
                        }
                    }
                }
            }
        });
    }
    return dict;
}
+(NSDictionary *)getEqualParamFromArray:(NSArray *)array
{
    __block NSMutableDictionary *dict = nil;

    if (array && [array isKindOfClass:[NSArray class]] && array.count > 0)
    {
        dict = [[NSMutableDictionary alloc] init];
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *str = obj;
            NSArray *ta = [str componentsSeparatedByString:EQUAL_SEPERATOR];
            
            if (ta && ta.count == 2)
            {
                [dict setObject:ta[1] forKey:ta[0]];
            }
        }];
    }
    
    return dict;
}
@end
