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
    _viewModel = [[KDLoginViewModel alloc] init];
    [self setupRightButton];
    
}
-(void)setupRightButton
{
    UIButton *rightBTN = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, BUTTON_WIDTH, TEXT_FONT_BIG_SIZE)];
    rightBTN.titleLabel.font = [UIFont systemFontOfSize:TEXT_FONT_MEDIUM_SIZE];
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc
{
    DDLogInfo(@"- KDLoginViewController dealloc");
}
- (IBAction)onTapLoginButton:(id)sender
{
    NSString *name = @"test";// _userNameTextField.text;
    NSString *pwd = @"888888";//_passwordTextField.text;
    
    
//    [KDRequestAPI sendGetUserInfoRequestWithCompleteBlock:^(id responseObject, NSError *error) {
//        if (error)
//        {
//            DDLogInfo(@"登陆请求失败：%@",error.localizedDescription);
//        }
//        else
//        {
////            [ws dismissVC];
//        }
//    }];
    
//    [self request];
//
    if (VALIDATE_STRING(name) && VALIDATE_STRING(pwd) && _viewModel)
    {
        WS(ws);
        
        [_viewModel startLoginWithParams:@{LOGIN_NAME:name,LOGIN_PWD:pwd} beginBlock:^{
            [ws showHUD];
        } completeBlock:^(BOOL isSuccess, id params, NSError *error) {
            if (isSuccess)
            {
                [ws hideHUD];
//                [ws dismissVC];
                [ws request];
            }
            else
            {
                [ws showHUDWithInfo:[error localizedDescription]];
                
            }
        }];
    }
}
-(void)request
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"0" forKey:@"states[0]"];
    [dict setObject:@"13" forKey:@"sellerid"];
    NSString *ft = [NSString getTimeString:1471104000 formater:YYYY_MM_DD_HH_MM_SS];
    NSString *tt = [NSString getTimeString:1471190399 formater:YYYY_MM_DD_HH_MM_SS];
    [dict setObject:ft forKey:@"fromtime"];
    [dict setObject:tt forKey:@"totime"];
    [dict setObject:@"0" forKey:@"pagination.page"];
    [dict setObject:@"10" forKey:@"pagination.rows"];
    
    WS(ws);
    [KDRequestAPI sendGetOrderRequestWithParam:dict completeBlock:^(id responseObject, NSError *error) {
        if (error)
        {
            DDLogInfo(@"登陆请求失败：%@",error.localizedDescription);
        }
        else
        {
            NSArray *array = [NSArray yy_modelArrayWithClass:[KDOrderModel class] json:[responseObject objectForKey:RESPONSE_PAYLOAD]];
            DDLogInfo(@"%@",array);
            [[KDCacheManager commonCache] setObject:array forKey:ORDER_ARRAY_CACHE_KEY];
//            [ws logout];
            [ws dismissVC];
        }
    }];
    
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

@end
