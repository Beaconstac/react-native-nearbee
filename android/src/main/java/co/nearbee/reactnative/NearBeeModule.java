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
import co.nearbee.models.NearBeacon;
import co.nearbee.models.ProximityAttachment;
import co.nearbee.models.BeaconAttachment;
import co.nearbee.NearBeeException;
import co.nearbee.NearBeaconListener;
import co.nearbee.utils.Util;

public class NearBeeModule extends ReactContextBaseJavaModule implements NearBeaconListener {

    public static final String EVENT_NOTIFICATION = "nearBeeNotifications";
    public static final String EVENT_ERROR = "nearBeeError";

    private NearBee nearBee;

    public NearBeeModule(ReactApplicationContext reactContext) {
        super(reactContext);
    }

    @Override
    public String getName() {
        return "NearBee";
    }

    @ReactMethod
    public void initialize() {
        if (nearBee == null) {
            nearBee = new NearBee.Builder(getReactApplicationContext())
                    .setBackgroundNotificationsEnabled(true)
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

    @ReactMethod
    public void clearNotificationCache() {
        initialize();
        nearBee.clearNotificationCache();
        Log.d("RNNearbee", "Cleared notification cache");
    }

    @ReactMethod
    public void launchUrl(String url) {
        initialize();
        Util.startChromeTabs(getCurrentActivity(), url, true);
        Log.d("RNNearbee", "Launching url");
    }

    @Override
    public void onUpdate(ArrayList<NearBeacon> beaconsInRange) {
        JSONArray jsonArray = new JSONArray();
        try {
            for (NearBeacon beacon : beaconsInRange) {
                JSONObject beaconJson = new JSONObject();
                BeaconAttachment attachment = beacon.getBestAvailableAttachment(getReactApplicationContext());
                beaconJson.put("eddystoneUID", beacon.getEddystoneUID());
                beaconJson.put("title", attachment.getTitle());
                beaconJson.put("description", attachment.getDescription());
                beaconJson.put("icon", attachment.getIconURL());
                beaconJson.put("url", attachment.getUrl());
                if (attachment.getClass().isAssignableFrom(ProximityAttachment.class)) {
                    ProximityAttachment pa = (ProximityAttachment) attachment;
                    beaconJson.put("bannerType", pa.getBannerType());
                    beaconJson.put("bannerImageUrl", pa.getBannerImageURL());
                } else {
                    beaconJson.put("bannerType", JSONObject.NULL);
                    beaconJson.put("bannerImageUrl", JSONObject.NULL);
                }
                jsonArray.put(beaconJson);
            }
            JSONObject jsonObject = new JSONObject();
            jsonObject.put(EVENT_NOTIFICATION, jsonArray);
            WritableMap data = Arguments.createMap();
            data.putString(EVENT_NOTIFICATION, jsonObject.toString());
            sendBeaconEvent(data);
        } catch (JSONException e) {
            Log.e("RNNearbee", "Error: " + e.getMessage());
        }
    }

    @Override
    public void onBeaconLost(ArrayList<NearBeacon> lost) {
        //
    }

    @Override
    public void onBeaconFound(ArrayList<NearBeacon> found) {
        //
    }

    @Override
    public void onError(NearBeeException exception) {
        Log.e("RNNearbee", "Error: " + exception.getMessage());
        WritableMap data = Arguments.createMap();
        data.putString(EVENT_ERROR, exception.getMessage());
        sendErrorEvent(data);
    }

    private void sendBeaconEvent(WritableMap params) {
        sendEvent(EVENT_NOTIFICATION, params);
    }

    private void sendErrorEvent(WritableMap params) {
        sendEvent(EVENT_ERROR, params);
    }

    private void sendEvent(String event, WritableMap params) {
        getReactApplicationContext().getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                .emit(event, params);
    }

}
