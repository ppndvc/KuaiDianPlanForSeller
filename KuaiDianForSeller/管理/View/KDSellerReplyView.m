//
//  KDSellerReplyView.m
//  KuaiDianForSeller
//
//  Created by ppnd on 16/9/4.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDSellerReplyView.h"
#import "KDBaseReplyModel.h"

#define NAMELABEL_WIDTH 150

#define DATELABEL_WIDTH 100

#define VERTICAL_PADDING 4

#define SELLER_DEFAULT_ANME @"商家回复"

@implementation KDSellerReplyView

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
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, NAMELABEL_WIDTH, TEXT_FONT_MEDIUM_SIZE)];
    _nameLabel.font = [UIFont systemFontOfSize:TEXT_FONT_SMALL_SIZE];
    _nameLabel.textColor = [UIColor lightGrayColor];
    [self addSubview:_nameLabel];
    
    _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width - DATELABEL_WIDTH, 0, DATELABEL_WIDTH, TEXT_FONT_MEDIUM_SIZE)];
    _dateLabel.font = [UIFont systemFontOfSize:TEXT_FONT_SMALL_SIZE];
    _dateLabel.textColor = [UIColor lightGrayColor];
    _dateLabel.textAlignment = NSTextAlignmentRight;
    
    [self addSubview:_dateLabel];
    
    _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(VIEW_HORIZONTAL_PADDING_TO_SCREEN_BORDER/2.0, TEXT_FONT_MEDIUM_SIZE + VERTICAL_PADDING, self.frame.size.width - VIEW_HORIZONTAL_PADDING_TO_SCREEN_BORDER, TEXT_FONT_MEDIUM_SIZE)];
    _contentLabel.numberOfLines = 0;
    _contentLabel.font = [UIFont systemFontOfSize:TEXT_FONT_MEDIUM_SIZE];
    _contentLabel.textColor = [UIColor darkGrayColor];
    _contentLabel.textAlignment = NSTextAlignmentJustified;
    
    [self addSubview:_contentLabel];
    self.backgroundColor = APP_BG_COLOR;
}

-(CGFloat)setupViewWithModel:(KDBaseReplyModel *)model
{
    CGFloat height = 0;
    if (model && [model isKindOfClass:[KDBaseReplyModel class]])
    {
        _nameLabel.text = (model.replyerName?model.replyerName:SELLER_DEFAULT_ANME);
    
        _dateLabel.text = [NSString getTimeString:[model.date doubleValue] formater:YYYY_MM_DD_DATE_FORMATER];
        CGRect contentFrame = _contentLabel.frame;
        CGSize rect = [model.content getStringDrawRectWithConstrainSize:CGSizeMake(self.frame.size.width - VIEW_HORIZONTAL_PADDING_TO_SCREEN_BORDER, MAXFLOAT) font:_contentLabel.font];
        contentFrame.size.height = rect.height;
        _contentLabel.frame = contentFrame;
        _contentLabel.text = model.content;
        
        height = (_contentLabel.frame.origin.y + _contentLabel.frame.size.height);
        CGRect frame = self.frame;
        frame.size.height = height;
    
        self.frame = frame;
    }
    
    return height;
}
@end
