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
#import "CMActivityManagerEnhancements.h"

@interface CEViewController () <CLLocationManagerDelegate>

@property CMMotionManager *motionManager;
@property CLLocationManager *location;
@property CMMotionActivityManager *activityManager;

@end


@implementation CEViewController

- (void)viewDidLoad {
	NSAssert(TARGET_IPHONE_SIMULATOR, @"Works only with simulator");
  	[super viewDidLoad];
	
	//Accelerometer
	[[CEMotionEnhancements instance] enable];
	self.motionManager = [CMMotionManager new];
	[self.motionManager startAccelerometerUpdatesToQueue:NSOperationQueue.mainQueue withHandler:^(CMAccelerometerData * _Nullable accelerometerData, NSError * _Nullable error) {
		NSLog(@"[Accelerometer] %@", accelerometerData);
	}];
	
	//Location
	[[CELocationEnhancements instance] enable];
	self.location = [CLLocationManager new];
	self.location.delegate = self;
	[self.location startUpdatingHeading];
	
	
	//Activity
	[[CMActivityManagerEnhancements instance] enable];
	self.activityManager = [CMMotionActivityManager new];
	[self.activityManager startActivityUpdatesToQueue:NSOperationQueue.mainQueue withHandler:^(CMMotionActivity * _Nullable activity) {
		NSLog(@"[Activity] %@", activity);
	}];
	
	//Recieve data from server
	[[CESimulatorEnhancements instance] startClient];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
	NSLog(@"[Location] %@", locations);
}

@end
