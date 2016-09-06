//
//  KDOrderModel.h
//  KuaiDianPlan
//
//  Created by ppnd on 16/8/8.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDBaseModel.h"
#import "KDFoodItemModel.h"
#import "KDFoodItemModel.h"

@interface KDOrderModel : KDBaseModel

//订单ID
@property(nonatomic,copy)NSString *orderID;

//顾客ID
@property(nonatomic,copy)NSString *customerID;

//商家名字
@property(nonatomic,copy)NSString *shopName;

//商家ID
@property(nonatomic,copy)NSString *shopID;

//订单详情
@property(nonatomic,strong)NSArray *orderDetail;

//订单描述
@property(nonatomic,copy)NSString *orderDescriptionString;

//订单状态
@property(nonatomic,assign)KDOrderStatus orderStatus;

//状态描述
@property(nonatomic,copy)NSString *statusDescriptionString;

//电话
@property(nonatomic,copy)NSString *phoneNumber;

//总价
@property(nonatomic,assign)CGFloat totalPrice;

//生成时间
@property(nonatomic,assign)NSTimeInterval createTime;

//开始时间
@property(nonatomic,assign)NSTimeInterval startTime;

//过期时间
@property(nonatomic,assign)NSTimeInterval overTime;

//更新时间
@property(nonatomic,assign)NSTimeInterval updateTime;

//取货码
@property(nonatomic,copy)NSString *pickUpCode;

//平分
@property(nonatomic,copy)NSString *evaluated;

//是否支付
@property(nonatomic,assign)BOOL isPayed;


@end
