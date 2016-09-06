//
//  KDBaseTableViewCell.m
//  KuaiDianPlan
//
//  Created by ppnd on 16/8/3.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDBaseTableViewCell.h"

@implementation KDBaseTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)configureCellWithModel:(id)model
{
    //子类实现
}
@end
