//
//  LGREmailImportedTest.m
//  LigerMobile
//
//  Created by John Gustafsson on 12/5/13.
//  Copyright (c) 2013-2014 ReachLocal Inc. All rights reserved.  https://github.com/reachlocal/liger-ios/blob/master/LICENSE
//

#import "LGRAppSettingsImported.h"
@import XCTest;

#import "OCMock.h"

@interface LGRAppSettingsImported()
+ (BOOL)iOS8;
@end

@interface LGRAppSettingsImportedTest : XCTestCase

@end

@implementation LGRAppSettingsImportedTest

- (void)testCreation
{
	id sharedApp = OCMPartialMock([UIApplication sharedApplication]);
	id app = OCMClassMock(UIApplication.class);
	OCMStub([app sharedApplication]).andReturn(sharedApp);
	OCMExpect([sharedApp openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]]);

	UIViewController *appSettings = [LGRAppSettingsImported controllerForImportedPage:nil title:nil args:@{} options:@{} parent:nil];
	XCTAssertNil(appSettings, @"LGRAppSettingsImported should not create a page.");

	OCMVerifyAll(sharedApp);
}

- (void)testImportedPage
{
	XCTAssertEqualObjects([LGRAppSettingsImported importedPage], @"appSettings", @"LGREmailImported page should have a name");
}

- (void)testImportedPageiOS7
{
	id appSettingsImported = OCMClassMock(LGRAppSettingsImported.class);
	OCMExpect([appSettingsImported iOS8]).andReturn(NO);

	NSString *appSettings = [LGRAppSettingsImported importedPage];
	XCTAssertNil(appSettings, @"LGRAppSettingsImported imported page shouldn't exist for version prior to iOS8");

	OCMVerifyAll(appSettingsImported);
}

@end
