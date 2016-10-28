//
//  KDFoodLabelModel.m
//  KuaiDianForSeller
//
//  Created by ppnd on 16/10/15.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDFoodLabelModel.h"

@implementation KDFoodLabelModel

- (void)encodeWithCoder:(NSCoder *)aCoder { [self yy_modelEncodeWithCoder:aCoder]; }
- (id)initWithCoder:(NSCoder *)aDecoder { return [self yy_modelInitWithCoder:aDecoder]; }
- (id)copyWithZone:(NSZone *)zone { return [self yy_modelCopy]; }
- (NSUInteger)hash { return [self yy_modelHash]; }
- (BOOL)isEqual:(id)object { return [self yy_modelIsEqual:object]; }

//+ (NSDictionary *)modelCustomPropertyMapper
//{
//    return @{@"name" : @"name",
//             @"category" : @"id",
//             @"shopID" : @"storeid"};
//}

@end
