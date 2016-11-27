//
//  KDCacheManager.m
//  KuaiDianPlan
//
//  Created by ppnd on 16/6/18.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDCacheManager.h"
#import "KDEnvironmentManager.h"

@interface KDCacheManager ()

//登陆用户id
@property(nonatomic,copy)NSString *userID;

@property (strong, readonly) YYCache *systemCacheInDisk;

@property (strong, readonly) YYCache *userCacheInDisk;

@property (strong, readonly) YYMemoryCache *commonCacheInMemory;

@end

@implementation KDCacheManager
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
    return self;
}

-(YYCache *)_systemCache
{
    if (!_systemCacheInDisk)
    {
        if([[KDEnvironmentManager sharedInstance] getEnvironmentType] == KDEnvironmentTypeOfTest)
        {
            _systemCacheInDisk = [YYCache cacheWithName:kSystemCacheNameForTest];//[NSString stringWithFormat:@"%@_%@",_userID,kSystemCacheNameForTest]];
        }
        else
        {
            _systemCacheInDisk = [YYCache cacheWithName:kSystemCacheName];//[NSString stringWithFormat:@"%@_%@",_userID,kSystemCacheName]];
        }
    }
    
    return _systemCacheInDisk;
}
-(YYCache *)_userCache
{
    if (!_userCacheInDisk)
    {
        if([[KDEnvironmentManager sharedInstance] getEnvironmentType] == KDEnvironmentTypeOfTest)
        {
            NSString *cacheName = kUserCacheNameForTest;//[NSString stringWithFormat:@"%@_%@",_userID,kUserCacheNameForTest];
            _userCacheInDisk = [YYCache cacheWithName:cacheName];
        }
        else
        {
            NSString *cacheName = kUserCacheName;//[NSString stringWithFormat:@"%@_%@",_userID,kUserCacheName];
            _userCacheInDisk = [YYCache cacheWithName:cacheName];
        }
    }
    
    return _userCacheInDisk;
}
-(YYMemoryCache *)_commonCache
{
    if (!_commonCacheInMemory)
    {
        _commonCacheInMemory = [YYMemoryCache new];
        _commonCacheInMemory.name = kCommonCacheInMemoryName;
    }
    
    return _commonCacheInMemory;
}

-(void)switchUser:(NSString *)userID
{
    if (VALIDATE_STRING(userID))
    {
        _userID = userID;
        _userCacheInDisk = nil;
    }
}
#pragma mark - public methods
+(YYCache *)systemCache
{
    return [[KDCacheManager sharedInstance] _systemCache];
}

+(YYCache *)userCache
{
    return [[KDCacheManager sharedInstance] _userCache];
}

+(YYMemoryCache *)commonCache
{
    return [[KDCacheManager sharedInstance] _commonCache];
}
@end
