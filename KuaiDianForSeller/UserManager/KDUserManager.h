//
//  KDUserManager.h
//  KuaiDianForSeller
//
//  Created by ppnd on 16/8/11.
//  Copyright © 2016年 zy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KDUserModel.h"

@interface KDUserManager : NSObject

//唯一实力
+ (instancetype)sharedInstance;

//用户是否登陆
+(BOOL)isUserLogin;

//获取用户信息
-(KDUserModel *)getUserInfo;

//更新登陆信息
-(BOOL)updateUserInfo:(KDUserModel *)userInfo;

//退出登陆
-(BOOL)logout;

@end
