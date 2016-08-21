//
//  KDActionCollectionViewCell.h
//  KuaiDianPlan
//
//  Created by ppnd on 16/7/24.
//  Copyright © 2016年 zy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KDActionModel;

@interface KDActionCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

//配置cell
-(void)configureCellWithModel:(KDActionModel *)model;

@end
