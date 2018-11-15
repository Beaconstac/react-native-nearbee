/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 * @flow
 */

import React, {Component} from 'react';
import {Platform, StyleSheet, Text, View, Button, DeviceEventEmitter} from 'react-native';
import NearBee from './nearbee_sdk/NearBee';

const instructions = Platform.select({
  ios: 'Press Cmd+R to reload,\n' + 'Cmd+D or shake for dev menu',
  android:
    'Double tap R on your keyboard to reload,\n' +
    'Shake or press menu button for dev menu',
});

export default class App extends Component {

  constructor() {
    super();
    NearBee.initialize();
    this.bgEnabled = false;
    this.scanning = false;

    this.state = {
        bgButtonText:"Enable BG notification",
        scanText:"Start scanning",
        beacons:"No beacons in range"
    }

    DeviceEventEmitter.addListener('notifications', this.onBeaconsFound);
  }

  onBackgroundChange = () => {
      if (this.bgEnabled === true) {
        this.setState({
          bgButtonText: "Enable BG notification",
        })
      } else {
        this.setState({
          bgButtonText: "Disable BG notification",
        })
      }
      this.bgEnabled = !this.bgEnabled;
      NearBee.enableBackgroundNotifications(this.bgEnabled);
  }

  onBeaconsFound = (event) => {
    let beacJson = JSON.parse(event.notifications);
    let beaconsString = "";
    for (let index = 0; index < beacJson.notifications.length; index++) {
      const element = beacJson.notifications[index];
      let beac = element.title + '\n' + element.description + '\n' + element.url + '\n\n';
      beaconsString = beaconsString + beac;
    }
    this.setState({
      beacons: beaconsString,
    });

  }

  scanToggle = () => {
    if (this.scanning === true) {
      this.setState({
        scanText: "Start scanning",
      })
      NearBee.stopScanning();
    } else {
      this.setState({
        scanText: "Stop scanning",
      })
      NearBee.startScanning();
    }
    this.scanning = !this.scanning;
  }

  render() {
    return (
      <View style={styles.container}>
        <Text style={styles.welcome}>NearBee</Text>
        <Text style={styles.instructions}>{this.state.beacons}</Text>

        <Button style={styles.buttonNB}
          onPress={() => {
            this.onBackgroundChange();
          }}
          color="#374668"
          title={this.state.bgButtonText}
        />

        <Button buttonStyle={styles.buttonNB}
          onPress={() => {
            this.scanToggle();
          }}
          color="#374668"
          title={this.state.scanText}
        />

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
    margin: 20,
  },
  instructions: {
    textAlign: 'center',
    color: '#333333',
    marginBottom: 5,
  },
});
