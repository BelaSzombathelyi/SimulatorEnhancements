//
//  CEViewController.m
//  SimulatorEnhancements
//
//  Created by Colin Eberhardt on 16/02/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

#import "CEViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "CELocationEnhancements.h"
#import "CESimulatorEnhancements.h"
#import <CoreMotion/CoreMotion.h>
#import "CEMotionEnhancements.h"

@interface CEViewController () <CLLocationManagerDelegate>
@property CMMotionManager *motionManager;
@property CLLocationManager *location;

@end

@implementation CEViewController {
}

- (void)viewDidLoad
{
  	[super viewDidLoad];
	self.motionManager = [CMMotionManager new];
	[self.motionManager startAccelerometerUpdatesToQueue:NSOperationQueue.mainQueue withHandler:^(CMAccelerometerData * _Nullable accelerometerData, NSError * _Nullable error) {
		NSLog(@"Acc %@", accelerometerData);
	}];
	[[CEMotionEnhancements instance] enable];
	[[CELocationEnhancements instance] enable];

	self.location = [CLLocationManager new];
	self.location.delegate = self;
	[self.location startUpdatingHeading];
	[[CESimulatorEnhancements instance] startClient];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
	NSLog(@"[LOC] %@", locations);
}

@end
