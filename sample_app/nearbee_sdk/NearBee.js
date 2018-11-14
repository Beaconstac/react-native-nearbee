
import {NativeModules} from 'react-native';

console.log('Native modules: ' + Object.getOwnPropertyNames(NativeModules));

module.exports = NativeModules.RNNearBee;
