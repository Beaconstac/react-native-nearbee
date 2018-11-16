#import <NearBee/NearBee-Swift.h>
#import "RNNearBee.h"
#import <Foundation/Foundation.h>

@interface RNNearBee() <NearBeeDelegate>

@property (class) NearBee *nearBee;
@property (nonatomic, retain) NSMutableArray *beacons;

@end

@implementation RNNearBee

static NearBee * _nearBee;

+ (NearBee *)nearBee {
    return _nearBee;
}

+(void)setNearBee:(NearBee *)nearBee {
    _nearBee = nearBee;
}

RCT_EXPORT_MODULE(NearBee);

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

- (NSArray<NSString *> *)supportedEvents
{
    return @[@"nearBeeNotifications", @"nearBeeError"];
}

RCT_EXPORT_METHOD(initialize) {
    self.beacons = [@[] mutableCopy];
    RNNearBee.nearBee = [NearBee initNearBee];
    RNNearBee.nearBee.delegate = self;
    [RNNearBee.nearBee enableBackgroundNotification:NO];
}

RCT_EXPORT_METHOD(enableBackgroundNotifications:(BOOL)enabled) {
    [RNNearBee.nearBee enableBackgroundNotification:enabled];
}

RCT_EXPORT_METHOD(stopScanning) {
    self.beacons = [@[] mutableCopy];
    [RNNearBee.nearBee stopScanning];
}

RCT_EXPORT_METHOD(startScanning) {
    [RNNearBee.nearBee startScanning];
}

RCT_EXPORT_METHOD(clearNotificationCache) {
    [RNNearBee.nearBee clearNotificationCache];
}

- (void)onBeaconsFound:(NSArray<NearBeeBeacon *> * _Nonnull)beacons {
    [self.beacons addObjectsFromArray:beacons];
    [self updateList:self.beacons];
}

- (void)onBeaconsLost:(NSArray<NearBeeBeacon *> * _Nonnull)beacons {
    [self.beacons removeObjectsInArray:beacons];
    [self updateList:self.beacons];
}

- (void)onBeaconsUpdated:(NSArray<NearBeeBeacon *> * _Nonnull)beacons {
    [self updateList:self.beacons];
}

- (void)updateList:(NSArray<NearBeeBeacon *> * _Nonnull)beacons {
    NSMutableArray *jsonArray = [NSMutableArray new];
    for (NearBeeBeacon *beacon in beacons) {
        NSMutableDictionary *beaconJson = [NSMutableDictionary new];
        beaconJson[@"title"] = beacon.physicalWebTitle;
        beaconJson[@"description"] = beacon.physicalWebDescription;
        beaconJson[@"icon"] = beacon.physicalWebIcon;
        beaconJson[@"url"] = beacon.physicalWebEddystoneURL;
        [jsonArray addObject:beaconJson];
    }
    if (jsonArray.count > 0) {
        NSDictionary *json = @{@"nearBeeNotifications":jsonArray};
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:json
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:&error];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSDictionary *mappedData = @{@"nearBeeNotifications": jsonString};
        [self sendEventWithName:@"nearBeeNotifications" body:mappedData];
    }
}

- (void)onError:(NSError * _Nonnull)error {
    NSDictionary *json = @{@"nearBeeError":error};
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:json
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSDictionary *mappedData = @{@"nearBeeError": jsonString};
    [self sendEventWithName:@"nearBeeError" body:mappedData];
}

+ (BOOL)checkAndProcessNearbyNotification:(UNNotification *)notification {
    return [RNNearBee.nearBee checkAndProcessNearbyNotification:notification];
}

@end

