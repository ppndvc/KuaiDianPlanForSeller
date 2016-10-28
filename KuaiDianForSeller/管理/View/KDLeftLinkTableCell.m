//
//  KDLeftLinkTableCell.m
//  KuaiDianForSeller
//
//  Created by ppnd on 16/9/13.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDLeftLinkTableCell.h"

#define RED_SEPERATOR_WIDTH 4
#define BOTTOM_SEPERAOR_HEIGHT 0.5

@interface KDLeftLinkTableCell()

//标题label
@property(nonatomic,strong)UILabel *titleLabel;

//红色分割
@property(nonatomic,strong)UIView *redSeperator;

@end

@implementation KDLeftLinkTableCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH*LINK_TABLEVIEW_SEPERATE_POSITION_RATE, LEFT_TABLEVIEW_CELL_HEIGHT);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
    }
    return self;
}
-(void)setupUI
{
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(VIEW_VERTICAL_PADDING, 0, self.frame.size.width - 2*VIEW_VERTICAL_PADDING, self.frame.size.height)];
    _titleLabel.numberOfLines = 0;
    _titleLabel.textColor = TEXT_HIGH_COLOR;
    _titleLabel.font = [UIFont systemFontOfSize:TEXT_FONT_MEDIUM_SIZE];
    [self.contentView addSubview:_titleLabel];
    
    UIView *bottomSeperator = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - BOTTOM_SEPERAOR_HEIGHT, self.frame.size.width, BOTTOM_SEPERAOR_HEIGHT)];
    bottomSeperator.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:bottomSeperator];
    
    _redSeperator = [[UIView alloc] initWithFrame:CGRectMake(0, 0, RED_SEPERATOR_WIDTH, self.frame.size.height)];
    _redSeperator.backgroundColor = APPD_RED_COLOR;
    [self.contentView addSubview:_redSeperator];
}
-(void)prepareForReuse
{
    _titleLabel.text = nil;
}

-(void)configureCellWithTitle:(NSString *)title
{
    if (VALIDATE_STRING(title))
    {
        _titleLabel.text = title;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    if (selected)
    {
        self.backgroundColor = [UIColor whiteColor];
        _redSeperator.hidden = NO;
    }
    else
    {
        self.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _redSeperator.hidden = YES;
    }
}
@end
