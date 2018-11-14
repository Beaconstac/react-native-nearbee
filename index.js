
import {NativeModules} from 'react-native';

console.log(NativeModules);

const { RNNearBee } = NativeModules;

export default RNNearBee;

// Create bundle manually for android
// react-native bundle --platform android --dev false --entry-file index.js --bundle-output android/app/src/main/assets/index.android.bundle --assets-dest android/app/src/main/res
