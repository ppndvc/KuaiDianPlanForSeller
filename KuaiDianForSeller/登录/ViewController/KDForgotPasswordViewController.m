//
//  KDForgotPasswordViewController.m
//  KuaiDianForSeller
//
//  Created by ppnd on 16/8/16.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDForgotPasswordViewController.h"

#define CELLPHONE_IMAGE @"cell_phone"
#define BOOK_IMAGE @"book"
#define EYE_IMAGE @"eye"
#define LOCK_IMAGE @"lock_icon"

@interface KDForgotPasswordViewController ()

//输入状态
@property(nonatomic,assign)KDInputState state;

@end

@implementation KDForgotPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = FORGOT_PASSWORD;
    [self setInputState:KDInputCellPhoneNumberState];
    [self setNaviBarItemWithType:KDNavigationBackToPreviousVC];
    _rightImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnTapEye)];
    [_rightImageView addGestureRecognizer:tap];
    // Do any additional setup after loading the view from its nib.
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
                _thirdLabel.textColor = [UIColor blackColor];
                
                _leftImageVIew.image = [UIImage imageNamed:CELLPHONE_IMAGE];
                
                [_textField setPlaceholder:PLACEHOLDER_FOR_CELLPHONE_NUMBER];
                
                _rightImageView.hidden = YES;
                
                [_textField setSecureTextEntry:NO];
                [_actionButton setTitle:BUTTON_TITLE_FOR_GET_CODE forState:UIControlStateNormal];

            }
                break;
            case KDInputCodeState:
            {
                _firstLabel.textColor = [UIColor blackColor];
                _secondLabel.textColor = APPD_RED_COLOR;
                _thirdLabel.textColor = [UIColor blackColor];
                
                _leftImageVIew.image = [UIImage imageNamed:BOOK_IMAGE];
                
                [_textField setPlaceholder:PLACEHOLDER_FOR_CODE_NUMBER];
                
                _rightImageView.hidden = YES;
                [_textField setSecureTextEntry:NO];
                
                [_actionButton setTitle:BUTTON_TITLE_SURE forState:UIControlStateNormal];
            }
                break;
            case KDInputNewPasswordState:
            {
                _firstLabel.textColor = [UIColor blackColor];
                _secondLabel.textColor = [UIColor blackColor];
                _thirdLabel.textColor = APPD_RED_COLOR;
                
                _leftImageVIew.image = [UIImage imageNamed:LOCK_IMAGE];
                
                [_textField setPlaceholder:PLACEHOLDER_FOR_NEW_PASSWORD];
                
                _rightImageView.hidden = NO;
                
                [_textField setSecureTextEntry:YES];
                [_actionButton setTitle:BUTTON_TITLE_FOR_CHANGE_PASSORD forState:UIControlStateNormal];
            }
                break;
            default:
                break;
        }
        _state = state;
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onTapActionBTN:(id)sender
{
    switch (_state)
    {
        case KDInputCellPhoneNumberState:
        {
            [self setInputState:KDInputCodeState];
            
        }
            break;
        case KDInputCodeState:
        {
            [self setInputState:KDInputNewPasswordState];
        }
            break;
        case KDInputNewPasswordState:
        {
            [self setInputState:KDInputCellPhoneNumberState];
        }
            break;
        default:
            break;
    }
}
-(void)OnTapEye
{
    [_textField setSecureTextEntry:!_textField.isSecureTextEntry];
}
-(void)dealloc
{
    DDLogInfo(@"-KDForgotPasswordViewController dealloc");
}
@end
