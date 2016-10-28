//
//  KDCheckViewItemModel.m
//  KuaiDianForSeller
//
//  Created by ppnd on 16/10/20.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDCheckViewItemModel.h"

@implementation KDCheckViewItemModel
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
