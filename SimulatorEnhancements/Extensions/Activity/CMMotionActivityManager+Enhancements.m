//
//  CMMotionActivityManager+Enhancements.m
//  SimulatorEnhancements
//
//  Created by Béla Szomathelyi on 2018. 10. 29..
//  Copyright © 2018. Colin Eberhardt. All rights reserved.
//

#import "CMMotionActivityManager+Enhancements.h"
#import <CoreMotion/CoreMotion.h>
#import "CESwizzleUtils.h"
#import <objc/runtime.h>
#import "CMActivityManagerEnhancements.h"

static const void * const kHandlerKey = &kHandlerKey;

@implementation CMMotionActivityManager (Enhancements)

- (void)override_startActivityUpdatesToQueue:(NSOperationQueue *)queue withHandler:(CMMotionActivityHandler)handler {
	objc_setAssociatedObject(self, kHandlerKey, handler, OBJC_ASSOCIATION_RETAIN);
	[[CMActivityManagerEnhancements instance] addManager:self];
}

- (void)simx_setMotionActivity:(CMMotionActivity *)activity {
	CMMotionActivityHandler handler = objc_getAssociatedObject(self, kHandlerKey);
	handler(activity);
}

@end

