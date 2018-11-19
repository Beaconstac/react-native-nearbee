/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 * @flow
 */

import React, {Component} from 'react';
import {Button, FlatList, NativeEventEmitter, StyleSheet, View, Text, Image} from 'react-native';
import {ListItem, Icon} from 'react-native-elements'
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
        let beacons = [];
        let beacJson = JSON.parse(event.nearBeeNotifications);
        for (let index = 0; index < beacJson.nearBeeNotifications.length; index++) {
            const element = beacJson.nearBeeNotifications[index];
            element['key'] = element.url;
            beacons.push(element);
        }
        this.setState({beacons});
        console.log(this.state.beacons);
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

    componentWillMount(){
        this.scanToggle();
    }

    render() {
        return (
            <View>
                <FlatList
                    data={this.state.beacons}
                    renderItem={({item}) =>
                        <ListItem
                            title={item.title}
                            subtitle={item.description}
                            hideChevron
                            leftIcon={<Image source={{uri: item.icon}}
                                           style={{ height: 60, width: 60 }} />}
                        />
                    }
                />
            </View>
        );
    }
}

const list = [
    {
        name: 'Amy Farha',
        subtitle: 'Vice President'
    },
    {
        name: 'Chris Jackson',
        avatar_url: 'https://s3.amazonaws.com/uifaces/faces/twitter/adhamdannaway/128.jpg',
        subtitle: 'Vice Chairman'
    },
];

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
