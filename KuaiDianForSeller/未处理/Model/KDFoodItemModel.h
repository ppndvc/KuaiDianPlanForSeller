//
//  KDOrderDetailModel.h
//  KuaiDianForSeller
//
//  Created by ppnd on 16/8/17.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDBaseModel.h"

@interface KDFoodItemModel : KDBaseModel

//菜品id
@property(nonatomic,copy)NSString *foodID;
//id
@property(nonatomic,copy)NSString *identifier;
//imageurl
@property(nonatomic,copy)NSString *imageURL;
//名字
@property(nonatomic,copy)NSString *name;
//订单id
@property(nonatomic,copy)NSString *orderID;
//价格
@property(nonatomic,assign)CGFloat price;
//数量
@property(nonatomic,assign)NSInteger quantity;

@end
