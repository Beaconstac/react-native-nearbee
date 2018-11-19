
# NearBee React Native SDK

## Add to your react native project

```bash
# Install from npm
npm install react-native-nearbee --save
```

```bash
# Link to your app
react-native link
```

### Pre-requisites

#### Android

Add your API key and Orgnization ID to the `AndroidManifest.xml` as follows

```xml
<application>
…
…
    <meta-data
        android:name="co.nearbee.api_key"
        android:value="MY_DEV_TOKEN" />

    <meta-data
        android:name="co.nearbee.organization_id"
        android:value="123" />
…
…
</application>
```

#### iOS

Add your API key and Orgnization ID to the `Info.plist` as follows

```xml
<key>co.nearbee.api_key</key>
<string>MY_DEV_TOKEN<string>
<key>co.nearbee.organization_id</key>
<string>123</string>
``` 

Add the NSLocationAlwaysUsageDescription, NSLocationAlwaysAndWhenInUsageDescription, NSBluetoothPeripheralUsageDescription to `Info.plist`

```xml
<key>NSLocationAlwaysUsageDescription</key>
<string>To scan for beacons and show the offers around you</string>
<key>NSLocationAlwaysUsageDescription</key>
<string>To scan for beacons and show the offers around you</string>
<key>NSLocationAlwaysUsageDescription</key>
<string>To scan for beacons and show the offers around you</string>
```

To recieve notifications in the background, you must first enable the `Location Updates` and `Uses Bluetooth LE accessories` Background Modes in the Capabilities tab of your app target

#### Pods
1. If you are using Pods you need to run the `pod install`.

#### Manual Installation
1. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
2. Go to `node_modules` ➜ `react-native-nearbee` and add `RNNearbee.xcodeproj`
3. In XCode, in the project navigator, select your project. Add `libRNNearbee.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
4. Run your project (`Cmd+R`)


## Usage

#### 1. Import module

```javascript
import {NativeModules} from 'react-native';

const NearBee = NativeModules.NearBee;
```

#### 2. Initialize SDK

```javascript
NearBee.initialize();
```

#### 3. Change background notification state
If set to `true` the NearBee sdk will send beacon notifications in the background, when the app is not running.
```javascript
NearBee.enableBackgroundNotifications(true);
```

#### 4. Displaying a UI with list of beacons

To display a UI with list of beacons, the following needs to be done:

###### Add listener for updates from NearBee SDK
```javascript
import {NativeEventEmitter} from 'react-native';
const eventEmitter = new NativeEventEmitter(NearBee);

// Beacon notification event
eventEmitter.addListener('nearBeeNotifications', this.onBeaconsFound);
// Error event
eventEmitter.addListener('nearBeeError', this.onError);
```

###### Start scanning

This will start the scan and start sending update events
```javascript
NearBee.startScanning();
```

###### Accessing beacon notification data
To extract the notification beacon data from the listener-
```javascript
onBeaconsFound = (event) => {
    let json = JSON.parse(event.nearBeeNotifications);
    // Get the first beacon notification
    let notification1 = json.nearBeeNotifications[0];
    // Extract notification data
    let title = notification1.title;
    let description = notification1.description;
    let icon = notification1.icon;
    let url = notification1.url;
};
```
###### Stop scanning

When there is no need to update the UI (like when the app goes to background), scanning should be stopped as it is a battery intensive process.

```javascript
NearBee.stopScanning();
```

#### 4. Clear notification cache

This will clear the cached server responses and will force NearBee to fetch fresh data from the server.

```javascript
NearBee.clearNotificationCache();
```
