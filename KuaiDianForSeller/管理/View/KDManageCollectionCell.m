//
//  KDManageCollectionCellCollectionViewCell.m
//  KuaiDianForSeller
//
//  Created by ppnd on 16/8/29.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDManageCollectionCell.h"
#import "KDActionModel.h"

@implementation KDManageCollectionCell

//配置cell
-(void)configureCellWithModel:(KDActionModel *)model
{
    if (model)
    {
        _imageView.image = [UIImage imageNamed:model.imageName];
        _nameLabel.text = model.title;
    }
}

@end
