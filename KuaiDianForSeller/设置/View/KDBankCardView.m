//
//  KDBankCardView.m
//  KuaiDianForSeller
//
//  Created by ppnd on 16/11/1.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDBankCardView.h"
#import "KDBankModel.h"

#define BG_IMAGE_WIDTH_RATIO 0.4
#define ICON_HEIGHT_RATIO 0.3

#define NORMAL_VIEW_HEIGHT 80

#define ICON_IMAGE_PREFIX @"bank_icon_"
#define BG_IMAGE_PREFIX @"bg_image_"

@interface KDBankCardView ()

@property(nonatomic,strong)KDBankModel *bank;

@property(nonatomic,strong)UILabel *titleLabel;

@property(nonatomic,strong)UILabel *numberLabel;

@property(nonatomic,strong)UIImageView *iconImageView;

@property(nonatomic,strong)UIImageView *bgImageView;

@end

@implementation KDBankCardView

+(instancetype)normalBankCardViewWithBank:(KDBankModel *)bank
{
    CGFloat height = NORMAL_VIEW_HEIGHT;
    CGFloat width = SCREEN_WIDTH - 2 * VIEW_HORIZONTAL_PADDING_TO_SCREEN_BORDER;
    KDBankCardView *bv = [[KDBankCardView alloc] initWithFrame:CGRectMake(0, 0, width, height) bank:bank];
    return bv;
}

-(instancetype)initWithFrame:(CGRect)frame bank:(KDBankModel *)bank
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _bank = bank;
        [self setupUI];
        [self updateViewWithModel:_bank];
    }
    return  self;
}

-(void)setupUI
{
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = CORNER_RADIUS;
    self.layer.masksToBounds = YES;
    
    CGFloat viewHeight = self.frame.size.height;
    CGFloat viewWidth = self.frame.size.width;
    
    _bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(viewWidth - viewWidth * BG_IMAGE_WIDTH_RATIO, 0, viewWidth * BG_IMAGE_WIDTH_RATIO, viewHeight)];
    [self addSubview:_bgImageView];
    
    _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(VIEW_HORIZONTAL_PADDING_TO_SCREEN_BORDER, VIEW_VERTICAL_PADDING, viewHeight * ICON_HEIGHT_RATIO, viewHeight * ICON_HEIGHT_RATIO)];
    [self addSubview:_iconImageView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_iconImageView.frame.origin.x + _iconImageView.frame.size.width + VIEW_HORIZONTAL_PADDING_TO_SCREEN_BORDER, VIEW_VERTICAL_PADDING, viewWidth * BG_IMAGE_WIDTH_RATIO, _iconImageView.frame.size.height)];
    _titleLabel.font = [UIFont systemFontOfSize:TEXT_FONT_MEDIUM_SIZE];
    _titleLabel.textColor = TEXT_HIGH_COLOR;
    [self addSubview:_titleLabel];
    
    _numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(VIEW_HORIZONTAL_PADDING_TO_SCREEN_BORDER, viewHeight - TEXT_FONT_MEDIUM_SIZE - VIEW_VERTICAL_PADDING, viewWidth - 2 * VIEW_HORIZONTAL_PADDING_TO_SCREEN_BORDER, TEXT_FONT_MEDIUM_SIZE)];
    _numberLabel.font = [UIFont systemFontOfSize:TEXT_FONT_MEDIUM_SIZE];
    _numberLabel.textColor = TEXT_HIGH_COLOR;
    _numberLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:_numberLabel];
}

-(void)updateViewWithModel:(KDBankModel *)model
{
    if (VALIDATE_MODEL(model, @"KDBankModel"))
    {
        _titleLabel.text = model.bankName;
        _numberLabel.text = [model formatedVertualCardNumber];
        _iconImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%d",ICON_IMAGE_PREFIX,(int)model.bankBrand]];
        _bgImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%d",BG_IMAGE_PREFIX,(int)model.bankBrand]];
    }
}

@end
