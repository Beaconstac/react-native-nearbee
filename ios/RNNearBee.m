
#import <NearBee/NearBee.h>
#import "RNNearbee.h"
#import <Foundation/Foundation.h>

@implementation RNNearbee

RCT_EXPORT_MODULE();

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

- (NSArray<NSString *> *)supportedEvents
{
    return @[@"WillChangeContent", @"DidChangeContent", @"DidChangeObject"];
}

RCT_METHOD_EXPORT(shared:(NSString * _Nonnull)token organization:(NSInteger)organization resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    
    [NearBee shared:token organization:organization completion:^(NearBee * _Nullable nearBeeInstance, NSError * _Nullable error){
        if (!error) {
            resolve(@YES);
        } else {
            reject(@"no_instance", @"There is no instance", error);
        }
    }];
}

RCT_REMAP_METHOD(sharedInstance, sharedInstanceWithresolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    NSError *error = nil;
    NearBee *nearBeeInstace = [NearBee sharedInstanceAndReturnError:&error];
    if (!error) {
        resolve(@YES);
    } else {
        reject(@"no_instance", @"There is no instance", error);
    }
}

RCT_REMAP_METHOD(startScanning, startScanningWithresolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    NSError *error = nil;
    NearBee *nearBeeInstace = [NearBee sharedInstanceAndReturnError:&error];
    if (!error) {
        if (!nearBeeInstance.isScanning) {
            [nearBeeInstace startScanning];
        }
        resolve(@YES);
    } else {
        reject(@"no_instance", @"There is no instance", error);
    }
}

RCT_REMAP_METHOD(stopScanning, stopScanningWithresolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    NSError *error = nil;
    NearBee *nearBeeInstace = [NearBee sharedInstanceAndReturnError:&error];
    if (!error) {
        if (nearBeeInstance.isScanning) {
            [nearBeeInstace stopScanning];
        }
        resolve(@YES);
    } else {
        reject(@"no_instance", @"There is no instance", error);
    }
}

RCT_REMAP_METHOD(ignoreCacheOnce, ignoreCacheOnceWithresolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    NSError *error = nil;
    NearBee *nearBeeInstace = [NearBee sharedInstanceAndReturnError:&error];
    if (!error) {
        [nearBeeInstace ignoreCacheOnce];
        resolve(@YES);
    } else {
        reject(@"no_instance", @"There is no instance", error);
    }
}

RCT_METHOD_EXPORT(checkAndProcessNearbyNotification:(UNNotification * _Nonnull)notification resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    NSError *error = nil;
    NearBee *nearBeeInstace = [NearBee sharedInstanceAndReturnError:&error];
    if (!error) {
        [nearBeeInstace checkAndProcessNearbyNotification:notification];
        resolve(@YES);
    } else {
        reject(@"no_instance", @"There is no instance", error);
    }
}

RCT_METHOD_EXPORT(displayContentOfEddystoneUrl:(NSString * _Nonnull)eddystoneUrl resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    NSError *error = nil;
    NearBee *nearBeeInstace = [NearBee sharedInstanceAndReturnError:&error];
    if (!error) {
        [nearBeeInstace displayContentOfEddystoneUrl:eddystoneUrl];
        resolve(@YES);
    } else {
        reject(@"no_instance", @"There is no instance", error);
    }
}

@end
  
