//
//  KDUserModel.m
//  KuaiDianForSeller
//
//  Created by ppnd on 16/8/11.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDUserModel.h"

/*
 
 //用户名
 @property(nonatomic,copy)NSString *name;
 
 //id
 @property(nonatomic,copy)NSString *identifier;
 
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
 
 */

@implementation KDUserModel
- (void)encodeWithCoder:(NSCoder *)aCoder { [self yy_modelEncodeWithCoder:aCoder]; }
- (id)initWithCoder:(NSCoder *)aDecoder { return [self yy_modelInitWithCoder:aDecoder]; }
- (id)copyWithZone:(NSZone *)zone { return [self yy_modelCopy]; }
- (NSUInteger)hash { return [self yy_modelHash]; }
- (BOOL)isEqual:(id)object { return [self yy_modelIsEqual:object]; }

+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{@"name" : @"sellername",
             @"createTime" : @"createtime",
             @"money" : @"money",
             @"password" : @"password",
             @"telephone" : @"phone",
             @"shopID" : @"storeid",
             @"lastIP" : @"lastip",
             @"salt" : @"salt",
             @"identifier" : @"sellerid",
             @"updateTime" : @"updatetime",
             @"isValidate" : @"valid"};
}

-(void)updateModel:(id)model
{
    if (model && [model isKindOfClass:[self class]])
    {
        KDUserModel *tpm = (KDUserModel *)model;
        
        unsigned int propertyCount;
        objc_property_t *properties = class_copyPropertyList([self class], &propertyCount);
        
        for (int i = 0; i < propertyCount; i++)
        {
            objc_property_t property = properties[i];
            const char* char_f = property_getName(property);
            NSString *propertyName = [NSString stringWithUTF8String:char_f];
            id propertyValue = [tpm valueForKey:(NSString *)propertyName];
            if (propertyValue)
            {
                [self setValue:propertyValue forKey:(NSString *)propertyName];
            }
        }
        
        free(properties);
    }
}

@end

