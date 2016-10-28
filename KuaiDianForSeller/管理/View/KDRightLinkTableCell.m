//
//  KDRightLinkTableCell.m
//  KuaiDianForSeller
//
//  Created by ppnd on 16/9/16.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDRightLinkTableCell.h"
#import "KDFoodItemModel.h"
#import "KDTasteLabelView.h"

#define STOP_SALE_TITLE @"停售"
#define RECOVER_SALE_TITLE @"恢复"

@interface KDRightLinkTableCell ()

@property(nonatomic,strong)KDFoodItemModel *foodModel;

@end

@implementation KDRightLinkTableCell

- (void)awakeFromNib
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Initialization code
}


-(void)configureCellWithModel:(KDFoodItemModel *)model
{
    if (model && [model isKindOfClass:[KDFoodItemModel class]])
    {
        _foodModel = model;
//        _foodImageView.image = [UIImage imageNamed:_foodModel.imageURL];
        _titleLabel.text = _foodModel.name;
        NSString *totalPrice = [NSString stringWithFormat:@"￥%.1f",_foodModel.price];
        _priceLabel.text = totalPrice;
        [_tasteLabelView updateTastes:_foodModel.tasteType];
        
        if (model.status == 0)
        {
            [_saleActionButton setTitle:STOP_SALE_TITLE forState:UIControlStateNormal];
        }
        else
        {
            [_saleActionButton setTitle:RECOVER_SALE_TITLE forState:UIControlStateNormal];
        }
    }
}
-(void)prepareForReuse
{
    [_tasteLabelView updateTastes:KDTasteNone];
}
- (IBAction)onTapEditButton:(id)sender
{
    if (_linkTableDelegate && [_linkTableDelegate respondsToSelector:@selector(onTapEditWithCell:model:)])
    {
        [_linkTableDelegate onTapEditWithCell:self model:_foodModel];
    }
}

- (IBAction)onTapDeleteButton:(id)sender
{
    if (_linkTableDelegate && [_linkTableDelegate respondsToSelector:@selector(onTapDeleteWithCell:model:)])
    {
        [_linkTableDelegate onTapDeleteWithCell:self model:_foodModel];
    }
}

- (IBAction)onTapChangeStatusButton:(id)sender
{
    if (_linkTableDelegate && [_linkTableDelegate respondsToSelector:@selector(onTapChangeStatusWithCell:model:)])
    {
        [_linkTableDelegate onTapChangeStatusWithCell:self model:_foodModel];
    }
}
@end
