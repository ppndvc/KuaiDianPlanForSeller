//
//  KDBaseTableViewCell.h
//  KuaiDianPlan
//
//  Created by ppnd on 16/8/3.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "MGSwipeTableCell.h"
#import "KDCellDelegate.h"
#import "UIButton+BackgroundColor.h"

@interface KDBaseTableViewCell : MGSwipeTableCell <KDCellDelegate>

//代理
@property(nonatomic,weak)id<KDCellDelegate> cellDelegate;

//配置model
-(void)configureCellWithModel:(id)model;
@end
