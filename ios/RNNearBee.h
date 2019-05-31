
#import <React/RCTEventEmitter.h>
#import <UserNotifications/UserNotifications.h>

@interface RNNearBee : RCTEventEmitter <RCTBridgeModule>

+ (BOOL)checkAndProcessNearbyNotification:(UNNotification *)notification;

@end


