//
//  KDSaleActivityTableCell.h
//  KuaiDianForSeller
//
//  Created by ppnd on 16/9/7.
//  Copyright © 2016年 zy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KDActivityModel;

@interface KDSaleActivityTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
- (IBAction)onTapCreate:(id)sender;

//配置cell
-(void)configureCellWithModel:(KDActivityModel *)model;

@end
