//
//  KDActivityModel.h
//  KuaiDianPlan
//
//  Created by ppnd on 16/7/24.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDBaseModel.h"

@interface KDActivityModel : KDBaseModel

//活动标题
@property(nonatomic,copy)NSString *title;

//活动图片名字
@property(nonatomic,copy)NSString *imageName;

//活动类型
@property(nonatomic,assign)KDActivityType type;

//活动开始日期
@property(nonatomic,copy)NSString *startDate;

//活动结束日期
@property(nonatomic,copy)NSString *endDate;

//活动描述
@property(nonatomic,copy)NSString *descriptionString;

//保底消费金额
@property(nonatomic,assign)CGFloat activeLine;

//优惠金额、折扣
@property(nonatomic,assign)CGFloat discount;

@end
