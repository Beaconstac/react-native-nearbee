#import "AppDelegate.h"
@import SafariServices;

#import <UserNotifications/UserNotifications.h>

#import <React/RCTBridge.h>
#import <React/RCTBundleURLProvider.h>
#import <React/RCTRootView.h>
#import <RNNearBee/RNNearBee.h>

@interface AppDelegate() <UNUserNotificationCenterDelegate>

@end

#ifdef FB_SONARKIT_ENABLED
#import <FlipperKit/FlipperClient.h>
#import <FlipperKitLayoutPlugin/FlipperKitLayoutPlugin.h>
#import <FlipperKitUserDefaultsPlugin/FKUserDefaultsPlugin.h>
#import <FlipperKitNetworkPlugin/FlipperKitNetworkPlugin.h>
#import <SKIOSNetworkPlugin/SKIOSNetworkAdapter.h>
#import <FlipperKitReactPlugin/FlipperKitReactPlugin.h>
static void InitializeFlipper(UIApplication *application) {
  FlipperClient *client = [FlipperClient sharedClient];
  SKDescriptorMapper *layoutDescriptorMapper = [[SKDescriptorMapper alloc] initWithDefaults];
  [client addPlugin:[[FlipperKitLayoutPlugin alloc] initWithRootNode:application withDescriptorMapper:layoutDescriptorMapper]];
  [client addPlugin:[[FKUserDefaultsPlugin alloc] initWithSuiteName:nil]];
  [client addPlugin:[FlipperKitReactPlugin new]];
  [client addPlugin:[[FlipperKitNetworkPlugin alloc] initWithNetworkAdapter:[SKIOSNetworkAdapter new]]];
  [client start];
}
#endif

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  #ifdef FB_SONARKIT_ENABLED
    InitializeFlipper(application);
  #endif
  [UNUserNotificationCenter currentNotificationCenter].delegate = self;
  
  RCTBridge *bridge = [[RCTBridge alloc] initWithDelegate:self launchOptions:launchOptions];
  RCTRootView *rootView = [[RCTRootView alloc] initWithBridge:bridge
                                                   moduleName:@"sample_app"
                                            initialProperties:nil];

  rootView.backgroundColor = [[UIColor alloc] initWithRed:1.0f green:1.0f blue:1.0f alpha:1];

  self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
  UIViewController *rootViewController = [UIViewController new];
  rootViewController.view = rootView;
  self.window.rootViewController = rootViewController;
  [self.window makeKeyAndVisible];
  
  [self registerForNotifications];
  
  return YES;
}

- (void)registerForNotifications {
  UNNotificationCategory *localCategory = [UNNotificationCategory categoryWithIdentifier:@"nearbyNotificationView" actions:@[] intentIdentifiers:@[] options:UNNotificationCategoryOptionNone];
  UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
  [center setNotificationCategories:[NSSet setWithObjects:localCategory, nil]];
  [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert + UNAuthorizationOptionSound)
                        completionHandler:^(BOOL granted, NSError * _Nullable error) {
                          // Enable or disable features based on authorization.
                        }];
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler
{
  NSString *url = nil;
  
  if (response.notification.request.content.userInfo[@"EddystoneURL"] != nil) {
    url = response.notification.request.content.userInfo[@"EddystoneURL"];
  } else if (response.notification.request.content.userInfo[@"GeoFenceURL"] != nil) {
    url = response.notification.request.content.userInfo[@"GeoFenceURL"];
  }
  
  if (url != nil) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{

      UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;

      while (topController.presentedViewController) {
          topController = topController.presentedViewController;
      }

      NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:url]];
      SFSafariViewController *sfvc = [[SFSafariViewController alloc] initWithURL:URL];

      [topController presentViewController:sfvc animated:YES completion:nil];
    });
  } else {
    NSLog(@"NearBee: url not found");
  }
  
//  BOOL isNearBeeNotificaiton = [RNNearBee checkAndProcessNearbyNotification:response.notification];
//  if (!isNearBeeNotificaiton) {
//    // You should handle the notification
//  }
//  completionHandler();
}

- (NSURL *)sourceURLForBridge:(RCTBridge *)bridge
{
#if DEBUG
  return [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:@"index" fallbackResource:nil];
#else
  return [[NSBundle mainBundle] URLForResource:@"main" withExtension:@"jsbundle"];
#endif
}

@end
