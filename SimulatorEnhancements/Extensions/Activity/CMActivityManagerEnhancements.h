//
//  CMActivityManagerEnhancements.h
//  SimulatorEnhancements
//
//  Created by Béla Szomathelyi on 2018. 10. 29..
//  Copyright © 2018. Colin Eberhardt. All rights reserved.
//

#import "CEBaseManagerEnhancement.h"

@interface CMActivityManagerEnhancements : CEBaseManagerEnhancement

- (void)enable;

- (void)receiveSimulatorData:(NSDictionary *)data;

+ (CMActivityManagerEnhancements *)instance;

@end

