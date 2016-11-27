//
//  KDCustomerReplyModel.m
//  KuaiDianForSeller
//
//  Created by ppnd on 16/9/4.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDCustomerReplyModel.h"

@implementation KDCustomerReplyModel
- (void)encodeWithCoder:(NSCoder *)aCoder { [self yy_modelEncodeWithCoder:aCoder]; }
- (id)initWithCoder:(NSCoder *)aDecoder { self = [super init]; return [self yy_modelInitWithCoder:aDecoder]; }
- (id)copyWithZone:(NSZone *)zone { return [self yy_modelCopy]; }
- (NSUInteger)hash { return [self yy_modelHash]; }
- (BOOL)isEqual:(id)object { return [self yy_modelIsEqual:object]; }
- (NSString *)description { return [self yy_modelDescription]; }

+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{@"replyerName" : @"customername",
             @"date" : @"createtime",
             @"content" : @"content",
             @"customerID":@"customerid",
             @"isAnonymous" : @"anonymous",
             @"identifier":@"id",
             @"score" : @"level"};
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic
{
    NSArray *replysArray = dic[@"replies"];

    if (VALIDATE_ARRAY(replysArray))
    {
        NSArray *replys = [NSArray yy_modelArrayWithClass:[KDBaseReplyModel class] json:replysArray];
        if (VALIDATE_ARRAY(replys))
        {
            _sellerReply = [replys firstObject];
        }
    }

    return YES;
}
/*
 
 isAnonymous
 
 //用户头像url
 @property(nonatomic,copy)NSString *imageURL;
 
 //用户id
 @property(nonatomic,copy)NSString *customerID;
 
 //平分
 @property(nonatomic,assign)CGFloat score;
 
 //商家回复
 @property(nonatomic,strong)KDBaseReplyModel *sellerReply;
 
 
 anonymous = 1;
 content = "\U95f2\U6765\U901b\U901b\U3002";
 createtime = 1474550040000;
 customerid = 1;
 customername = "\U8363";
 id = 7;
 level = 2;
 replies =             (
 {
 content = "\U4f7f\U52b2\U52a0\U6cb9";
 createtime = 1475354559000;
 evaluateid = 7;
 id = 23;
 sellerid = 13;
 }
 );
 storeid = 1;
 storename = "\U725b\U8089\U9762\U9986";
 
 */
@end
