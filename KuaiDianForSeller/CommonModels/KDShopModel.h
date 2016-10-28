//
//  KDShopModel.h
//  KuaiDianPlan
//
//  Created by ppnd on 16/7/24.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDBaseModel.h"

@interface KDShopModel : KDBaseModel

/*
 addressdetial = "\U4e8c\U697c3\U53f7\U7a97\U53e3";
 id = 1;
 logourl = "/root/img/demoUploadb77205432e97cb770e99c241c49ac7df";
 name = "\U98df\U529b\U6d3e\U9910\U5385";
 notice = "\U4f60\U7684\U80fd\U91cf\U8d85\U4e4e\U4f60\U60f3\U8c61\U3002";
 online = 1;
 ordernumber = 13323337569;
 restaurant = "\U4e1c\U82d1\U4e8c\U53f7\U9910\U5385";
 runtime = "-23580000";
 school = "\U5929\U6d25\U5de5\U4e1a\U5927\U5b66";
 state = 1;
 stoptime = "-19920000";
 todaymoney = 0;
 
 return @{@"name" : @"name",
 @"shopID" : @"id",
 @"belongSchool" : @"school",
 @"belongRestaurant" : @"restaurant",
 @"imageURL" : @"logourl",
 @"openTime" : @"runtime",
 @"telephone" : @"ordernumber",
 @"address" : @"addressdetial",
 @"notice" : @"notice",
 @"shopStatus" : @"state",
 @"closeTime" : @"stoptime",
 @"salesMoney" : @"todaymoney",
 @"payStyle" : @"online"};
 
 */

//商家名字
@property(nonatomic,copy)NSString *name;

//商家ID
@property(nonatomic,copy)NSString *shopID;

//所属学校
@property(nonatomic,copy)NSString *belongSchool;

//所属食堂
@property(nonatomic,copy)NSString *belongRestaurant;

//图片地址
@property(nonatomic,copy)NSString *imageURL;

//图片名字
@property(nonatomic,copy)NSString *imageName;

//营业时间
@property(nonatomic,copy)NSString *openTime;

//停业时间
@property(nonatomic,copy)NSString *closeTime;

//联系电话
@property(nonatomic,copy)NSString *telephone;

//支付方式
@property(nonatomic,assign)KDPayStyle payStyle;

//地址
@property(nonatomic,copy)NSString *address;

//公告
@property(nonatomic,copy)NSString *notice;

//分类
@property(nonatomic,copy)NSString *category;

//商家营业状态
@property(nonatomic,assign)KDShopStatus shopStatus;

//活动
@property(nonatomic,strong)NSArray *activityArray;

//商家平分
@property(nonatomic,assign)CGFloat score;

//销量
@property(nonatomic,assign)NSInteger salesVolume;

//营业额
@property(nonatomic,assign)CGFloat salesMoney;

//剩余数量
@property(nonatomic,assign)NSInteger remainCount;

//最低价
@property(nonatomic,assign)CGFloat minPrice;

//活动价
@property(nonatomic,assign)CGFloat activityPrice;
//
////运费
//@property(nonatomic,assign)CGFloat transportExpend;
//
////距离
//@property(nonatomic,assign)CGFloat distance;

@end
