//
//  SampleApp_ObjcTests.m
//  SampleApp-ObjcTests
//
//  Created by Matt Smollinger on 5/25/17.
//  Copyright © 2017 Mapzen. All rights reserved.
//

#import <XCTest/XCTest.h>
@import Mapzen_ios_sdk;

@interface SampleApp_ObjcTests : XCTestCase

@end

@implementation SampleApp_ObjcTests

- (void)testCreatingMZMapController {
  MZMapViewController *map = [[MZMapViewController alloc] init];
  XCTAssertNotNil(map);
}

- (void)testMethodAvailabilityOnController {
  MZMapViewController *map = [[MZMapViewController alloc] init];
  XCTAssert(map.showTransitOverlay == NO);
}

- (void)testStyleSheetProtocolAvailability {
  id<StyleSheet> test;
  test = [[BubbleWrapStyle alloc] init];
  XCTAssertTrue([test.importString containsString:@"bubble-wrap"]);
}
@end
