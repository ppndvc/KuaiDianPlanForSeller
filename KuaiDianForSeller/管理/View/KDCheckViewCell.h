//
//  KDFoodLabelCollectionCell.h
//  KuaiDianForSeller
//
//  Created by ppnd on 16/10/15.
//  Copyright © 2016年 zy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KDCheckViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *labelImage;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UIImageView *selectedImage;

//配置cell
-(void)configureCellWithModel:(id)model;
@end
