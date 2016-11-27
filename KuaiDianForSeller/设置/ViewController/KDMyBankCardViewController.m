//
//  KDMyBankCardViewController.m
//  KuaiDianForSeller
//
//  Created by ppnd on 16/11/2.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDMyBankCardViewController.h"
#import "KDBankModel.h"
#import "KDBankCardView.h"


#define ADD_BANK_CARD_BUTTON_TITLE @"添加银行卡"
#define CHANGE_BANK_CARD_BUTTON_TITLE @"更换银行卡"

@interface KDMyBankCardViewController ()

@property(nonatomic,strong)UIScrollView *scrollView;

@property(nonatomic,strong)UIButton *addBankButton;

@end

@implementation KDMyBankCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNaviBarItemWithType:KDNavigationBackToPreviousVC];
    self.navigationItem.title = MY_BANK_CARD;
    [self setupUI];
    // Do any additional setup after loading the view.
}

-(void)setupUI
{
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.alwaysBounceVertical = YES;
    _scrollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:_scrollView];
    
    CGRect bankCardViewFrame = CGRectZero;
    KDBankModel *model = nil;
    BOOL needShowBankCardView = NO;
    
    if (VALIDATE_DICTIONARY(self.parameters))
    {
        model = [self.parameters objectForKey:BANK_INFO_MODEL];
        needShowBankCardView = YES;
    }

    if (VALIDATE_MODEL(model, @"KDBankModel"))
    {
        KDBankCardView *view = [KDBankCardView normalBankCardViewWithBank:model];
        bankCardViewFrame = view.frame;
        bankCardViewFrame.origin = CGPointMake(VIEW_HORIZONTAL_PADDING_TO_SCREEN_BORDER, VIEW_HORIZONTAL_PADDING_TO_SCREEN_BORDER);
        view.frame = bankCardViewFrame;
        
        [_scrollView addSubview:view];
    }
    
    _addBankButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _addBankButton.frame = CGRectMake(VIEW_HORIZONTAL_PADDING_TO_SCREEN_BORDER, bankCardViewFrame.origin.y + bankCardViewFrame.size.height + VIEW_VERTICAL_PADDING, SCREEN_WIDTH - 2*VIEW_HORIZONTAL_PADDING_TO_SCREEN_BORDER, BUTTON_HEIGHT);
    if (needShowBankCardView)
    {
        [_addBankButton setTitle:CHANGE_BANK_CARD_BUTTON_TITLE forState:UIControlStateNormal];
    }
    else
    {
        [_addBankButton setTitle:ADD_BANK_CARD_BUTTON_TITLE forState:UIControlStateNormal];
    }
    [_addBankButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    _addBankButton.titleLabel.font = [UIFont systemFontOfSize:TEXT_FONT_MEDIUM_SIZE];
    [_addBankButton addTarget:self action:@selector(onTapAddBankButton) forControlEvents:UIControlEventTouchUpInside];
    
    [self setDotLineButton:_addBankButton];
    [_scrollView addSubview:_addBankButton];
}
-(void)setDotLineButton:(UIButton *)btn
{
    if (VALIDATE_MODEL(btn, @"UIButton"))
    {
        CAShapeLayer *borderLayer = [CAShapeLayer layer];
        borderLayer.fillColor = [UIColor clearColor].CGColor;
        borderLayer.strokeColor = [UIColor darkGrayColor].CGColor;
        borderLayer.path = [UIBezierPath bezierPathWithRoundedRect:btn.bounds cornerRadius:CORNER_RADIUS].CGPath;
        borderLayer.lineWidth = 0.5f;
        borderLayer.lineCap = @"square";
        borderLayer.lineDashPattern = @[@6, @3];
        [btn.layer addSublayer:borderLayer];
    }
}

-(void)onTapAddBankButton
{
    [[KDRouterManger sharedManager] pushVCWithKey:@"KDAddBankCardVC" parentVC:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    DDLogInfo(@"-KDMyBankCardViewController dealloc");
}


@end
