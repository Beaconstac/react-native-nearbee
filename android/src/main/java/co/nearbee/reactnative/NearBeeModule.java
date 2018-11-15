package co.nearbee.reactnative;

import android.util.Log;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.modules.core.DeviceEventManagerModule;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;

import co.nearbee.NearBee;
import co.nearbee.NearBeeBeacon;
import co.nearbee.NearBeeException;
import co.nearbee.NearBeeListener;

public class NearBeeModule extends ReactContextBaseJavaModule implements NearBeeListener {

    public static final String EVENT_NOTIFICATION = "notifications";

    private NearBee nearBee;

    public NearBeeModule(ReactApplicationContext reactContext) {
        super(reactContext);
    }

    @Override
    public String getName() {
        return "NearBeeModule";
    }

    @ReactMethod
    public void initialize() {
        if (nearBee == null) {
            nearBee = new NearBee.Builder(getReactApplicationContext())
                    .setBackgroundNotificationsEnabled(false)
                    .build();
            Log.d("RNNearbee", "Init");
        }
    }


    @ReactMethod
    public void enableBackgroundNotifications(boolean enabled) {
        initialize();
        nearBee.enableBackgroundNotifications(enabled);
        Log.d("RNNearbee", "background notifications: " + String.valueOf(enabled));
    }

    @ReactMethod
    public void stopScanning() {
        initialize();
        nearBee.stopScanning();
        Log.d("RNNearbee", "Stopped scanning");
    }

    @ReactMethod
    public void startScanning() {
        initialize();
        nearBee.startScanning(this);
        Log.d("RNNearbee", "Started scanning");
    }

    @Override
    public void onUpdate(ArrayList<NearBeeBeacon> beaconsInRange) {
        JSONArray jsonArray = new JSONArray();
        try {
            for (NearBeeBeacon beacon : beaconsInRange) {
                JSONObject beaconJson = new JSONObject();
                beaconJson.put("title", beacon.getNotification().getTitle());
                beaconJson.put("description", beacon.getNotification().getDescription());
                beaconJson.put("icon", beacon.getNotification().getIcon());
                beaconJson.put("url", beacon.getNotification().getEddystoneURL());
                jsonArray.put(beaconJson);
            }
            JSONObject jsonObject = new JSONObject();
            jsonObject.put("notifications", jsonArray);
            WritableMap data = Arguments.createMap();
            data.putString("notifications", jsonObject.toString());
            sendEvent(data);
        } catch (JSONException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void onBeaconLost(ArrayList<NearBeeBeacon> lost) {

    }

    @Override
    public void onBeaconFound(ArrayList<NearBeeBeacon> found) {
        Log.d("RNNearbee", "Found " + found.size() + " beacons");

    }

    @Override
    public void onError(NearBeeException exception) {
        Log.e("RNNearbee", "Error: " + exception.getMessage());
    }

    private void sendEvent(WritableMap params) {
        getReactApplicationContext().getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                .emit(EVENT_NOTIFICATION, params);
    }

}
