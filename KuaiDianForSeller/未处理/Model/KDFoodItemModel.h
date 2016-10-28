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
//类别id
@property(nonatomic,copy)NSString *category;
//类别描述
@property(nonatomic,copy)NSString *categoryDescription;
//imageurl
@property(nonatomic,copy)NSString *imageURL;
//描述
@property(nonatomic,copy)NSString *descriptionString;
//名字
@property(nonatomic,copy)NSString *name;
//订单id
@property(nonatomic,copy)NSString *orderID;
//价格
@property(nonatomic,assign)CGFloat price;
//数量
@property(nonatomic,assign)NSInteger quantity;
//口味
@property(nonatomic,assign)KDTasteType tasteType;
//食品状态
@property(nonatomic,assign)NSInteger status;

@end
