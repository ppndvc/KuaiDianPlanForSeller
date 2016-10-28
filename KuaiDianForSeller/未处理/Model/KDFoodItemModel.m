//
//  KDOrderDetailModel.m
//  KuaiDianForSeller
//
//  Created by ppnd on 16/8/17.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDFoodItemModel.h"

@implementation KDFoodItemModel
- (void)encodeWithCoder:(NSCoder *)aCoder { [self yy_modelEncodeWithCoder:aCoder]; }
- (id)initWithCoder:(NSCoder *)aDecoder { return [self yy_modelInitWithCoder:aDecoder]; }
- (id)copyWithZone:(NSZone *)zone { return [self yy_modelCopy]; }
- (NSUInteger)hash { return [self yy_modelHash]; }
- (BOOL)isEqual:(id)object { return [self yy_modelIsEqual:object]; }

+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{@"name" : @"name",
             @"foodID" : @"id",
             @"category" : @"classifyid",
             @"imageURL" : @"logourl",
             @"orderID" : @"orderid",
             @"price" : @"price",
             @"quantity" : @"quantity"};
}
-(void)updateModel:(KDFoodItemModel *)model
{
    if (VALIDATE_MODEL(model, @"KDFoodItemModel"))
    {
        if (![model isEqual:self])
        {
            self.foodID = model.foodID;
            self.category = model.category;
            self.categoryDescription = model.descriptionString;
            self.imageURL = model.imageURL;
            self.descriptionString = model.descriptionString;
            self.name = model.name;
            self.orderID = model.orderID;
            self.price = model.price;
            self.quantity = model.quantity;
            self.tasteType = model.tasteType;
            self.status = model.status;
        }
    }
}
@end
