//
//  KDShopManager.m
//  KuaiDianForSeller
//
//  Created by ppnd on 16/11/6.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDShopManager.h"

#define SHOP_INFO @"shop_info"

@interface KDShopManager()

@property(nonatomic,strong)KDShopModel *storedShopInfoModel;

@end

@implementation KDShopManager

+ (instancetype)sharedInstance
{
    __strong static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}
-(instancetype)init
{
    self = [super init];
    if (self)
    {
        KDShopModel *model = (KDShopModel *)[[KDCacheManager userCache] objectForKey:SHOP_INFO];
        if (VALIDATE_MODEL(model, @"KDShopModel"))
        {
            _storedShopInfoModel = model;
        }
    }
    
    return self;
}
-(KDShopModel *)getShopInfo
{
    return _storedShopInfoModel;
}

-(UIImage *)getShopLogo
{
    if (_storedShopInfoModel)
    {
        return (UIImage *)[[KDCacheManager systemCache] objectForKey:_storedShopInfoModel.imageURL];
    }
    return nil;
}
-(void)updateShopInfo:(KDShopModel *)shopInfo
{
    if (VALIDATE_MODEL(shopInfo, @"KDShopModel"))
    {
        _storedShopInfoModel = shopInfo;
        [[KDCacheManager userCache] setObject:_storedShopInfoModel forKey:SHOP_INFO];
    }
}
@end
