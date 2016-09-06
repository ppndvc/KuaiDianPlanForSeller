//
//  KDEvalueFilterCollectionCell.m
//  KuaiDianForSeller
//
//  Created by ppnd on 16/9/6.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDEvalueFilterCollectionCell.h"
#import "KDEvalueFilterItemModel.h"

@implementation KDEvalueFilterCollectionCell

- (void)awakeFromNib
{
    _bgView.layer.borderColor = (APP_BG_COLOR).CGColor;
    // Initialization code
}
-(void)configureCellWithModel:(KDEvalueFilterItemModel *)model
{
    if (model && [model isKindOfClass:[KDEvalueFilterItemModel class]])
    {
        _titleLabel.text = model.title;
        [self setCellSelected:model.isSelected];
    }
}
-(void)setCellSelected:(BOOL)selected
{
    if (selected)
    {
        _bgView.backgroundColor = APPD_RED_COLOR;
    }
    else
    {
        _bgView.backgroundColor = [UIColor whiteColor];
    }
}
@end
