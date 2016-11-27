//
//  KDSaleStatisticInfoModel.h
//  KuaiDianForSeller
//
//  Created by ppnd on 16/11/3.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDBaseModel.h"

@interface KDSaleStatisticInfoModel : KDBaseModel

//生成日期
@property(nonatomic,assign)NSTimeInterval date;

//id
@property(nonatomic,copy)NSString *identifier;

//店铺id
@property(nonatomic,copy)NSString *storeID;

//总金额
@property(nonatomic,assign)CGFloat money;

//总订单
@property(nonatomic,assign)NSInteger orderCount;

@end
