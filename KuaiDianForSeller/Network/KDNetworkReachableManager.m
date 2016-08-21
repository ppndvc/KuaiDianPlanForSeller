//
//  KDNetworkReachableManager.m
//  KuaiDianPlan
//
//  Created by ppnd on 16/6/11.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDNetworkReachableManager.h"

NSString * const KDNetworkingReachabilityDidChangeNotification = @"com.alamofire.networking.reachability.change";
NSString * const KDNetworkingReachabilityNotificationStatusItem = @"KDNetworkingReachabilityNotificationStatusItem";

typedef void (^KDNetworkReachabilityStatusBlock)(KDNetworkReachabilityStatus status);

typedef NS_ENUM(NSUInteger, KDNetworkReachabilityAssociation) {
    KDNetworkReachabilityForAddress = 1,
    KDNetworkReachabilityForAddressPair = 2,
    KDNetworkReachabilityForName = 3,
};

NSString * KDStringFromNetworkReachabilityStatus(KDNetworkReachabilityStatus status) {
    switch (status) {
        case KDNetworkReachabilityStatusNotReachable:
            return NSLocalizedStringFromTable(@"Not Reachable", @"AFNetworking", nil);
        case KDNetworkReachabilityStatusReachableViaWWAN2G:
            return NSLocalizedStringFromTable(@"Reachable via WWAN2G", @"AFNetworking", nil);
        case KDNetworkReachabilityStatusReachableViaWWAN3G:
            return NSLocalizedStringFromTable(@"Reachable via WWAN3G", @"AFNetworking", nil);
        case KDNetworkReachabilityStatusReachableViaWiFi:
            return NSLocalizedStringFromTable(@"Reachable via WiFi", @"AFNetworking", nil);
        case KDNetworkReachabilityStatusUnknown:
        default:
            return NSLocalizedStringFromTable(@"Unknown", @"AFNetworking", nil);
    }
}

static KDNetworkReachabilityStatus KDNetworkReachabilityStatusForFlags(SCNetworkReachabilityFlags flags) {
    BOOL isReachable = ((flags & kSCNetworkReachabilityFlagsReachable) != 0);
    BOOL needsConnection = ((flags & kSCNetworkReachabilityFlagsConnectionRequired) != 0);
    BOOL canConnectionAutomatically = (((flags & kSCNetworkReachabilityFlagsConnectionOnDemand ) != 0) || ((flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) != 0));
    BOOL canConnectWithoutUserInteraction = (canConnectionAutomatically && (flags & kSCNetworkReachabilityFlagsInterventionRequired) == 0);
    BOOL isNetworkReachable = (isReachable && (!needsConnection || canConnectWithoutUserInteraction));
    
    KDNetworkReachabilityStatus status = KDNetworkReachabilityStatusUnknown;
    if (isNetworkReachable == NO) {
        status = KDNetworkReachabilityStatusNotReachable;
    }
#if	TARGET_OS_IPHONE
    else if ((flags & kSCNetworkReachabilityFlagsIsWWAN) != 0)
    {
        if((flags & kSCNetworkReachabilityFlagsReachable) == kSCNetworkReachabilityFlagsReachable)
        {
            if ((flags & kSCNetworkReachabilityFlagsTransientConnection) == kSCNetworkReachabilityFlagsTransientConnection)
            {
                status = KDNetworkReachabilityStatusReachableViaWWAN3G;
                
                if((flags & kSCNetworkReachabilityFlagsConnectionRequired) == kSCNetworkReachabilityFlagsConnectionRequired)
                {
                    status = KDNetworkReachabilityStatusReachableViaWWAN2G;
                }
            }
        }
    }
#endif
    else {
        status = KDNetworkReachabilityStatusReachableViaWiFi;
    }
    
    return status;
}

static void KDNetworkReachabilityCallback(SCNetworkReachabilityRef __unused target, SCNetworkReachabilityFlags flags, void *info) {
    KDNetworkReachabilityStatus status = KDNetworkReachabilityStatusForFlags(flags);
    KDNetworkReachabilityStatusBlock block = (__bridge KDNetworkReachabilityStatusBlock)info;
    if (block) {
        block(status);
    }
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
        [notificationCenter postNotificationName:KDNetworkingReachabilityDidChangeNotification object:nil userInfo:@{ KDNetworkingReachabilityNotificationStatusItem: @(status) }];
    });
    
}

static const void * KDNetworkReachabilityRetainCallback(const void *info) {
    return Block_copy(info);
}

static void KDNetworkReachabilityReleaseCallback(const void *info) {
    if (info) {
        Block_release(info);
    }
}

@interface KDNetworkReachableManager ()
@property (readwrite, nonatomic, assign) SCNetworkReachabilityRef networkReachability;
@property (readwrite, nonatomic, assign) KDNetworkReachabilityAssociation networkReachabilityAssociation;
@property (readwrite, nonatomic, assign) KDNetworkReachabilityStatus networkReachabilityStatus;
@property (readwrite, nonatomic, copy) KDNetworkReachabilityStatusBlock networkReachabilityStatusBlock;
@end

@implementation KDNetworkReachableManager

+ (instancetype)sharedManager {
    static KDNetworkReachableManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        struct sockaddr_in address;
        bzero(&address, sizeof(address));
        address.sin_len = sizeof(address);
        address.sin_family = AF_INET;
        
        _sharedManager = [self managerForAddress:&address];
    });
    
    return _sharedManager;
}

+ (instancetype)managerForDomain:(NSString *)domain {
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithName(kCFAllocatorDefault, [domain UTF8String]);
    
    KDNetworkReachableManager *manager = [[self alloc] initWithReachability:reachability];
    manager.networkReachabilityAssociation = KDNetworkReachabilityForName;
    
    return manager;
}

+ (instancetype)managerForAddress:(const struct sockaddr_in *)address {
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr *)address);
    
    KDNetworkReachableManager *manager = [[self alloc] initWithReachability:reachability];
    manager.networkReachabilityAssociation = KDNetworkReachabilityForAddress;
    
    return manager;
}

- (instancetype)initWithReachability:(SCNetworkReachabilityRef)reachability {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.networkReachability = reachability;
    self.networkReachabilityStatus = KDNetworkReachabilityStatusUnknown;
    
    return self;
}

- (void)dealloc {
    [self stopMonitoring];
    
    if (_networkReachability) {
        CFRelease(_networkReachability);
        _networkReachability = NULL;
    }
}

#pragma mark -

- (BOOL)isReachable {
    return [self isReachableViaWWAN2G] ||[self isReachableViaWWAN3G] || [self isReachableViaWiFi];
}

- (BOOL)isReachableViaWWAN2G {
    return self.networkReachabilityStatus == KDNetworkReachabilityStatusReachableViaWWAN2G;
}

- (BOOL)isReachableViaWWAN3G {
    return self.networkReachabilityStatus == KDNetworkReachabilityStatusReachableViaWWAN3G;
}

- (BOOL)isReachableViaWiFi {
    return self.networkReachabilityStatus == KDNetworkReachabilityStatusReachableViaWiFi;
}

#pragma mark -

- (void)startMonitoring {
    [self stopMonitoring];
    
    if (!self.networkReachability) {
        return;
    }
    
    __weak __typeof(self)weakSelf = self;
    KDNetworkReachabilityStatusBlock callback = ^(KDNetworkReachabilityStatus status) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        strongSelf.networkReachabilityStatus = status;
        if (strongSelf.networkReachabilityStatusBlock) {
            strongSelf.networkReachabilityStatusBlock(status);
        }
        
    };
    
    SCNetworkReachabilityContext context = {0, (__bridge void *)callback, KDNetworkReachabilityRetainCallback, KDNetworkReachabilityReleaseCallback, NULL};
    SCNetworkReachabilitySetCallback(self.networkReachability, KDNetworkReachabilityCallback, &context);
    SCNetworkReachabilityScheduleWithRunLoop(self.networkReachability, CFRunLoopGetMain(), kCFRunLoopCommonModes);
    
    switch (self.networkReachabilityAssociation) {
        case KDNetworkReachabilityForName:
            break;
        case KDNetworkReachabilityForAddress:
        case KDNetworkReachabilityForAddressPair:
        default: {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0),^{
                SCNetworkReachabilityFlags flags;
                SCNetworkReachabilityGetFlags(self.networkReachability, &flags);
                KDNetworkReachabilityStatus status = KDNetworkReachabilityStatusForFlags(flags);
                dispatch_async(dispatch_get_main_queue(), ^{
                    callback(status);
                    
                    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
                    [notificationCenter postNotificationName:KDNetworkingReachabilityDidChangeNotification object:nil userInfo:@{ KDNetworkingReachabilityNotificationStatusItem: @(status) }];
                    
                    
                });
            });
        }
            break;
    }
}

- (void)stopMonitoring {
    if (!self.networkReachability) {
        return;
    }
    
    SCNetworkReachabilityUnscheduleFromRunLoop(self.networkReachability, CFRunLoopGetMain(), kCFRunLoopCommonModes);
}

#pragma mark -

- (NSString *)localizedNetworkReachabilityStatusString {
    return KDStringFromNetworkReachabilityStatus(self.networkReachabilityStatus);
}

#pragma mark -

- (void)setReachabilityStatusChangeBlock:(void (^)(KDNetworkReachabilityStatus status))block {
    self.networkReachabilityStatusBlock = block;
}

#pragma mark - NSKeyValueObserving

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
    if ([key isEqualToString:@"reachable"] || [key isEqualToString:@"reachableViaWWAN"] || [key isEqualToString:@"reachableViaWiFi"]) {
        return [NSSet setWithObject:@"networkReachabilityStatus"];
    }
    
    return [super keyPathsForValuesAffectingValueForKey:key];
}

@end
