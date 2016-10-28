//
//  KDBaseViewController.m
//  KuaiDianPlan
//
//  Created by ppnd on 16/6/11.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDBaseViewController.h"
#import "KDNetworkReachableManager.h"

#define BACK_BUTTON_WIDTH 12
#define BACK_BUTTON_HEIGHT 20

@interface KDBaseViewController ()

//导航栏左侧按钮
@property(nonatomic,strong)UIButton *leftBarButton;

//返回类型
@property(nonatomic,assign)KDNavigationBackType backType;

@end

@implementation KDBaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    self.view.backgroundColor = APP_BG_COLOR;
    [self setNaviBarItemWithType:KDNavigationNoBackAction];
    
//    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
//    self.view.autoresizesSubviews = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //网络状态回调
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkingReachabilityStatusDidChange:) name:KDNetworkingReachabilityDidChangeNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:KDNetworkingReachabilityDidChangeNotification object:nil];
    [SVProgressHUD dismiss];
}

-(BOOL)isNetworkReachable
{
    return [[KDNetworkReachableManager sharedManager]isReachable];
}

-(void)networkingReachabilityStatusDidChange:(NSNotification*)notification
{
    NSDictionary *userInfo = [notification userInfo];
    if (userInfo && userInfo.allKeys.count > 0)
    {
        KDNetworkReachabilityStatus status = [[userInfo objectForKey:KDNetworkingReachabilityNotificationStatusItem]integerValue];
        if (status != KDNetworkReachabilityStatusNotReachable)
        {
            [self networkDidBecomeReachable];
        }
    }
}
-(void)showErrorPageWithType:(KDNetworkErrorType)type onTapAction:(KDNetworkErrorPageTapBlock)tapBlock
{
    
}
-(void)setNaviBarItemWithType:(KDNavigationBackType)type
{
    _backType = type;
    if (type == KDNavigationNoBackAction)
    {
        self.navigationItem.leftBarButtonItem = nil;
    }
    else
    {
        _leftBarButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, BACK_BUTTON_WIDTH, BACK_BUTTON_HEIGHT)];
        
        [_leftBarButton setBackgroundImage:[UIImage imageNamed:@"navi_back_array"] forState:UIControlStateNormal];
        [_leftBarButton addTarget:self action:@selector(leftBarButtonAction) forControlEvents:UIControlEventTouchUpInside];
        _leftBarButton.backgroundColor = [UIColor clearColor];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_leftBarButton];
    }
}
-(void)leftBarButtonAction
{
    if (_backType == KDNavigationBackToPreviousVC)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if (_backType == KDNavigationBackToRootVC)
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}
-(void)networkDidBecomeReachable
{
    //需要子类重载
}

//需要子类重载
-(void)applicationDidBecomeActive:(NSNotification*)notification
{
    
}

//需要子类重载
-(void)applicationWillEnterForeground:(NSNotification*)notification
{
    
}

//需要子类重载
- (void)applicationDidEnterBackground:(NSNotification*)notification
{
    
}

#pragma mark - HUD methods
-(void)showHUD
{
    if ([NSThread isMainThread])
    {
        [SVProgressHUD show];
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD show];
        });
    }
}
-(void)showHUDWithStatus:(NSString *)status
{
    if ([NSThread isMainThread])
    {
        [SVProgressHUD showWithStatus:status];
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showWithStatus:status];
        });
    }
}
-(void)hideHUD
{
    if ([NSThread isMainThread])
    {
        [SVProgressHUD dismiss];
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
    }
}

-(void)showHUDWithInfo:(NSString *)info
{
    if ([NSThread isMainThread])
    {
        [SVProgressHUD showInfoWithStatus:info];
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showInfoWithStatus:info];
        });
    }
}
-(void)showSuccessHUDWithStatus:(NSString *)status
{
    if ([NSThread isMainThread])
    {
        [SVProgressHUD showSuccessWithStatus:status];
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showSuccessWithStatus:status];
        });
    }
}
-(void)showErrorHUDWithStatus:(NSString *)status
{
    if ([NSThread isMainThread])
    {
        [SVProgressHUD showErrorWithStatus:status];
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showErrorWithStatus:status];
        });
    }
}
-(void)setVCParams:(NSDictionary *)params
{
    if (VALIDATE_DICTIONARY(params))
    {
        _parameters = [[NSDictionary alloc] initWithDictionary:params];
    }
}

-(void)setVCDisappearBlock:(KDRouterVCDisappearBlock)block
{
    if (block)
    {
        _vcDisappearBlock = block;
    }
}
-(void)showErrorPageWithCompleteBlock:(KDNetworkErrorPageTapBlock)tapBlock
{
    _errorPage = nil;
    
    _errorPage = [KDErrorPageView errorPageWithFrame:self.view.bounds tapBlock:tapBlock];
    [self.view addSubview:_errorPage];
}
-(void)hideErrorPage
{
    if (_errorPage)
    {
        [_errorPage hide];
    }
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
