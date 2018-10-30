//
//  CLLocationManager+Enhancements.m
//  SimulatorEnhancements
//
//  Created by Colin Eberhardt on 16/02/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

#import "CLLocationManager+Enhancements.h"
#import "CELocationEnhancements.h"
#import <objc/runtime.h>

static const void * const kRegionStatesKey = &kRegionStatesKey;
static const void * const kLastLocationKey = &kLastLocationKey;

typedef NSMutableDictionary<NSString *, NSNumber *> RegionStatesType;

@interface CLLocationManager (Enhancements_Data)
@property (nonatomic, readonly) RegionStatesType *regionStates;
@property (nonatomic, getter=lastLocation, setter=setLastLocation:) CLLocation *lastLocation;

@end

@implementation CLLocationManager (Enhancements_Data)

- (RegionStatesType *)regionStates {
	RegionStatesType *regionStatesDictionary = objc_getAssociatedObject(self, kRegionStatesKey);
	if (!regionStatesDictionary) {
		regionStatesDictionary = [NSMutableDictionary new];
		objc_setAssociatedObject(self, kRegionStatesKey, regionStatesDictionary, OBJC_ASSOCIATION_RETAIN);
	}
	return regionStatesDictionary;
}

- (CLLocation *)lastLocation {
	return objc_getAssociatedObject(self, kLastLocationKey);
}

- (void)setLastLocation:(CLLocation *)location {
	objc_setAssociatedObject(self, kLastLocationKey, location, OBJC_ASSOCIATION_RETAIN);
}

@end


@implementation CLLocationManager (Enhancements)

- (void)override_onClientEventLocation:(id)foo {
  // no-op - this suppresses location change events that are raised
  // by CLLocationManager
}

-(void)override_setDelegate:(id<CLLocationManagerDelegate>)delegate {
  [[CELocationEnhancements instance] addManager:self];
  [self override_setDelegate:delegate];
}

- (void)simx_didUpdateLocation:(CLLocation *)location {
	CLLocation *lastLocation = self.lastLocation;
	self.lastLocation = location;
	
  	id<CLLocationManagerDelegate> delegate = self.delegate;
  	if ([delegate respondsToSelector:@selector(locationManager:didUpdateLocations:)]) {
    	[delegate locationManager:self didUpdateLocations:@[location]];
  	}

	RegionStatesType *regionStates = self.regionStates;
	for (CLRegion *region in self.monitoredRegions) {
		if (![region isKindOfClass:[CLCircularRegion class]]) {
			NSCAssert(NO, @"region is not a CLCircularRegion");
			break;
		}
		CLCircularRegion *circularRegion = (CLCircularRegion *)region;
		BOOL isInNow = [circularRegion containsCoordinate:location.coordinate];
		NSNumber *status = regionStates[region.identifier];
		regionStates[region.identifier] = @(isInNow);
		if (status || lastLocation) {
			BOOL itWasIn = NO;
			if (status) {
				itWasIn = status.boolValue;
			} else {
				itWasIn = [circularRegion containsCoordinate:lastLocation.coordinate];
			}
			if (itWasIn != isInNow) {
				CLRegionState state = isInNow ? CLRegionStateInside : CLRegionStateOutside;
				[self callMethodesOnDelegate:delegate state:state region:circularRegion];
			}
		}
	}
}

- (void)callMethodesOnDelegate:(id<CLLocationManagerDelegate>)delegate state:(CLRegionState)state region:(CLCircularRegion *)region {
	if ([delegate respondsToSelector:@selector(locationManager:didDetermineState:forRegion:)]) {
		if ((region.notifyOnExit && state == CLRegionStateOutside) || (region.notifyOnEntry && state == CLRegionStateInside)) {
			[delegate locationManager:self didDetermineState:state forRegion:region];
		}
	}
	if ([delegate respondsToSelector:@selector(locationManager:didEnterRegion:)]) {
		if (region.notifyOnEntry && state == CLRegionStateInside) {
			[delegate locationManager:self didEnterRegion:region];
		}
	}
	if ([delegate respondsToSelector:@selector(locationManager:didExitRegion:)]) {
		if (region.notifyOnExit && state == CLRegionStateOutside) {
			[delegate locationManager:self didExitRegion:region];
		}
	}
}

- (void)override_startMonitoringForRegion:(CLRegion *)region {
	[self override_startMonitoringForRegion:region];
}

- (void)override_stopMonitoringForRegion:(CLRegion *)region {
	[self.regionStates removeObjectForKey:region.identifier];
	[self override_stopMonitoringForRegion:region];
}

@end
