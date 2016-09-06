//
//  KDEvalueFilterCollectionCell.h
//  KuaiDianForSeller
//
//  Created by ppnd on 16/9/6.
//  Copyright © 2016年 zy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KDEvalueFilterItemModel;

@interface KDEvalueFilterCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

//配置cell
-(void)configureCellWithModel:(KDEvalueFilterItemModel *)model;

@end
