//
//  KDNetworkReachableManager.h
//  KuaiDianPlan
//
//  Created by ppnd on 16/6/11.
//  Copyright © 2016年 zy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>

#import <netinet/in.h>
#import <netinet6/in6.h>
#import <arpa/inet.h>
#import <ifaddrs.h>
#import <netdb.h>

typedef NS_ENUM(NSInteger, KDNetworkReachabilityStatus) {
    KDNetworkReachabilityStatusUnknown          = -1,
    KDNetworkReachabilityStatusNotReachable     = 0,
    KDNetworkReachabilityStatusReachableViaWWAN2G = 1,
    KDNetworkReachabilityStatusReachableViaWWAN3G = 2,
    KDNetworkReachabilityStatusReachableViaWiFi = 3,
};


@interface KDNetworkReachableManager : NSObject

/**
 The current network reachability status.
 */
@property (readonly, nonatomic, assign) KDNetworkReachabilityStatus networkReachabilityStatus;

/**
 Whether or not the network is currently reachable.
 */
@property (readonly, nonatomic, assign, getter = isReachable) BOOL reachable;

/**
 Whether or not the network is currently reachable via WWAN.
 */
@property (readonly, nonatomic, assign, getter = isReachableViaWWAN2G) BOOL reachableViaWWAN2G;

@property (readonly, nonatomic, assign, getter = isReachableViaWWAN3G) BOOL reachableViaWWAN3G;

/**
 Whether or not the network is currently reachable via WiFi.
 */
@property (readonly, nonatomic, assign, getter = isReachableViaWiFi) BOOL reachableViaWiFi;

///---------------------
/// @name Initialization
///---------------------

/**
 Returns the shared network reachability manager.
 */
+ (instancetype)sharedManager;

/**
 Creates and returns a network reachability manager for the specified domain.
 
 @param domain The domain used to evaluate network reachability.
 
 @return An initialized network reachability manager, actively monitoring the specified domain.
 */
+ (instancetype)managerForDomain:(NSString *)domain;

/**
 Creates and returns a network reachability manager for the socket address.
 
 @param address The socket address used to evaluate network reachability.
 
 @return An initialized network reachability manager, actively monitoring the specified socket address.
 */
+ (instancetype)managerForAddress:(const struct sockaddr_in *)address;

/**
 Initializes an instance of a network reachability manager from the specified reachability object.
 
 @param reachability The reachability object to monitor.
 
 @return An initialized network reachability manager, actively monitoring the specified reachability.
 */
- (instancetype)initWithReachability:(SCNetworkReachabilityRef)reachability;

///--------------------------------------------------
/// @name Starting & Stopping Reachability Monitoring
///--------------------------------------------------

/**
 Starts monitoring for changes in network reachability status.
 */
- (void)startMonitoring;

/**
 Stops monitoring for changes in network reachability status.
 */
- (void)stopMonitoring;

///-------------------------------------------------
/// @name Getting Localized Reachability Description
///-------------------------------------------------

/**
 Returns a localized string representation of the current network reachability status.
 */
- (NSString *)localizedNetworkReachabilityStatusString;

///---------------------------------------------------
/// @name Setting Network Reachability Change Callback
///---------------------------------------------------

/**
 Sets a callback to be executed when the network availability of the `baseURL` host changes.
 
 @param block A block object to be executed when the network availability of the `baseURL` host changes.. This block has no return value and takes a single argument which represents the various reachability states from the device to the `baseURL`.
 */
- (void)setReachabilityStatusChangeBlock:(void (^)(KDNetworkReachabilityStatus status))block;

@end

extern NSString * const KDNetworkingReachabilityDidChangeNotification;
extern NSString * const KDNetworkingReachabilityNotificationStatusItem;

///--------------------
/// @name Functions
///--------------------

/**
 Returns a localized string representation of an `KDNetworkReachabilityStatus` value.
 */
extern NSString * KDStringFromNetworkReachabilityStatus(KDNetworkReachabilityStatus status);


