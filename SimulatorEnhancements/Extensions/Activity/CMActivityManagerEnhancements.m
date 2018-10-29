//
//  CMActivityManagerEnhancements.m
//  SimulatorEnhancements
//
//  Created by Béla Szomathelyi on 2018. 10. 29..
//  Copyright © 2018. Colin Eberhardt. All rights reserved.
//

#import "CMActivityManagerEnhancements.h"
#import "CESwizzleUtils.h"
#import <CoreMotion/CoreMotion.h>

@implementation CMActivityManagerEnhancements

- (void)receiveSimulatorData:(NSArray *)data {
//	CMAcceleration acc;
//	acc.x = [[jsonData objectForKey:@"x"] doubleValue];
//	acc.y = [[jsonData objectForKey:@"y"] doubleValue];
//	acc.z = [[jsonData objectForKey:@"z"] doubleValue];
//
//	CMAccelerometerData *data = [[CMAccelerometerData alloc] init];
//	[data simx_setAcceleration:acc];
//
//	for (CMMotionManager *motionManager in [self getManagers]) {
//		[motionManager simx_accelerometerUpdate:data];
//	}
}

- (void)enable {
	[CESwizzleUtils swizzleClass:[CMMotionActivityManager class] method:@"startActivityUpdatesToQueue:withHandler:"];
}

+ (CMActivityManagerEnhancements *)instance {
	static CMActivityManagerEnhancements *instance = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		instance = [CMActivityManagerEnhancements new];
	});
	return instance;
}

@end
