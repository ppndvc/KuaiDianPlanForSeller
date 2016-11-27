//
//  KDBankModel.h
//  KuaiDianForSeller
//
//  Created by ppnd on 16/11/1.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDBaseModel.h"

@interface KDBankModel : KDBaseModel

@property(nonatomic,assign)KDBankBrandType bankBrand;

@property(nonatomic,copy)NSString *bankName;

@property(nonatomic,copy)NSString *accountName;

@property(nonatomic,copy)NSString *sellerID;


@property(nonatomic,copy)NSString *identifer;

@property(nonatomic,copy)NSString *personalIdentifier;

@property(nonatomic,copy)NSString *cardNumer;

@property(nonatomic,copy)NSString *phoneNumber;

//获取格式化的卡号
-(NSString *)formatedCardNumber;

//隐藏真实数字的格式化卡号
-(NSString *)formatedVertualCardNumber;

@end
