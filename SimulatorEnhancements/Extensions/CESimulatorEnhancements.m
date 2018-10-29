//
//  CESimulatorEnhancements.m
//  SimulatorEnhancements
//
//  Created by Colin Eberhardt on 16/02/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

#import "CESimulatorEnhancements.h"
#import "CELocationEnhancements.h"
#import "CEMotionEnhancements.h"
#import "CMActivityManagerEnhancements.h"

@implementation CESimulatorEnhancements {
  NSTimer *_timer;
  NSMutableData* _responseData;
}

- (void)enable {
  [[CELocationEnhancements instance] enable];
  [[CEMotionEnhancements instance] enable];
}

- (void)receiveSimulatorData:(NSString *)data {
  NSData* resultData = [data dataUsingEncoding:NSUTF8StringEncoding];
  NSError* error = nil;
  NSDictionary* json = [NSJSONSerialization JSONObjectWithData:resultData
                                                       options:kNilOptions
                                                         error:&error];
	
  if ([json objectForKey:@"location"]) {
    [[CELocationEnhancements instance] receiveSimulatorData:json[@"location"]];
  }
  if ([json objectForKey:@"accelerometer"]) {
    [[CEMotionEnhancements instance] receiveSimulatorData:json[@"accelerometer"]];
  }
	if ([json objectForKey:@"activity"]) {
		[[CMActivityManagerEnhancements instance] receiveSimulatorData:json[@"activity"]];
	}
}

+ (CESimulatorEnhancements *)instance {
  static CESimulatorEnhancements *instance = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    instance = [CESimulatorEnhancements new];
  });
  return instance;
}

#pragma mark - client code

- (void)startClient {
  _timer = [NSTimer scheduledTimerWithTimeInterval:0.05
                                            target:self
                                          selector:@selector(tick)
                                          userInfo:nil
                                           repeats:YES];
}

- (void)tick {
  NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://localhost:8080/data"]];
  (void)[[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
  _responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
  [_responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
  NSLog(@"error");
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
  NSString* resultString = [[NSString alloc] initWithData:_responseData
                                                 encoding:NSASCIIStringEncoding];
  [self receiveSimulatorData:resultString];
}


@end
