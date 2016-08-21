//
//  KDOrderTableViewCell.h
//  KuaiDianPlan
//
//  Created by ppnd on 16/8/6.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDBaseTableViewCell.h"
#import "KDOrderModel.h"

@interface KDOrderTableViewCell : KDBaseTableViewCell

//标题
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
//取货码
@property (weak, nonatomic) IBOutlet UILabel *codeLabel;
//图标
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
//箭头图标
@property (weak, nonatomic) IBOutlet UIImageView *arrayIconImageView;
//菜名等
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
//订单时间
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
//订单状态
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
//订单进度
@property (weak, nonatomic) IBOutlet UILabel *processLabel;
//价格
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
//操作按钮
@property (weak, nonatomic) IBOutlet UIButton *actionButton;

//配置cell
-(void)configureCellModel:(KDOrderModel *)model;

@end
