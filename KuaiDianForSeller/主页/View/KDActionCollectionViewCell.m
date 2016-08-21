//
//  KDActionCollectionViewCell.m
//  KuaiDianPlan
//
//  Created by ppnd on 16/7/24.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDActionCollectionViewCell.h"
#import "KDActionModel.h"

@implementation KDActionCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}
-(void)configureCellWithModel:(KDActionModel *)model
{
    if(model)
    {
        self.titleLabel.text = model.title;
        self.imageView.image = [UIImage imageNamed:model.imageName];
    }
}
@end
