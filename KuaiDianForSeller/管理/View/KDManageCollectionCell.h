//
//  KDManageCollectionCellCollectionViewCell.h
//  KuaiDianForSeller
//
//  Created by ppnd on 16/8/29.
//  Copyright © 2016年 zy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KDActionModel;

@interface KDManageCollectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

//配置cell
-(void)configureCellWithModel:(KDActionModel *)model;

@end
