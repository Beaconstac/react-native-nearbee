
#if __has_include("RCTBridgeModule.h")
#import "RCTBridgeModule.h"
#else
#import <React/RCTBridgeModule.h>
#endif

#import <React/RCTEventEmitter.h>
#import <UserNotifications/UserNotifications.h>

@interface RNNearBee : RCTEventEmitter <RCTBridgeModule>

+ (BOOL)checkAndProcessNearbyNotification:(UNNotification *)notification;

@end


