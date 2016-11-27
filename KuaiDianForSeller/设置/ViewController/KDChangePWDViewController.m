//
//  KDChangePWDViewController.m
//  KuaiDianForSeller
//
//  Created by ppnd on 16/10/30.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDChangePWDViewController.h"
#import "KDChangePWDViewModel.h"

#define CELLPHONE_IMAGE @"cell_phone"
#define BOOK_IMAGE @"book"
#define EYE_IMAGE @"eye"
#define LOCK_IMAGE @"lock_icon"

#define ERROR_PHONE_NUMBER_TITLE @"不正确的手机号码"
#define ERROR_CODE_TITLE @"不正确的验证码"
#define NEXT_STEP_BUTTON_TITLE @"下一步"


@interface KDChangePWDViewController ()
//输入状态
@property(nonatomic,assign)KDInputState state;

//viewmodel
@property(nonatomic,strong)KDChangePWDViewModel *viewModel;

@end

@implementation KDChangePWDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = CHANGE_PASSWORD;
    _viewModel = [[KDChangePWDViewModel alloc] init];
    
    [self setInputState:KDInputCodeState];
    [self setNaviBarItemWithType:KDNavigationBackToPreviousVC];
    [self setupUI];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setupUI
{
    WS(ws);
    [_viewModel setTimerHandleBlock:^(NSString *param) {
        if (VALIDATE_STRING(param))
        {
            [ws setButton:ws.getCodeButton title:TIME_REMAIN(param)];
            [ws setButton:ws.getCodeButton enable:NO];
        }
    }];
    
    [_viewModel setTimerFinishedHandleBlock:^(id param) {
        [ws setButton:ws.getCodeButton title:RE_GET_CODE_BUTTON_TITLE];
        [ws setButton:ws.getCodeButton enable:YES];
    }];
}
-(void)setInputState:(KDInputState)state
{
    if (_state != state)
    {
        switch (state)
        {
            case KDInputCodeState:
            {
                _firstLabel.textColor = APPD_RED_COLOR;
                _secondLabel.textColor = [UIColor blackColor];
                
                _firstImageView.image = [UIImage imageNamed:BOOK_IMAGE];
                
                [_firstTextField setPlaceholder:PLACEHOLDER_FOR_CODE_NUMBER];
                [_getCodeButton setTitle:BUTTON_TITLE_FOR_GET_CODE forState:UIControlStateNormal];

                _secondView.hidden = YES;
                
                CGRect btnFrame = _actionButton.frame;
                btnFrame.origin.y = _firstView.frame.origin.y + _firstView.frame.size.height + VIEW_VERTICAL_PADDING;
                _actionButton.frame = btnFrame;
                [_actionButton setTitle:NEXT_STEP_BUTTON_TITLE forState:UIControlStateNormal];
                
            }
                break;
            case KDInputNewPasswordState:
            {
                _getCodeButton.hidden = YES;
                _firstLabel.textColor = [UIColor blackColor];
                _secondLabel.textColor = APPD_RED_COLOR;
                
                _firstTextField.text = nil;
                _secondTextField.text = nil;
                
                _firstImageView.image = [UIImage imageNamed:LOCK_IMAGE];
                _secondImageView.image = [UIImage imageNamed:LOCK_IMAGE];

                CGRect frame = _firstTextField.frame;
                frame.size.width = _secondTextField.frame.size.width;
                _firstTextField.frame = frame;
                _firstTextField.secureTextEntry = YES;
                [_firstTextField setPlaceholder:PLACEHOLDER_FOR_NEW_PASSWORD];
            
                _secondView.hidden = NO;
                CGRect btnFrame = _actionButton.frame;
                btnFrame.origin.y = _secondView.frame.origin.y + _secondView.frame.size.height + VIEW_VERTICAL_PADDING;
                _actionButton.frame = btnFrame;
                [_actionButton setTitle:CHANGE_PWD_BUTTON_TITLE forState:UIControlStateNormal];
            }
                break;
            default:
                break;
        }
        _state = state;
    }
}

-(void)setButton:(UIButton *)btn enable:(BOOL)enable
{
    if (VALIDATE_MODEL(btn, @"UIButton"))
    {
        if (enable)
        {
            [btn setBackgroundColor:APPD_RED_COLOR];
        }
        else
        {
            [btn setBackgroundColor:TEXT_MEDIUM_COLOR];
        }
        
        btn.enabled = enable;
    }
}

-(void)setButton:(UIButton *)btn title:(NSString *)title
{
    if (VALIDATE_MODEL(btn, @"UIButton"))
    {
        [btn setTitle:title forState:UIControlStateNormal|UIControlStateDisabled];
    }
}
-(void)dealloc
{
    DDLogInfo(@"-KDChangePWDViewController dealloc");
}


- (IBAction)onTapGetCodeButton:(id)sender
{
    KDUserModel *model = [[KDUserManager sharedInstance] getUserInfo];
    if (VALIDATE_MODEL(model, @"KDUserModel"))
    {
        NSString *phoneNumber = model.telephone;
        if (VALIDATE_STRING(phoneNumber))
        {
            WS(ws);
            [_viewModel getCodeWithParams:@{REQUEST_KEY_VERIFY_CODE_TO:phoneNumber} beginBlock:^{
                [ws showHUD];
            } completeBlock:^(BOOL isSuccess, id params, NSError *error) {
                
                if(isSuccess)
                {
                    [ws hideHUD];
                    [ws.viewModel startTimer];
                }
                else
                {
                    if (error)
                    {
                        [ws showErrorHUDWithStatus:error.localizedDescription];
                    }
                    else
                    {
                        [ws showErrorHUDWithStatus:HTTP_REQUEST_ERROR];
                    }
                }
            }];
        }
    }
}

- (IBAction)onTapActionButton:(id)sender
{
    if (_state == KDInputCodeState)
    {
        if ([_viewModel checkVerifyCode:_firstTextField.text])
        {
            [self setInputState:KDInputNewPasswordState];
            [_viewModel stopTimer];
        }
        else
        {
            [self showErrorHUDWithStatus:ERROR_CODE_TITLE];
        }
    }
}
@end
