//
//  KDCheckViewItemCellTableViewCell.m
//  KuaiDianForSeller
//
//  Created by ppnd on 16/10/20.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDCheckViewItemCell.h"
#import "KDCheckViewItemModel.h"


@interface KDCheckViewItemCell ()

@property(nonatomic,strong)KDCheckViewItemModel *model;

@end

@implementation KDCheckViewItemCell

- (void)awakeFromNib
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Initialization code
}

-(instancetype)initWithCheckStyle:(KDCheckViewItemStyle)checkStyle reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        [self setupUIWithCheckStyle:checkStyle];
    }
    
    return self;
}
-(void)setupUIWithCheckStyle:(KDCheckViewItemStyle)checkStyle
{
    if (checkStyle == KDCheckViewItemStyleOfOnlyText)
    {
        _iconImageView.hidden = YES;
        CGRect frame = _titleLabel.frame;
        frame.size.width += _iconImageView.frame.size.width;
        frame.origin.x = _iconImageView.frame.origin.x;
        _titleLabel.frame = frame;
    }
    else
    {
        _iconImageView.hidden = NO;
    }
}

-(void)configureCellWithModel:(KDCheckViewItemModel *)model
{
    if (VALIDATE_MODEL(model, @"KDCheckViewItemModel"))
    {
        _model = model;
        
        _titleLabel.text = model.name;
        _selectedImageView.hidden = !model.isSelected;
        
        if (!_iconImageView.isHidden)
        {
            _iconImageView.image = [UIImage imageNamed:model.imageName];
        }
    }
}
-(void)setSelect:(BOOL)isSelected
{
    if (VALIDATE_MODEL(_model, @"KDCheckViewItemModel"))
    {
        _model.isSelected = isSelected;
        _selectedImageView.hidden = !_model.isSelected;
    }
}
@end
