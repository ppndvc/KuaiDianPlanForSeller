//
//  KDUserManager.m
//  KuaiDianForSeller
//
//  Created by ppnd on 16/8/11.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDUserManager.h"
#import "KDCacheManager.h"
#import "KDShopModel.h"

#define USER_INFO @"user_info"
#define BANK_INFO @"bank_info"

@interface KDUserManager()

@property(nonatomic,strong)KDUserModel *storedUserInfo;

@property(nonatomic,strong)KDBankModel *storedUserBankInfo;

@end

@implementation KDUserManager
+ (instancetype)sharedInstance
{
    __strong static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

+(BOOL)isUserLogin
{
    BOOL isLogin = NO;
    
    NSString *cookieStr = (NSString *)[[KDCacheManager userCache] objectForKey:COOKIE_KEY];
    
    if (VALIDATE_STRING(cookieStr))
    {
        isLogin = YES;
    }
    
    return isLogin;
}

-(KDUserModel *)getUserInfo
{
    if (!_storedUserInfo)
    {
        KDUserModel *userInfo = (KDUserModel *)[[KDCacheManager userCache] objectForKey:USER_INFO];
        
        if (userInfo && [userInfo isKindOfClass:[KDUserModel class]])
        {
            _storedUserInfo = userInfo;
        }
    }
    
    return _storedUserInfo;
}

-(KDBankModel *)getUserBankInfo
{
    if (!_storedUserBankInfo)
    {
        _storedUserBankInfo = (KDBankModel *)[[KDCacheManager userCache] objectForKey:BANK_INFO];
    }
    
    return _storedUserBankInfo;
}

-(void)updateUserBankInfo:(KDBankModel *)bankInfo
{
    if (VALIDATE_MODEL(bankInfo, @"KDBankModel"))
    {
        _storedUserBankInfo = bankInfo;
        [[KDCacheManager userCache] setObject:_storedUserBankInfo forKey:BANK_INFO];
    }
}

-(BOOL)updateUserInfo:(KDUserModel *)userInfo
{
    if (userInfo && [userInfo isKindOfClass:[KDUserModel class]])
    {
        //可能切换了用户，要重置用户缓存
        [[KDCacheManager sharedInstance] switchUser:userInfo.identifier];
        
        //重置用户缓存后，才可以缓存用户数据
        [[KDCacheManager userCache] setObject:userInfo forKey:USER_INFO];

        if (_storedUserInfo)
        {
            [_storedUserInfo updateModel:userInfo];
        }
        else
        {
            _storedUserInfo = userInfo;
        }
        
        return YES;
    }
    else
    {
        return NO;
    }
}

-(BOOL)logout
{
    [[KDCacheManager userCache] removeAllObjects];

    return YES;
}
@end
