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

//- (void)setUp {
//    [super setUp];
//    // Put setup code here. This method is called before the invocation of each test method in the class.
//}
//
//- (void)tearDown {
//    // Put teardown code here. This method is called after the invocation of each test method in the class.
//    [super tearDown];
//}

- (void)testCreatingMZMapController {
  MZMapViewController *map = [[MZMapViewController alloc] init];
  XCTAssertNotNil(map);
}

@end
