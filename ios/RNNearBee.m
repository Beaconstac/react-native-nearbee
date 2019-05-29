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

RCT_EXPORT_METHOD(launchUrl:(NSString *)url) {
    [RNNearBee.nearBee displayContentOfEddystoneUrl:url];
}

- (void)didFindBeacons:(NSArray<NearBeeBeacon *> * _Nonnull)beacons {
    [self.beacons addObjectsFromArray:beacons];
    [self updateList:self.beacons];
}

- (void)didLoseBeacons:(NSArray<NearBeeBeacon *> * _Nonnull)beacons {
    [self.beacons removeObjectsInArray:beacons];
    [self updateList:self.beacons];
}

- (void)didUpdateBeacons:(NSArray<NearBeeBeacon *> *)beacons {
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
    NSDictionary *json = @{@"nearBeeError":error};
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:json
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSDictionary *mappedData = @{@"nearBeeError": jsonString};
    [self sendEventWithName:@"nearBeeError" body:mappedData];
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
                if ([attachment.language isEqualToString:NSLocale.currentLocale.languageCode] && attachment.url != nil) {
                    beaconJson[@"title"] = attachment.title;
                    beaconJson[@"description"] = attachment.body;
                    beaconJson[@"icon"] = attachment.iconURL;
                    beaconJson[@"url"] = attachment.url;
                    beaconJson[@"bannerType"] = @(attachment.bannerType);
                    beaconJson[@"bannerImageUrl"] = attachment.bannerImageURL;
                    break;
                }
            }
        }
        if (beaconJson.count == 0 && beacon.attachment.physicalWeb != nil) {
            beaconJson[@"title"] = beacon.attachment.physicalWeb.title;
            beaconJson[@"description"] = beacon.attachment.physicalWeb.body;
            beaconJson[@"icon"] = beacon.attachment.physicalWeb.iconURL;
            beaconJson[@"url"] = beacon.attachment.physicalWeb.finalURL;
        }
        beaconJson[@"eddystoneUID"] = beacon.eddystoneUID;
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

+ (BOOL)checkAndProcessNearbyNotification:(UNNotification *)notification {
    return [RNNearBee.nearBee checkAndProcessNearbyNotification:notification];
}

@end
