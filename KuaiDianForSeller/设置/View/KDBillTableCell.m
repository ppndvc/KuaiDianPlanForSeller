//
//  KDBillTableCell.m
//  KuaiDianForSeller
//
//  Created by ppnd on 16/11/13.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDBillTableCell.h"
#import "KDBillModel.h"

@implementation KDBillTableCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)configureCellWithModel:(KDBillModel *)model
{
    if (VALIDATE_MODEL(model, @"KDBillModel"))
    {
        
    }
}
@end
