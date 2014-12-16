//
//  RLMAppearanceTest.m
//  Edge
//
//  Created by John Gustafsson on 3/5/13.
//  Copyright (c) 2013-2014 ReachLocal Inc. All rights reserved.  https://github.com/reachlocal/liger-ios/blob/master/LICENSE
//

#import "LGRAppearance.h"

@import XCTest;
#include "OCMock.h"

@interface LGRAppearance()
+ (NSInteger)osMainVersion;
@end

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
	id appearance = OCMClassMock(LGRAppearance.class);
	OCMExpect([appearance osMainVersion]).andReturn((NSInteger)6);
	[LGRAppearance setupApperance];
	OCMVerifyAll(appearance);
	[appearance stopMocking];
}

- (void)testSettingUpAppearanceiOS7
{
	id appearance = OCMClassMock(LGRAppearance.class);
	OCMExpect([appearance osMainVersion]).andReturn((NSInteger)7);
	[LGRAppearance setupApperance];
	OCMVerifyAll(appearance);
	[appearance stopMocking];
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
