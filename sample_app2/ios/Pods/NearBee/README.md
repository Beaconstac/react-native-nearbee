# NearBee SDK for iOS

## Introduction

NearBee SDK is an easy way to enable proximity marketing through an Eddystone-compliant BLE network.

## Installation
##### Using Cocoapods (recommended):
Add the following to your Podfile in your project, we are supporting iOS 10.0+ make sure your pod has proper platform set.

```pod
platform :ios, '10.0'
target '<My-App-Target>''
  pod 'NearBee'
end
```

Run `pod install` in the project directory


#### Manually:

1. Download or clone this repo on your system.
2. Drag and drop the NearBee.framework file into your Xcode project. Make sure that "Copy Items to Destination's Group Folder" is checked.
3. Add the `NearBee.framework`m `EddystoneScanner.framework` and `Socket.IO-Client-Swift.framework` to the embedded binaries section of your destination app target.

4. In Build Phases under destination app target, add the following frameworks in Link Binary With Libraries section:
- CoreData.framework
- SystemConfiguration.framework
- CoreBluetooth.framework
- CoreLocation.framework
- EddystoneScanner.framework
- NearBee.framework
- Socket.IO-Client-Swift.framework

## Configure your project

1. In Info.plist, add a new fields, `NSLocationAlwaysUsageDescription`, `NSLocationAlwaysAndWhenInUsageDescription`, `NSBluetoothPeripheralUsageDescription` with relevant values that you want to show to the user. This is mandatory for iOS 10 and above.

## Pre-requisite

__Location__

The app should take care of handling the permissions as required by your set up to receive notifications on entring the beacon region.

__Bluetooth__

The app should take care of enabling the bluetooth to range beacons.

__MY_DEVELOPER_TOKEN__

The app should provide the developer token while initializing the SDK. Get it from [Beaconstac Dashboard Account Page](https://dashboard.beaconstac.com/#/account).

__MY_ORGANIZATION__

The app should provide the organization while initializing the SDK. Get it from [Beaconstac Dashboard Account Page](https://dashboard.beaconstac.com/#/account).

__Monitoring Regions__

If you are using the region monitoring API's from advanced location manager, make sure it won't affect the NearBee SDK.

## Set Up

1. In the app's `Info.plist` add the below mentioned keys and the values

```xml
    <key>co.nearbee.api_key</key>
    <string>__MY_DEVELOPER_TOKEN__</string>

    <key>co.nearbee.organization_id</key>
    <string>__MY_ORGANIZATION__</string>
```

2. Import the framework header in your class

```swift
import NearBee
```

```objective-c
import <NearBee/NearBee.h>
```

3. Initialize `NearBee` using __one-line initialization__, the initialization starts scanning for beacons immediately.

```swift
var nearBee = NearBee.initNearBee()
```

```objective-c
NearBee *nearBee = [NearBee initNearBee];
```

4. If you wish to control start and stop of scanning for beacons:

```swift
nearBee.startScanning() // Starts scanning for beacons...
nearBee.stopScanning() // Stops scanning for beacons...
```

```objective-c
[nearBee startScanning];
[nearBee stopScanning];
```

5. Implement `NearBeeDelegate` protocol methods to show the beacons either in `UITableView` or `UICollectionView`

```swift
func onBeaconsFound(_ beacons: [NearBeeBeacon]) {
    // Display Beacons
}
    
func onBeaconsUpdated(_ beacons: [NearBeeBeacon]) {
    // Display Beacons
}
    
func onBeaconsLost(_ beacons: [NearBeeBeacon]) {
    // Display Beacons
}
    
func onError(_ error: Error) {
    // Show Error
}
```

```objective-c
- (void)onBeaconsUpdated:(NSArray<NearBeeBeacon *> * _Nonnull)beacons {
    // Display Beacons
}

- (void)onBeaconsLost:(NSArray<NearBeeBeacon *> * _Nonnull)beacons {
    // Display Beacons
}

- (void)onBeaconsFound:(NSArray<NearBeeBeacon *> * _Nonnull)beacons {
    // Display Beacons
}

- (void)onError:(NSError * _Nonnull)error {
    // Error
}
```

6. Once user clicks on the notification, pass it to the NearBee SDK to display the notificaiton

```swift

// In the class where you want to listen to notification events...
let nearBeeInstance = try! NearBee.sharedInstance()
func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {

    let isNearBeeNotification = nearBee.checkAndProcessNearbyNotification(response.notification)
    if (isNearBeeNotification) {
        completionHandler()
    } else {
        // Not a near bee notification, you need to handle
    }
}

```

```objective-c

// In the class where you want to listen to notification events...
NSError *error = nil;
NearBee *nearBeeInstance = [NearBee sharedInstanceAndReturnError:&error];

- (void)userNotificationCenter:(UNUserNotificationCenter *)center 
didReceiveNotificationResponse:(UNNotificationResponse *)response 
withCompletionHandler:(void (^)(void))completionHandler {
    
    BOOL isNearBeeNotification = [nearBee checkAndProcessNearbyNotification: response.notification];
    if (isNearBeeNotification) {
        completionHandler()
    } else {
        // Not a near bee notification, you need to handle
    }
}
```
