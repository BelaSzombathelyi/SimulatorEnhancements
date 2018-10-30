//
//  FakeAccelerationData.m
//  SimulatorEnhancements
//
//  Created by Béla Szomathelyi on 2018. 10. 29..
//  Copyright © 2018. Colin Eberhardt. All rights reserved.
//

#import "FakeAccelerationData.h"

@interface FakeAccelerationData ()

@property CMAcceleration myAcceleration;
@property NSTimeInterval myTimestamp;

@end


@implementation FakeAccelerationData

+ (instancetype)accelerationWithData:(NSDictionary *)data {
	CMAcceleration acc;
	acc.x = [[data objectForKey:@"x"] doubleValue];
	acc.y = [[data objectForKey:@"y"] doubleValue];
	acc.z = [[data objectForKey:@"z"] doubleValue];
	FakeAccelerationData *acceleration = [FakeAccelerationData new];
	acceleration.myTimestamp = [NSDate new].timeIntervalSince1970;
	acceleration.myAcceleration = acc;
	return acceleration;
}

- (CMAcceleration)acceleration {
	return self.myAcceleration;
}

- (NSTimeInterval)timestamp {
	return self.myTimestamp;
}

- (NSString *)description {
	return [NSString stringWithFormat:@"%@ @ x: %.02f, y: %.02f, z: %.02f", NSStringFromClass([self class]), _myAcceleration.x, _myAcceleration.y, _myAcceleration.z];
}

@end
