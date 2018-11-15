
#import <NearBee/NearBee-Swift.h>
#import "RNNearBee.h"
#import <Foundation/Foundation.h>

@implementation RNNearbee

RCT_EXPORT_MODULE(RNNearBee);

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

- (NSArray<NSString *> *)supportedEvents
{
    return @[@"WillChangeContent", @"DidChangeContent", @"DidChangeObject"];
}

RCT_EXPORT_METHOD(shared:(NSString *)token organization:(NSInteger)organization resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    
    [NearBee shared:token organization:organization completion:^(NearBee * _Nullable nearBeeInstance, NSError * _Nullable error){
        if (!error) {
            resolve(@YES);
        } else {
            reject(@"no_events", @"There were no events", error);
        }
    }];
}

RCT_REMAP_METHOD(sharedInstance, sharedInstanceWithresolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    NSError *error = nil;
    NearBee *nearBeeInstance = [NearBee sharedAndReturnError:&error];
    if (!error) {
        resolve(@YES);
    } else {
        reject(@"no_events", @"There were no events", error);
    }
}

RCT_REMAP_METHOD(startScanning, startScanningWithresolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    NSError *error = nil;
    NearBee *nearBeeInstance = [NearBee sharedAndReturnError:&error];
    if (!error) {
        if (!nearBeeInstance.scanningInProgress) {
            [nearBeeInstance startScanning];
        }
        resolve(@YES);
    } else {
        reject(@"no_events", @"There were no events", error);
    }
}

RCT_REMAP_METHOD(stopScanning, stopScanningWithresolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    NSError *error = nil;
    NearBee *nearBeeInstance = [NearBee sharedAndReturnError:&error];
    if (!error) {
        if (nearBeeInstance.scanningInProgress) {
            [nearBeeInstance stopScanning];
        }
        resolve(@YES);
    } else {
        reject(@"no_events", @"There were no events", error);
    }
}

RCT_REMAP_METHOD(ignoreCacheOnce, ignoreCacheOnceWithresolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    NSError *error = nil;
    NearBee *nearBeeInstance = [NearBee sharedAndReturnError:&error];
    if (!error) {
        [nearBeeInstance ignoreCacheOnce];
        resolve(@YES);
    } else {
        reject(@"no_events", @"There were no events", error);
    }
}

RCT_EXPORT_METHOD(checkAndProcessNearbyNotification:(UNNotification * _Nonnull)notification resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    NSError *error = nil;
    NearBee *nearBeeInstance = [NearBee sharedAndReturnError:&error];
    if (!error) {
        [nearBeeInstance checkAndProcessNearbyNotification:notification];
        resolve(@YES);
    } else {
        reject(@"no_events", @"There were no events", error);
    }
}

RCT_EXPORT_METHOD(displayContentOfEddystoneUrl:(NSString * _Nonnull)eddystoneUrl resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    NSError *error = nil;
    NearBee *nearBeeInstance = [NearBee sharedAndReturnError:&error];
    if (!error) {
        [nearBeeInstance displayContentOfEddystoneUrl:eddystoneUrl];
        resolve(@YES);
    } else {
        reject(@"no_events", @"There were no events", error);
    }
}

@end
