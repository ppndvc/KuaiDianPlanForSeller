//
//  KDUserManager.m
//  KuaiDianForSeller
//
//  Created by ppnd on 16/8/11.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDUserManager.h"
#import "KDCacheManager.h"

#define USER_INFO @"user_info"
@interface KDUserManager()

@property(nonatomic,strong)KDUserModel *storedUserInfo;
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

-(BOOL)updateUserInfo:(KDUserModel *)userInfo
{
    if (userInfo && [userInfo isKindOfClass:[KDUserModel class]])
    {
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
