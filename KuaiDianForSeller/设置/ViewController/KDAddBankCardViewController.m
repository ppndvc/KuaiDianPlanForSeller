//
//  KDAddBankCardViewController.m
//  KuaiDianForSeller
//
//  Created by ppnd on 16/10/31.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDAddBankCardViewController.h"
#import "KDAddBankViewModel.h"

#define MAX_CARD_NUMBER (20 + 5)

#define AGREEMENT_TITLE @"同意"
#define USER_NOTICE_TITLE @"《用户协议》"
#define INVALIDATE_PHONE_NUMBER @"请输入正确的手机号码"
#define INVALIDATE_ID_CARD_NUMBER @"请输入正确的身份证号码"
#define INVALIDATE_BANK_CARD_NUMBER @"请输入正确的银行卡号码"
#define INVALIDATE_NAME @"请输入正确的姓名"
#define INVALIDATE_CODE @"验证码错误"
#define NOT_AGREEMENT_BUTTON @"您还未同意用户协议"



@interface KDAddBankCardViewController ()<UITextFieldDelegate>

@property(nonatomic,strong)KDAddBankViewModel *viewModel;

@end

@implementation KDAddBankCardViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNaviBarItemWithType:KDNavigationBackToPreviousVC];
    self.navigationItem.title = ADD_BANK_CARD_TITLE;
    _viewModel = [[KDAddBankViewModel alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self setupUI];
    // Do any additional setup after loading the view from its nib.
}
-(void)setupUI
{
    _checkButton.layer.borderWidth = 1.5;
    _checkButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",AGREEMENT_TITLE,USER_NOTICE_TITLE]];
    
    [attriString addAttribute:NSForegroundColorAttributeName
                        value:self.view.tintColor
                        range:NSMakeRange((AGREEMENT_TITLE).length, (USER_NOTICE_TITLE).length)];
    
    [attriString addAttribute:NSUnderlineStyleAttributeName
                        value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle)
                        range:NSMakeRange((AGREEMENT_TITLE).length, (USER_NOTICE_TITLE).length)];
    
    _clientProtocolLabel.attributedText = attriString;
    _clientProtocolLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapClientProtol)];
    [_clientProtocolLabel addGestureRecognizer:tap];
    
    _bankCardTextField.delegate = self;
    
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

    UITapGestureRecognizer *tapSV = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapScrollView)];
    _scrollView.userInteractionEnabled = YES;
    [_scrollView addGestureRecognizer:tapSV];
}

-(void)onTapClientProtol
{
    DDLogInfo(@"onTapClientProtol");
    [self showHUDWithInfo:UNFINISHED_FUNCTION];
}

- (IBAction)onTapCheckButton:(UIButton *)sender
{
    _checkButton.selected = !_checkButton.isSelected;
}

- (IBAction)onTapSureButton:(id)sender
{
    NSDictionary *param = [self getBankInfo];
    if (VALIDATE_MODEL(param, @"NSDictionary"))
    {
        WS(ws);
        [_viewModel addBankCardWithParams:param beginBlock:^{
            [ws showHUD];
        } completeBlock:^(BOOL isSuccess, id params, NSError *error) {
            if (isSuccess)
            {
                [ws hideHUD];
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

- (IBAction)onTapGetCodeButton:(id)sender
{
    NSString *phoneNumber = _phoneNumberTextField.text;
    if ([NSString validatePhoneNumber:phoneNumber])
    {
        NSDictionary *params = @{REQUEST_KEY_VERIFY_CODE_TO:phoneNumber};
        WS(ws);
        [_viewModel getCodeWithParams:params beginBlock:^{
            [ws showHUD];
        } completeBlock:^(BOOL isSuccess, id params, NSError *error) {
            if (isSuccess)
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
    else
    {
        [self showErrorHUDWithStatus:INVALIDATE_PHONE_NUMBER];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == _bankCardTextField)
    {
        // 4位分隔银行卡卡号
        NSString *text = [textField text];
        
        NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789\b"];
        string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
        if ([string rangeOfCharacterFromSet:[characterSet invertedSet]].location != NSNotFound)
        {
            return NO;
        }
        
        text = [text stringByReplacingCharactersInRange:range withString:string];
        text = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        NSString *newString = @"";
        while (text.length > 0)
        {
            NSString *subString = [text substringToIndex:MIN(text.length, 4)];
            newString = [newString stringByAppendingString:subString];
            if (subString.length == 4)
            {
                newString = [newString stringByAppendingString:@" "];
            }
            text = [text substringFromIndex:MIN(text.length, 4)];
        }
        
        newString = [newString stringByTrimmingCharactersInSet:[characterSet invertedSet]];
        
        if ([newString stringByReplacingOccurrencesOfString:@" " withString:@""].length >= 21)
        {
            return NO;
        }
        
        [textField setText:newString];
        
        return NO;
    }
    
    return YES;
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
-(void)onTapScrollView
{
    [self.view endEditing:YES];
}
-(void)updateScrollViewContentSize:(CGFloat)offset
{
    CGRect frame = _scrollView.frame;
    frame.size.height = (SCREEN_HEIGHT + offset);
    _scrollView.frame = frame;
    
    if (offset < 0)
    {
        _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, _clientProtocolLabel.frame.origin.y + 50);
    }
    else
    {
        _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
    }
}
#pragma mark - Keyboard Event Functions
- (void)keyboardWillHide:(NSNotification *)notif
{
    CGRect endFrame = [[[notif userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [self updateScrollViewContentSize:endFrame.size.height];
}

- (void)keyboardWillShow:(NSNotification *)notif
{
    CGRect endFrame = [[[notif userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [self updateScrollViewContentSize:-endFrame.size.height];
}
-(NSDictionary *)getBankInfo
{
    NSMutableDictionary *param= [NSMutableDictionary new];
    
    NSString *bankCardNumber = _bankCardTextField.text;
    bankCardNumber = [NSString trimString:bankCardNumber];
    if ([NSString validateBankCard:bankCardNumber])
    {
        [param setObject:bankCardNumber forKey:REQUEST_KEY_BANK_CARD_NUMBER];
    }
    else
    {
        [self showErrorHUDWithStatus:INVALIDATE_BANK_CARD_NUMBER];
        return nil;
    }
    
    if (VALIDATE_STRING(_nameTextField.text))
    {
        [param setObject:_nameTextField.text forKey:REQUEST_KEY_BANK_ACCOUNT_NAME];
    }
    else
    {
        [self showErrorHUDWithStatus:INVALIDATE_NAME];
        return nil;
    }
    
    NSString *idCardNumber = _idCardTextField.text;
    idCardNumber = [idCardNumber stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([NSString validateIdentityCard:idCardNumber])
    {
        [param setObject:idCardNumber forKey:REQUEST_KEY_IDENTITY_CARD_NUMBER];
    }
    else
    {
        [self showErrorHUDWithStatus:INVALIDATE_ID_CARD_NUMBER];
        return nil;
    }
    
    NSString *phoneNumber = _phoneNumberTextField.text;
    phoneNumber = [NSString trimString:phoneNumber];
    if ([NSString validatePhoneNumber:phoneNumber])
    {
        [param setObject:phoneNumber forKey:REQUEST_KEY_PHONE_NUMBER];
    }
    else
    {
        [self showErrorHUDWithStatus:INVALIDATE_PHONE_NUMBER];
        return nil;
    }
    
    if ([_viewModel checkVerifyCode:_codeTextField.text])
    {
        if (!_checkButton.isSelected)
        {
            [self showErrorHUDWithStatus:NOT_AGREEMENT_BUTTON];
            return nil;
        }
    }
    else
    {
        [self showErrorHUDWithStatus:INVALIDATE_CODE];
        return nil;
    }
    
    return param;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc
{
    DDLogInfo(@"-KDAddBankCardViewController dealloc");
}

@end
