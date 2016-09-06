//
//  KDOrderDetailTableViewCell.m
//  KuaiDianForSeller
//
//  Created by ppnd on 16/8/21.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDOrderDetailTableViewCell.h"
#import "KDFoodItemModel.h"

@implementation KDOrderDetailTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)prepareForReuse
{
    _priceLabel.textColor = [UIColor darkGrayColor];
}
-(void)configureCellWithModel:(KDFoodItemModel *)model
{
    if (model)
    {
        _nameLabel.text = model.name;
        _countLabel.text = [NSString stringWithFormat:@"x %ld",model.quantity];
        _priceLabel.text = [NSString stringWithFormat:@"￥%.2f",model.price];
    }
}
@end
