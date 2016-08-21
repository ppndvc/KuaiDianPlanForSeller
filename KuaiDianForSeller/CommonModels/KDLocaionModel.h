//
//  KDLocaionModel.h
//  KuaiDianPlan
//
//  Created by ppnd on 16/7/24.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDBaseModel.h"

@interface KDLocaionModel : KDBaseModel

//位置ID
@property(nonatomic,copy)NSString *locationID;

//名称
@property(nonatomic,copy)NSString *locationName;

//纬度
@property(nonatomic,copy)NSString *latitude;

//经度
@property(nonatomic,copy)NSString *longitude;

@end
