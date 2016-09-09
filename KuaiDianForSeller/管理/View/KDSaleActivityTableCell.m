//
//  KDSaleActivityTableCell.m
//  KuaiDianForSeller
//
//  Created by ppnd on 16/9/7.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDSaleActivityTableCell.h"
#import "KDActivityModel.h"

#define ACTIVITY_IMAGE_NAME_PREFIX @"activity"

@implementation KDSaleActivityTableCell

- (void)awakeFromNib
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Initialization code
}

-(void)configureCellWithModel:(KDActivityModel *)model
{
    if (model)
    {
        _titleLabel.text = model.title;
        _descriptionLabel.text = model.descriptionString;
//        NSString *m = [NSString stringWithFormat:@"%@%ld",ACTIVITY_IMAGE_NAME_PREFIX,model.type];
        _iconImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%ld",ACTIVITY_IMAGE_NAME_PREFIX,model.type]];
    }
}
- (IBAction)onTapCreate:(id)sender {
}
@end
