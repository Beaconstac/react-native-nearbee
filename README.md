
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
    let bannerType = notification1.bannerType;
    let bannerImageUrl = notification1.bannerImageUrl;
    let eddystoneUID = notification1.eddystoneUID;
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


### Overriding notification on-click behaviour

#### Android

##### 1. Go to `your_app_dir/android/app/build.gradle` and add this dependancy
```gradle
implementation 'co.nearbee:nearbeesdk:0.1.10'
```

##### 2. Create a java file in your `your_app_dir/android/app/src/main/java/com/your_app` 

```java
package com.your_app_package;

import android.content.Context;
import android.content.Intent;

import co.nearbee.NotificationManager;
import co.nearbee.models.BeaconAttachment;
import co.nearbee.models.NearBeacon;


public class MyNotificationManager extends NotificationManager {

    public MyNotificationManager(Context context) {
        super(context);
    }

    @Override
    public Intent getAppIntent(Context context) {
        // This intent is for handling grouped notification click
        return new Intent(context, MainActivity.class);
    }

    @Override
    public Intent getBeaconIntent(Context context, NearBeacon nearBeacon) {
        // This intent is for handling individual notification click
        // Pass the intent of the activity that you want to be opened on click
        if (nearBeacon.getBusiness() != null) {
            BeaconAttachment attachment = nearBeacon.getBestAvailableAttachment(context);
            if (attachment != null) {
                final Intent intent = new Intent(context, MainActivity.class);
                // pass the url from the beacon, so that it can be opened from your activity
                intent.putExtra("url", attachment.getUrl());
                return intent;
            }
        }
        return null;
    }

}

```

##### 3. Add this metadata to your `AndroidManifest.xml`

```xml
<meta-data
    android:name="co.nearbee.notification_util"
    android:value=".MyNotificationManager" />
```

##### 4. Override `onCreate` inside your activity

```java
public class MainActivity extends ReactActivity {

    @Override
    protected String getMainComponentName() {
        return "your_app";
    }

    // Use this to get the data passed from intent
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        if (getIntent().getStringExtra("url") != null) {
            String url = getIntent().getStringExtra("url");
            // Do something with the url here
            Util.startChromeTabs(this, url, true);
        }
    }
}
```
