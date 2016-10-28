//
//  KDCommonTextEditViewController.m
//  KuaiDianForSeller
//
//  Created by ppnd on 16/9/11.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDCommonTextEditViewController.h"

#define BUTTON_WIDTH 60
#define PLACE_HOLDER_STRING @"不超过%@个字"
#define INVALIDETED_INPUT_STRING @"请输入正确的文本内容"

@interface KDCommonTextEditViewController ()<UITextFieldDelegate,UITextViewDelegate>

//右键
@property(nonatomic,strong)UIButton *rightBTN;

//字符个数限制
@property(nonatomic,assign)NSInteger characterConstrainCount;

//输入框类型
@property(nonatomic,assign)KDCommonInputStyle type;

@end

@implementation KDCommonTextEditViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupUI];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewDidAppear:(BOOL)animated
{
    if (!_singleInputView.isHidden)
    {
        [_singleInputView becomeFirstResponder];
    }
    else if (!_multiInputView.isHidden)
    {
        [_multiInputView becomeFirstResponder];
    }
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //启用滑动返回
    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = YES;
}
-(void)setupUI
{
    [self setNaviBarItemWithType:KDNavigationBackToPreviousVC];
    //禁用滑动返回
    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = NO;
    _multiInputView.layer.borderColor = (SEPERATOR_COLOR).CGColor;
    
    _rightBTN = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, BUTTON_WIDTH, TEXT_FONT_BIG_SIZE)];
    _rightBTN.titleLabel.font = [UIFont systemFontOfSize:TEXT_FONT_MEDIUM_SIZE];
    [_rightBTN setTitle:BUTTON_TITLE_SURE forState:UIControlStateNormal];
    [_rightBTN addTarget:self action:@selector(onTapRightBTN) forControlEvents:UIControlEventTouchUpInside];
    _rightBTN.backgroundColor = [UIColor clearColor];
    _rightBTN.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_rightBTN];
    [self setRightBTNEnabled:NO];
    
    _type = [[self.parameters objectForKey:COMMON_INPUT_STYLE_KEY] integerValue];
    NSString *characterConstrain = [self.parameters objectForKey:COMMON_INPUT_CHARACTER_CONSTRAIN_KEY];
    NSString *initString = [self.parameters objectForKey:COMMON_INPUT_INITSTRING_KEY];
    NSString *titleStr = [self.parameters objectForKey:COMMON_INPUT_TITLE_KEY];
    NSString *placeHoldStr = [self.parameters objectForKey:COMMON_INPUT_PLACEHOLDER_KEY];
    
    if(VALIDATE_STRING(characterConstrain))
    {
        placeHoldStr = [NSString stringWithFormat:PLACE_HOLDER_STRING,characterConstrain];
        _characterConstrainCount = [characterConstrain integerValue];
    }
    else
    {
        _characterConstrainCount = MAX_INPUT;
    }
    
    if (_type == KDCommonInputStyleOfSingleRow || _type == KDCommonInputStyleOfSingleRowPhoneNumber || _type == KDCommonInputStyleOfSingleRowEmail || _type == KDCommonInputStyleOfSingleRowIdentifierCard)
    {
        _singleInputView.hidden = NO;
        _multiInputView.hidden = YES;
        _singleInputView.delegate = self;
        
        if (VALIDATE_STRING(initString))
        {
            _singleInputView.text = initString;
        }
        else
        {
            _singleInputView.placeholder = placeHoldStr;
        }
    }
    else if(_type == KDCommonInputStyleOfMultiRows)
    {
        _singleInputView.hidden = YES;
        _multiInputView.hidden = NO;
        _multiInputView.delegate = self;
        
        if (VALIDATE_STRING(initString))
        {
            _multiInputView.text = initString;
        }
    }
    
    
    if (VALIDATE_STRING(titleStr))
    {
        self.navigationItem.title = titleStr;
    }
}
-(void)leftBarButtonAction
{
    [super leftBarButtonAction];
}
-(void)onTapRightBTN
{
    if (self.vcDisappearBlock)
    {
        NSString *resultStr = nil;
        NSDictionary *resultDict = nil;
  
        if (_type == KDCommonInputStyleOfSingleRow || _type == KDCommonInputStyleOfSingleRowPhoneNumber || _type == KDCommonInputStyleOfSingleRowEmail || _type == KDCommonInputStyleOfSingleRowIdentifierCard)
        {
            resultStr = _singleInputView.text;
        }
        else if(_type == KDCommonInputStyleOfMultiRows)
        {
            resultStr = _multiInputView.text;

        }
        
        if (VALIDATE_STRING(resultStr))
        {
            resultDict = @{COMMON_INPUT_RESULT_STRING_KEY:resultStr};
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.vcDisappearBlock(nil,resultDict);
            });

            if ([self canReture])
            {
                [self.navigationController popViewControllerAnimated:YES];
            }
            else
            {
                DDLogInfo(@"+++= feifa ");
            }
        }
        else
        {
            [self showHUDWithInfo:INVALIDETED_INPUT_STRING];
        }
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.text.length > 0)
    {
        [self setRightBTNEnabled:YES];
    }
    else
    {
        [self setRightBTNEnabled:NO];
    }
    
    if (textField.text.length > _characterConstrainCount)
    {
        return NO;
    }
    
    return YES;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (textView.text.length > 0)
    {
        [self setRightBTNEnabled:YES];
    }
    else
    {
        [self setRightBTNEnabled:NO];
    }
    
    if ([text isEqualToString:@""] && range.length > 0)
    {
        //删除字符肯定是安全的
        return YES;
    }
    else
    {
        if (textView.text.length - range.length + text.length > _characterConstrainCount)
        {
            return NO;
        }
        else
        {
            return YES;
        }
    }
}
-(void)setRightBTNEnabled:(BOOL)enable
{
    _rightBTN.enabled = enable;
    
    if (enable)
    {
        [_rightBTN setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    else
    {
        [_rightBTN setTitleColor:TEXT_LOW_COLOR forState:UIControlStateNormal];
    }
}
-(BOOL)canReture
{
    BOOL canReturn = YES;
    
    switch (_type)
    {
        case KDCommonInputStyleOfSingleRow:
        case KDCommonInputStyleOfMultiRows:
        {
            canReturn = YES;
        }
            break;
        case KDCommonInputStyleOfSingleRowPhoneNumber:
        {
            canReturn = [NSString validatePhoneNumber:_singleInputView.text];
        }
            break;
        case KDCommonInputStyleOfSingleRowEmail:
        {
            canReturn = [NSString validateEmail:_singleInputView.text];
        }
            break;
        case KDCommonInputStyleOfSingleRowIdentifierCard:
        {
            canReturn = [NSString validateIdentityCard:_singleInputView.text];
        }
            break;
        default:
            canReturn = YES;
            break;
    }
    
    return canReturn;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    DDLogInfo(@"-KDCommonTextEditViewController dealloc");
}

@end
