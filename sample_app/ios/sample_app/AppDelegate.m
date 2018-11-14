/**
 * Copyright (c) 2015-present, Facebook, Inc.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "AppDelegate.h"
#import <UserNotifications/UserNotifications.h>

#import <React/RCTBundleURLProvider.h>
#import <React/RCTRootView.h>
#import <NearBee/NearBee-Swift.h>

@interface AppDelegate() <UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  NSURL *jsCodeLocation;
  
  [UNUserNotificationCenter currentNotificationCenter].delegate = self;

  jsCodeLocation = [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:@"index" fallbackResource:nil];

  RCTRootView *rootView = [[RCTRootView alloc] initWithBundleURL:jsCodeLocation
                                                      moduleName:@"sample_app"
                                               initialProperties:nil
                                                   launchOptions:launchOptions];
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
  NSError *error = nil;
  BOOL isNearBeeNotificaiton = [[NearBee sharedAndReturnError:&error] checkAndProcessNearbyNotification:response.notification];
  if (!isNearBeeNotificaiton) {
    // You should handle the notification
  }
  completionHandler();
}

@end
