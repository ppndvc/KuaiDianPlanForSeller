//
//  KDBillModel.h
//  KuaiDianForSeller
//
//  Created by ppnd on 16/11/13.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDBaseModel.h"

@interface KDBillModel : KDBaseModel

@property(nonatomic,copy)NSString *name;

@property(nonatomic,assign)KDBillType billType;

@property(nonatomic,assign)CGFloat *amount;

@property(nonatomic,copy)NSString *date;

@property(nonatomic,copy)NSString *descriptionString;

@end
