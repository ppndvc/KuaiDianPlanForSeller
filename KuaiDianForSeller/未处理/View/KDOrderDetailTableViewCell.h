//
//  KDOrderDetailTableViewCell.h
//  KuaiDianForSeller
//
//  Created by ppnd on 16/8/21.
//  Copyright © 2016年 zy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KDFoodItemModel;

@interface KDOrderDetailTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

//配置cell
-(void)configureCellWithModel:(KDFoodItemModel *)model;
@end
