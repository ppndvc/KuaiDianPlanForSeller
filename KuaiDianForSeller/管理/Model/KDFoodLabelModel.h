//
//  KDFoodLabelModel.h
//  KuaiDianForSeller
//
//  Created by ppnd on 16/10/15.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDBaseModel.h"

@interface KDFoodLabelModel : KDBaseModel

//名称
@property(nonatomic,copy)NSString *name;

//口味类型
@property(nonatomic,assign)KDTasteType tasteType;

//选中
@property(nonatomic,assign)BOOL isSelected;

@end

