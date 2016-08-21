//
//  KDActionModel.h
//  KuaiDianPlan
//
//  Created by ppnd on 16/7/24.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDBaseModel.h"

@interface KDActionModel : KDBaseModel

//标题
@property(nonatomic,copy)NSString *title;

//操作
@property(nonatomic,copy)NSString *actionString;

//图片名字
@property(nonatomic,copy)NSString *imageName;

//图片地址
@property(nonatomic,copy)NSString *imageURL;

@end
