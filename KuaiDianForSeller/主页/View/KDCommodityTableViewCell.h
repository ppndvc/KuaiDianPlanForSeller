//
//  KDCommodityTableViewCell.h
//  KuaiDianPlan
//
//  Created by ppnd on 16/8/4.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDShopCellTableViewCell.h"
@class KDCommodityModel;

@interface KDCommodityTableViewCell : KDShopCellTableViewCell

//配置cell
-(void)configureCellWithModel:(KDCommodityModel *)model;

@end
