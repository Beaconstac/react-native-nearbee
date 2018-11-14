/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 * @flow
 */

import React, {Component} from 'react';
import {Platform, StyleSheet, Text, View} from 'react-native';
import NearBeeModule from './nearbee_sdk/NearBee';

const instructions = Platform.select({
  ios: 'Press Cmd+R to reload,\n' + 'Cmd+D or shake for dev menu',
  android:
    'Double tap R on your keyboard to reload,\n' +
    'Shake or press menu button for dev menu',
});

//type Props = {};
export default class App extends Component {
  constructor(props) {
    super(props);
    this.state = { isLoaded: false};
  }
  async componentDidMount() {
    try {
      const isLoaded = await NearBeeModule.shared("08ddda7aabcbecfa54b29f6d032d7d289eb241b5", 1697)
      NearBeeModule.ignoreCacheOnce();
      NearBeeModule.startScanning();
      this.setState({isLoaded});
    } catch (ex) {
      console.log('Error = ', ex);
    }
  }
  render() {
    const {isLoaded} = this.state;
    return (
      isLoaded ? 
      <View style={styles.container}>
        <Text style={styles.welcome}>Welcome to React Native!</Text>
      </View>
      :
      <View style={styles.container}>
        <Text style={styles.welcome}>Welcome to React Native!</Text>
        <Text style={styles.instructions}>To get started, edit App.js</Text>
        <Text style={styles.instructions}>{instructions}</Text>
      </View>
    );
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#F5FCFF',
  },
  welcome: {
    fontSize: 20,
    textAlign: 'center',
    margin: 10,
  },
  instructions: {
    textAlign: 'center',
    color: '#333333',
    marginBottom: 5,
  },
});
