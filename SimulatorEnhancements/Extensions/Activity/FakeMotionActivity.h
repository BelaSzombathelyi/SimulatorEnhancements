//
//  FakeMotionActivity.h
//  SimulatorEnhancements
//
//  Created by Béla Szomathelyi on 2018. 10. 29..
//  Copyright © 2018. Colin Eberhardt. All rights reserved.
//

#import <CoreMotion/CoreMotion.h>

@interface FakeMotionActivity : CMMotionActivity

+ (instancetype)activityWithData:(NSDictionary *)data;

@end
