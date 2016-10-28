//
//  KDShopModel.m
//  KuaiDianPlan
//
//  Created by ppnd on 16/7/24.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDShopModel.h"

@implementation KDShopModel
- (void)encodeWithCoder:(NSCoder *)aCoder { [self yy_modelEncodeWithCoder:aCoder]; }
- (id)initWithCoder:(NSCoder *)aDecoder { return [self yy_modelInitWithCoder:aDecoder]; }
- (id)copyWithZone:(NSZone *)zone { return [self yy_modelCopy]; }
- (NSUInteger)hash { return [self yy_modelHash]; }
- (BOOL)isEqual:(id)object { return [self yy_modelIsEqual:object]; }

+ (NSDictionary *)modelCustomPropertyMapper
{
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
}

@end
