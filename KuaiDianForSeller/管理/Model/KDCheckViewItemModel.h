//
//  KDCheckViewItemModel.h
//  KuaiDianForSeller
//
//  Created by ppnd on 16/10/20.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDBaseModel.h"

@interface KDCheckViewItemModel : KDBaseModel

//名称
@property(nonatomic,copy)NSString *name;

//图片
@property(nonatomic,copy)NSString *imageName;

//选中
@property(nonatomic,assign)BOOL isSelected;

@end
