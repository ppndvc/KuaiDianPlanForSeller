//
//  KDEvalueFilterItemModel.h
//  KuaiDianForSeller
//
//  Created by ppnd on 16/9/6.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDBaseModel.h"

@interface KDEvalueFilterItemModel : KDBaseModel

//标题
@property(nonatomic,copy)NSString *title;

//等级
@property(nonatomic,assign)KDEvalueStarLevel level;

//选中
@property(nonatomic,assign)BOOL isSelected;

@end
