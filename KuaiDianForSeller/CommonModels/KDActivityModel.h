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

@end
