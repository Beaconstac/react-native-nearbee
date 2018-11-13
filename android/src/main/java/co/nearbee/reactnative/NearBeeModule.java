package co.nearbee.reactnative;

import android.util.Log;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;

import co.nearbee.NearBee;

public class NearBeeModule extends ReactContextBaseJavaModule {

    private static final String NAME_BOI = "NEARBEE_SDK";

    public NearBeeModule(ReactApplicationContext reactContext) {
        super(reactContext);
    }

    @Override
    public String getName() {
        return "NearBeeModule";
    }

    @ReactMethod
    public void initialize() {
        Log.d("Nearbee", "Init");
         new NearBee.Builder(getReactApplicationContext())
                 .setBackgroundNotificationsEnabled(true)
                 .build();
    }

}
