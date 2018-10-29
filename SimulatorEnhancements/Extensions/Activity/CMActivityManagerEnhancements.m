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
#import "CMMotionActivityManager+Enhancements.h"
#import "FakeMotionActivity.h"

@implementation CMActivityManagerEnhancements

- (void)receiveSimulatorData:(NSDictionary *)data {
	CMMotionActivity *activity = [FakeMotionActivity activityWithData:data];
	for (CMMotionActivityManager *manager in [self getManagers]) {
		[manager simx_setMotionActivity:activity];
	}
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
