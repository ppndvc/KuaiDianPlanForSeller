//
//  KDChangePhoneNumberViewController.m
//  KuaiDianForSeller
//
//  Created by ppnd on 16/8/22.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDChangePhoneNumberViewController.h"
#import "KDChangePWDViewModel.h"

#define CELLPHONE_IMAGE @"cell_phone"
#define BOOK_IMAGE @"book"
#define EYE_IMAGE @"eye"
#define LOCK_IMAGE @"lock_icon"

@interface KDChangePhoneNumberViewController ()

//输入状态
@property(nonatomic,assign)KDInputState state;

//viewmodel
@property(nonatomic,strong)KDChangePWDViewModel *viewModel;

@end

@implementation KDChangePhoneNumberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = BIND_PHONE_NUMBER;
    _viewModel = [[KDChangePWDViewModel alloc] init];
    
    [self setInputState:KDInputCellPhoneNumberState];
    [self setNaviBarItemWithType:KDNavigationBackToPreviousVC];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setInputState:(KDInputState)state
{
    if (_state != state)
    {
        switch (state)
        {
            case KDInputCellPhoneNumberState:
            {
                _firstLabel.textColor = APPD_RED_COLOR;
                _secondLabel.textColor = [UIColor blackColor];
                
                _imageView.image = [UIImage imageNamed:CELLPHONE_IMAGE];
                
                [_textField setPlaceholder:PLACEHOLDER_FOR_CELLPHONE_NUMBER];
                
                [_actionButton setTitle:BUTTON_TITLE_FOR_GET_CODE forState:UIControlStateNormal];
                
            }
                break;
            case KDInputCodeState:
            {
                _firstLabel.textColor = [UIColor blackColor];
                _secondLabel.textColor = APPD_RED_COLOR;
                
                _imageView.image = [UIImage imageNamed:BOOK_IMAGE];
                
                [_textField setPlaceholder:PLACEHOLDER_FOR_CODE_NUMBER];
                
                [_actionButton setTitle:BUTTON_TITLE_SURE forState:UIControlStateNormal];
            }
                break;
            default:
                break;
        }
        _state = state;
    }
}

- (IBAction)onTapActionButton:(id)sender
{
    WS(ws);
    switch (_state)
    {
        case KDInputCellPhoneNumberState:
        {
            [_viewModel getCodeWithParams:nil beginBlock:nil completeBlock:^(BOOL isSuccess, id params, NSError *error) {
                [ws setInputState:KDInputCodeState];
                
            }];
        }
            break;
        case KDInputCodeState:
        {
            [_viewModel startVerifyCodeWithParams:nil beginBlock:nil completeBlock:^(BOOL isSuccess, id params, NSError *error) {
                [ws setInputState:KDInputNewPasswordState];
            }];
        }
            break;
        default:
            break;
    }
}

-(void)dealloc
{
    DDLogInfo(@"-KDForgotPasswordViewController dealloc");
}

@end
