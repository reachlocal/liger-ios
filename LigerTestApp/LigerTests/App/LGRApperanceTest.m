//
//  RLMAppearanceTest.m
//  Edge
//
//  Created by John Gustafsson on 3/5/13.
//  Copyright (c) 2013 ReachLocal, Inc. All rights reserved.
//

#import "LGRAppearance.h"

@import XCTest;

@interface LGRApperanceTest : XCTestCase
@end

@implementation LGRApperanceTest

- (void)setUp
{
    [super setUp];
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    [super tearDown];
}

- (void)testSettingUpAppearance
{
	[LGRAppearance setupApperance];
}

- (void)testStatusBar
{
	UIStatusBarStyle style = [LGRAppearance statusBar];
	XCTAssert(style == UIStatusBarStyleDefault || style == UIStatusBarStyleLightContent, @"Default or Light are the only options");
}

- (void)testStatusBarDialog
{
	UIStatusBarStyle style = [LGRAppearance statusBarDialog];
	XCTAssert(style == UIStatusBarStyleDefault || style == UIStatusBarStyleLightContent, @"Default or Light are the only options");
}

@end
