//
//  KDAdvertiseModel.h
//  KuaiDianPlan
//
//  Created by ppnd on 16/7/24.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDBaseModel.h"

@interface KDAdvertiseModel : KDBaseModel
 
//图片地址
@property(nonatomic,copy)NSString *imageURL;

//标题
@property(nonatomic,copy)NSString *title;

//内容地址
@property(nonatomic,copy)NSString *contentURL;

@end
