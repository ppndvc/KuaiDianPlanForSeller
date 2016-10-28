//
//  KDUserModel.h
//  KuaiDianForSeller
//
//  Created by ppnd on 16/8/11.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDBaseModel.h"

@interface KDUserModel : KDBaseModel

/*
 createtime = 1470842686000;
 lastip = "115.198.96.199";
 money = 1;
 password = f4abbeab1c23675cd1563e97d257c95c;
 phone = 13502051792;
 salt = 3a66efc0cc0d5daec42fd7d33f468016;
 sellerid = 13;
 sellername = test;
 storeid = 1;
 updatetime = 1474983384000;
 valid = 1;
 */

//用户名
@property(nonatomic,copy)NSString *name;

//id
@property(nonatomic,copy)NSString *identifier;

//storeid
@property(nonatomic,copy)NSString *shopID;

//ip
@property(nonatomic,copy)NSString *lastIP;

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
