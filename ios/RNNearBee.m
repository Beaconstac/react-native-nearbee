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
    [RNNearBee.nearBee enableBackgroundNotification:YES];
}

RCT_EXPORT_METHOD(enableBackgroundNotifications:(BOOL)enabled) {
    [RNNearBee.nearBee enableBackgroundNotification:enabled];
}

RCT_EXPORT_METHOD(stopScanning) {
//     NSLog(@"stop nearbee scanning");
    self.beacons = [@[] mutableCopy];
    [RNNearBee.nearBee stopScanning];
}

RCT_EXPORT_METHOD(startScanning) {
//     NSLog(@"start nearbee scanning");
    [RNNearBee.nearBee startScanning];
}

RCT_EXPORT_METHOD(enableDebugMode:(BOOL)enabled) {
    RNNearBee.nearBee.debugMode = enabled;
}

RCT_EXPORT_METHOD(clearNotificationCache) {
    [RNNearBee.nearBee clearNotificationCache];
}

RCT_EXPORT_METHOD(launchUrl:(NSString *)url) {
    [RNNearBee.nearBee displayUrl:url];
}

RCT_EXPORT_METHOD(startGeoFenceMonitoring) {
    [RNNearBee.nearBee startMonitoringGeoFenceRegions];
}

RCT_EXPORT_METHOD(stopGeoFenceMonitoring) {
    [RNNearBee.nearBee stopMonitoringGeoFenceRegions];
}

- (void)didEnterGeofence:(NearBeeGeoFence *)geofence :(GeoFenceAttachment *)attachment {
//     NSLog(@"entered geofence region");
}


- (void)didFindBeacons:(NSArray<NearBeeBeacon *> * _Nonnull)beacons {

//     NSLog(@"RNNearBee || found beacon(s) :: %lu", beacons.count);
    [self.beacons addObjectsFromArray:beacons];
    [self updateList:self.beacons];
}

- (void)didLoseBeacons:(NSArray<NearBeeBeacon *> * _Nonnull)beacons {

//     NSLog(@"RNNearBee || lost beacon(s) :: %lu", beacons.count);
    [self.beacons removeObjectsInArray:beacons];
    [self updateList:self.beacons];
}

- (void)didUpdateBeacons:(NSArray<NearBeeBeacon *> *)beacons {

//     NSLog(@"RNNearBee || update beacon(s) :: %lu", beacons.count);
    for (NearBeeBeacon *beacon in beacons) {
        NSUInteger index = [self.beacons indexOfObject:beacon];
        if (index == NSNotFound) {
            [self.beacons addObject:beacon];
        } else {
            [self.beacons replaceObjectAtIndex:index withObject:beacon];
        }
    }
    [self updateList:self.beacons];
}

- (void)didThrowError:(NSError * _Nonnull)error {
//     NSDictionary *json = @{@"nearBeeError":error};
//     NSData *jsonData = [NSJSONSerialization dataWithJSONObject:json
//                                                        options:NSJSONWritingPrettyPrinted
//                                                          error:&error];
//     NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//     NSDictionary *mappedData = @{@"nearBeeError": jsonString};
//     [self sendEventWithName:@"nearBeeError" body:mappedData];
    NSLog(@"NearBee didThrowError")
}

- (void)didUpdateState:(enum NearBeeState)state {
    // Show the state on view
}

- (void)updateList:(NSArray<NearBeeBeacon *> * _Nonnull)beacons {
    NSMutableArray *jsonArray = [NSMutableArray new];
    for (NearBeeBeacon *beacon in beacons) {
        NSMutableDictionary *beaconJson = [NSMutableDictionary new];
        NSSet *attachments = beacon.attachment.proximityAttachment;
        if (attachments && attachments.count > 0) {
            for (NearBeeProximityAttachment *attachment in attachments) {
                if ([attachment.language isEqualToString:NSLocale.currentLocale.languageCode] && attachment.getURL != nil) {
                    beaconJson[@"title"] = attachment.getTitle;
                    beaconJson[@"description"] = attachment.getDescription;
                    beaconJson[@"icon"] = attachment.getIconURL;
                    beaconJson[@"url"] = attachment.getURL;
                    beaconJson[@"bannerType"] = @(attachment.bannerType);
                    beaconJson[@"bannerImageUrl"] = attachment.bannerImageURL;
                    break;
                }
            }
        }
        if (beaconJson.count == 0 && beacon.attachment.physicalWeb != nil) {
            beaconJson[@"title"] = beacon.attachment.physicalWeb.getTitle;
            beaconJson[@"description"] = beacon.attachment.physicalWeb.getDescription;
            beaconJson[@"icon"] = beacon.attachment.physicalWeb.getIconURL;
            beaconJson[@"url"] = beacon.attachment.physicalWeb.getURL;
        }
        beaconJson[@"eddystoneUID"] = beacon.eddystoneUID;
        [jsonArray addObject:beaconJson];
    }
    if (jsonArray.count >= 0) {
//         NSLog(@"RNNearBee || Number of beacons :: %lu", jsonArray.count);
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

+ (BOOL)checkAndProcessNearbyNotification:(UNNotification *)notification {
    return [RNNearBee.nearBee checkAndProcessNearbyNotification:notification queryParameters:nil];
}

@end
