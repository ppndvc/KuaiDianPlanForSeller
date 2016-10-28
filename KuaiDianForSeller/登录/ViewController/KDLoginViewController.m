//
//  KDLoginViewController.m
//  KuaiDianForSeller
//
//  Created by ppnd on 16/8/10.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDLoginViewController.h"
#import "KDRequestAPI.h"
#import "KDLoginViewModel.h"
#import "KDOrderModel.h"

#define LOGIN_NAME @"sellername"
#define LOGIN_PWD @"password"

#define IF_REMEMBER_LOGIN @"1"

#define BUTTON_WIDTH 80

@interface KDLoginViewController ()

//结束回调
@property(nonatomic,copy)KDRouterVCDisappearBlock disappearBlock;

@property(nonatomic,strong)KDLoginViewModel *viewModel;

@end

@implementation KDLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = LOGIN_TITLE;
    [self setNaviBarItemWithType:KDNavigationNoBackAction];
    
    _viewModel = [[KDLoginViewModel alloc] init];
    [self setupUI];
    
}
-(void)setupUI
{
    UIButton *rightBTN = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, BUTTON_WIDTH, TEXT_FONT_BIG_SIZE)];
    rightBTN.titleLabel.font = [UIFont systemFontOfSize:TEXT_FONT_BIG_SIZE];
    [rightBTN setTitle:FORGOT_PASSWORD forState:UIControlStateNormal];
    [rightBTN addTarget:self action:@selector(onTapRightBTN) forControlEvents:UIControlEventTouchUpInside];
    rightBTN.backgroundColor = [UIColor clearColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBTN];
}

//设置结束回调
-(void)setDisapperBlock:(KDRouterVCDisappearBlock)disappearBlock
{
    _disappearBlock = disappearBlock;
}

-(void)dismissVC
{
    [self dismissViewControllerAnimated:YES completion:^{
        if (_disappearBlock)
        {
            if ([NSThread isMainThread])
            {
                _disappearBlock(nil,nil);
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    _disappearBlock(nil,nil);
                });
            }
        }

    }];
}

- (IBAction)onTapLoginButton:(id)sender
{
    NSString *name = @"test";// _userNameTextField.text;
    NSString *pwd = @"888888";//_passwordTextField.text;

    if (VALIDATE_STRING(name) && VALIDATE_STRING(pwd))
    {
        WS(ws);
        
        [_viewModel startLoginWithParams:@{LOGIN_NAME:name,LOGIN_PWD:pwd,REQUEST_KEY_REMEMBER_ME:IF_REMEMBER_LOGIN} beginBlock:^{
            [ws showHUD];
        } completeBlock:^(BOOL isSuccess, id params, NSError *error) {
            if (isSuccess)
            {
                [ws hideHUD];
                [ws dismissVC];
            }
            else
            {
                [ws showErrorHUDWithStatus:[error localizedDescription]];
            }
        }];
    }
    else
    {
        [self showHUDWithInfo:@"请输入正确的用户名或密码"];
    }
}

-(void)logout
{
    [KDRequestAPI sendLogoutRequestWithCompleteBlock:^(id responseObject, NSError *error) {
        if (error)
        {
            DDLogInfo(@"登陆请求失败：%@",error.localizedDescription);
        }
        else
        {
            //            [ws dismissVC];
        }
    }];
}


-(void)onTapRightBTN
{
    [[KDRouterManger sharedManager] pushVCWithKey:@"ForgotPasswordVC" parentVC:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    DDLogInfo(@"- KDLoginViewController dealloc");
}
@end
