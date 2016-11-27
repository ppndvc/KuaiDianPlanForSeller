//
//  KDBankModel.m
//  KuaiDianForSeller
//
//  Created by ppnd on 16/11/1.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDBankModel.h"

@implementation KDBankModel

- (void)encodeWithCoder:(NSCoder *)aCoder { [self yy_modelEncodeWithCoder:aCoder]; }
- (id)initWithCoder:(NSCoder *)aDecoder { self = [super init]; return [self yy_modelInitWithCoder:aDecoder]; }
- (id)copyWithZone:(NSZone *)zone { return [self yy_modelCopy]; }
- (NSUInteger)hash { return [self yy_modelHash]; }
- (BOOL)isEqual:(id)object { return [self yy_modelIsEqual:object]; }
- (NSString *)description { return [self yy_modelDescription]; }

+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{@"accountName" : @"accountname",
             @"cardNumer" : @"card",
             @"phoneNumber" : @"phone",
             @"bankBrand" : @"bankname",
             @"sellerID" : @"sellerid",
             @"personalIdentifier":@"identity",
             @"identifier" : @"id"};
}
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic
{
    switch (_bankBrand)
    {
        case KDNongYeBank:
            _bankName = NONYE_BANK_TILTE;
            break;
        case KDJianSheBank:
            _bankName = JIANSHE_BANK_TILTE;
            break;
        default:
            break;
    }
    
    return YES;
}

-(NSString *)formatedCardNumber
{
    return [NSString getFormateCardNumberFromString:_cardNumer];
}

-(NSString *)formatedVertualCardNumber
{
    NSString *formateNumber = [NSString getVertualCardNumberStringWithString:_cardNumer];
    return [NSString getFormateCardNumberFromString:formateNumber];
}
@end
