//
//  FakeMotionActivity.m
//  SimulatorEnhancements
//
//  Created by Béla Szomathelyi on 2018. 10. 29..
//  Copyright © 2018. Colin Eberhardt. All rights reserved.
//

#import "FakeMotionActivity.h"

@interface FakeMotionActivity ()

@property NSDictionary *data;
@property NSDate *myStartDate;
@property NSTimeInterval myTimestamp;

@end


@implementation FakeMotionActivity

+ (instancetype)activityWithData:(NSDictionary *)data {
	FakeMotionActivity *activity = [FakeMotionActivity new];
	activity.myTimestamp = [NSDate new].timeIntervalSince1970;
	activity.myStartDate = [NSDate dateWithTimeIntervalSinceNow:-1];
	activity.data = data;
	return activity;
}

- (NSTimeInterval)timestamp {
	return self.myTimestamp;
}

- (CMMotionActivityConfidence)confidence {
	return (CMMotionActivityConfidence)[self.data[@"confidence"] integerValue];
}

- (NSDate *)startDate {
	return self.myStartDate;
}

- (BOOL)unknown {
	return NO;
}

- (BOOL)stationary {
	return [self.data[@"stationary"] boolValue];
}

- (BOOL)walking {
	return [self.data[@"walking"] boolValue];
}

- (BOOL)running {
	return [self.data[@"running"] boolValue];
}

- (BOOL)automotive {
	return [self.data[@"automotive"] boolValue];
}

- (BOOL)cycling {
	return [self.data[@"cycling"] boolValue];
}

@end
