//
//  KDOrderModel.m
//  KuaiDianPlan
//
//  Created by ppnd on 16/8/8.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDOrderModel.h"

@implementation KDOrderModel
- (void)encodeWithCoder:(NSCoder *)aCoder { [self yy_modelEncodeWithCoder:aCoder]; }
- (id)initWithCoder:(NSCoder *)aDecoder { return [self yy_modelInitWithCoder:aDecoder]; }
- (id)copyWithZone:(NSZone *)zone { return [self yy_modelCopy]; }
- (NSUInteger)hash { return [self yy_modelHash]; }
- (BOOL)isEqual:(id)object { return [self yy_modelIsEqual:object]; }

+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{@"orderID" : @"id",
             @"shopID" : @"sellerid",
             @"customerID" : @"customerid",
             @"isPayed" : @"payed",
             @"createTime" : @"createtime",
             @"overTime" : @"overtime",
             @"updateTime" : @"updatetime",
             @"startTime":@"starttime",
             @"evaluated" : @"evaluated",
             @"orderDescriptionString" : @"remark",
             @"pickUpCode" : @"secretkey",
             @"orderStatus" : @"state"};
}
+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"orderDetail":[KDOrderDetailModel class]};
}
@end
