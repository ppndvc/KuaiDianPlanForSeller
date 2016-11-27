//
//  KDPayBrandView.m
//  KuaiDianForSeller
//
//  Created by ppnd on 16/8/18.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDPayBrandView.h"

#define PADDING 8

#define IMAGE_WIDTH 27
#define IMAGE_HEIGHT 20
@interface KDPayBrandView ()

//图标
@property(nonatomic,strong)UIImageView *imageView;

//支付名
@property(nonatomic,strong)UILabel *nameLabel;

//号码
@property(nonatomic,strong)UILabel *numLabel;

//类型
@property(nonatomic,assign)KDPaymentType type;

@end

@implementation KDPayBrandView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setupUI];
    }
    
    return self;
}
-(void)setupUI
{
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width/2.0 - IMAGE_WIDTH, (self.frame.size.height/2.0 - IMAGE_HEIGHT)/2.0, IMAGE_WIDTH,  IMAGE_HEIGHT)];
//    _imageView.contentMode = UIViewContentModeRight;
    [self addSubview:_imageView];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_imageView.frame.origin.x + _imageView.frame.size.width + PADDING, 0, self.frame.size.width - _imageView.frame.size.width - PADDING,  self.frame.size.height/2.0)];
    _nameLabel.font = [UIFont systemFontOfSize:TEXT_FONT_BIG_SIZE];
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    _nameLabel.textColor = [UIColor whiteColor];
    [self addSubview:_nameLabel];
    
    _numLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height/2.0, self.frame.size.width,  self.frame.size.height/2.0)];
    _numLabel.font = [UIFont systemFontOfSize:TEXT_FONT_BIG_SIZE];
    _numLabel.textAlignment = NSTextAlignmentCenter;
    _numLabel.textColor = [UIColor whiteColor];
    [self addSubview:_numLabel];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapView)];
    [self addGestureRecognizer:tap];
}
-(void)setPayBrandViewType:(KDPaymentType)type number:(NSString *)number
{
    switch (type)
    {
        case KDPaymentTypeOfBankPay:
        {
            _nameLabel.text = BANK_PAY_NAME;
            _imageView.image = [UIImage imageNamed:@"bank_card"];
        }
            break;
        case KDPaymentTypeOfAliPay:
        {
            _nameLabel.text = ALIPAY_NAME;
            _imageView.image = [UIImage imageNamed:@"eye"];
        }
            break;
        case KDPaymentTypeOfWeiChatPay:
        {
            _nameLabel.text = WEICHAT_PAY_NAME;
            _imageView.image = [UIImage imageNamed:@"lock_icon"];
        }
            break;
            
        default:
            break;
    }
    
    _numLabel.text = number;
    _type = type;
}

-(void)onTapView
{
    if (_delegate && [_delegate respondsToSelector:@selector(onTapPayBrandViewWithPaymentType:)])
    {
        [_delegate onTapPayBrandViewWithPaymentType:_type];
    }
}
@end
