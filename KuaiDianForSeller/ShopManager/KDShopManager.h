//
//  KDShopManager.h
//  KuaiDianForSeller
//
//  Created by ppnd on 16/11/6.
//  Copyright © 2016年 zy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KDShopModel.h"

@interface KDShopManager : NSObject

//唯一实力
+ (instancetype)sharedInstance;

//获取logo
-(UIImage *)getShopLogo;
//获取商铺信息
-(KDShopModel *)getShopInfo;
//设置商铺信息
-(void)updateShopInfo:(KDShopModel *)shopInfo;

@end
