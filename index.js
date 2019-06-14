
import {NativeModules} from 'react-native';

const { NearBee } = NativeModules;

export default NearBee;

// Create bundle manually for android
// react-native bundle --platform android --dev false --entry-file index.js --bundle-output android/app/src/main/assets/index.android.bundle --assets-dest android/app/src/main/res
