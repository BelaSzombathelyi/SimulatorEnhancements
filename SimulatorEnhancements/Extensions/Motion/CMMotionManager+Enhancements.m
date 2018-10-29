//
//  CMMotionManager+Enhancements.m
//  Maze
//
//  Created by Colin Eberhardt on 18/02/2014.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

#import "CMMotionManager+Enhancements.h"
#import "CEMotionEnhancements.h"
#import <objc/runtime.h>

static const void * const kHandlerKey = &kHandlerKey;

@implementation CMMotionManager (Enhancements)

- (void)simx_accelerometerUpdate:(CMAccelerometerData *)accelerometerData {
  CMAccelerometerHandler handler = objc_getAssociatedObject(self, kHandlerKey);
  handler(accelerometerData, nil);
}

-(void)override_startAccelerometerUpdatesToQueue:(NSOperationQueue *)queue withHandler:(CMAccelerometerHandler)handler {
  objc_setAssociatedObject(self, kHandlerKey, handler, OBJC_ASSOCIATION_RETAIN);
  [[CEMotionEnhancements instance] addManager:self];
}

@end
