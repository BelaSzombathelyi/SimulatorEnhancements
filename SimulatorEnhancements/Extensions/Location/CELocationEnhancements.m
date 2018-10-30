//
//  CELocationEnhancements.m
//  SimulatorEnhancements
//
//  Created by Colin Eberhardt on 16/02/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

#import <objc/runtime.h>
#import <CoreLocation/CoreLocation.h>
#import "CELocationEnhancements.h"
#import "CLLocationManager+Enhancements.h"
#import "NSDictionary+Helpers.h"
#import "CESwizzleUtils.h"

@interface CELocationEnhancements ()
@end

@implementation CELocationEnhancements

- (void)enable {
  [CESwizzleUtils swizzleClass:[CLLocationManager class] method:@"setDelegate:"];
  [CESwizzleUtils swizzleClass:[CLLocationManager class] method:@"onClientEventLocation:"];
	[CESwizzleUtils swizzleClass:[CLLocationManager class] method:@"startMonitoringForRegion:"];
	[CESwizzleUtils swizzleClass:[CLLocationManager class] method:@"stopMonitoringForRegion:"];
}

- (void)receiveSimulatorData:(NSDictionary *)locationData {

  double lat = [[locationData NSNumberForKey:@"latitude"] doubleValue];
  double lon = [[locationData NSNumberForKey:@"longitude"] doubleValue];
  CLLocation *location = [[CLLocation alloc] initWithLatitude:lat longitude:lon];

  for (CLLocationManager *locationManager in [self getManagers]) {
    [locationManager simx_didUpdateLocation:location];
  }
}


+ (CELocationEnhancements *)instance {
  static CELocationEnhancements *instance = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    instance = [CELocationEnhancements new];
  });
  return instance;
}

@end
