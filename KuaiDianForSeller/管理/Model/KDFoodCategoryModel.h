//
//  KDFoodCategoryModel.h
//  KuaiDianForSeller
//
//  Created by ppnd on 16/10/10.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDBaseModel.h"

@interface KDFoodCategoryModel : KDBaseModel

//名称
@property(nonatomic,copy)NSString *name;

//类别id
@property(nonatomic,copy)NSString *category;

//storeid
@property(nonatomic,copy)NSString *shopID;

@end
