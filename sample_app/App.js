/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 * @flow
 */

import React, {Component} from 'react';
import {Platform, StyleSheet, Text, View, Button, NativeEventEmitter, FlatList} from 'react-native';
import NearBee from './nearbee_sdk/NearBee';

const eventBeacons = "nearBeeNotifications";
const eventError = "nearBeeError";

export default class App extends Component {
    constructor() {
        NearBee.initialize();
        super();
        this.bgEnabled = false;
        this.scanning = false;

        this.state = {
            bgButtonText: "Enable BG notification",
            scanText: "Start scanning",
            beaconString: "No beacons in range",
            beacons: [],
            loading: false,
        };

        const eventEmitter = new NativeEventEmitter(NearBee);
        eventEmitter.addListener(eventBeacons, this.onBeaconsFound);
        eventEmitter.addListener(eventError, this.onError);
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
    };

    onBeaconsFound = (event) => {
        let beacJson = JSON.parse(event.nearBeeNotifications);
        let beacons = [];
        for (let index = 0; index < beacJson.nearBeeNotifications.length; index++) {
            const element = beacJson.nearBeeNotifications[index];
            beacons.push(element);
        }
        this.setState({
            beaconString: "",
            beacons: beacJson.nearBeeNotifications
        });
    };

    onError = (event) => {
        let error = event.nearBeeError;
        console.error(error);
    };

    scanToggle = () => {
        if (this.scanning === true) {
            this.setState({
                scanText: "Start scanning",
            });
            NearBee.stopScanning();
        } else {
            this.setState({
                scanText: "Stop scanning",
            });
            NearBee.startScanning();
        }
        this.scanning = !this.scanning;
    };

    render() {
        return (
            // if (this.state.beacons.length > 0) {
                // <FlatList 
                //     keyExtractor={this._keyExtractor}
                //     data={this.state.beacons}
                //     renderItem={({ beacon }) => ( 
                //         <ListItem
                //             <View style={styles.itemBlock}>
                //                 <Image source={{uri: beacon.icon}} style={styles.itemImage}/>
                //                 <View style={styles.itemMeta}>
                //                     <Text style={styles.itemName}>{beacon.title}</Text>
                //                     <Text style={styles.itemLastMessage}>{beacon.description}</Text>
                //                     <Text style={styles.itemLastMessage}>{beacon.url}</Text>
                //                 </View>
                //             </View>              
                //         />          
                //     )}
                // />
            // } else {
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
            
            //}
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
    itemBlock: {
        flexDirection: 'row',
        paddingBottom: 5,
    },
    itemImage: {
        width: 50,
        height: 50,
        borderRadius: 25,
    },
    itemMeta: {
        marginLeft: 10,
        justifyContent: 'center',
    },
    itemName: {
        fontSize: 20,
    },
    itemLastMessage: {
        fontSize: 14,
        color: "#111",
    }
});
