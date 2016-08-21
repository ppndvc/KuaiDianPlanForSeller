//
//  KDUserModel.h
//  KuaiDianForSeller
//
//  Created by ppnd on 16/8/11.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDBaseModel.h"

@interface KDUserModel : KDBaseModel

//用户名
@property(nonatomic,copy)NSString *name;

//id
@property(nonatomic,copy)NSString *identifier;

//salt ????????
@property(nonatomic,copy)NSString *salt;

//密码
@property(nonatomic,copy)NSString *password;

//银行卡号
@property(nonatomic,copy)NSString *cardNumber;

//电话
@property(nonatomic,copy)NSString *telephone;

//地址
@property(nonatomic,copy)NSString *address;

//头像url
@property(nonatomic,copy)NSString *imageURL;

//剩余金额
@property(nonatomic,assign)CGFloat money;

//创建时间
@property(nonatomic,assign)NSTimeInterval createTime;

//更新时间
@property(nonatomic,assign)NSTimeInterval updateTime;

//是否有效
@property(nonatomic,assign)NSInteger isValidate;
////
//@property(nonatomic,copy)NSString *name;
//
////
//@property(nonatomic,copy)NSString *name;

@end
