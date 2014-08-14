//
//  LGRTabBarViewControllerTest.m
//  LigerMobile
//
//  Created by Gary Moon on 8/6/14.
//  Copyright (c) 2013-2014 ReachLocal Inc. All rights reserved.  https://github.com/reachlocal/liger-ios/blob/master/LICENSE
//

#import <XCTest/XCTest.h>
#import "LGRTabBarViewController.h"
#import <OCMock.h>

@interface LGRTabBarViewController ()
@property(nonatomic, strong) UITabBarController *tab;
@end

@interface LGRTabBarViewControllerTest : XCTestCase
@property(nonatomic, strong) LGRTabBarViewController *tab;
@end

@implementation LGRTabBarViewControllerTest

- (void)setUp
{
	[super setUp];
	NSDictionary *pageOne = @{@"page": @"firstPage", @"title": @"First Page"};
	NSDictionary *pageTwo = @{@"page": @"secondPage", @"title": @"Second Page"};

	NSDictionary *navigatorOne = @{@"page": @"navigator", @"title": @"Navigator One", @"args": pageOne};
	NSDictionary *navigatorTwo = @{@"page": @"navigator", @"title": @"Navigator Two", @"args": @{@"pages": @[pageOne, pageTwo]}};

	self.tab = [[LGRTabBarViewController alloc] initWithPage: @"tab"
													   title: @"Test"
														args: @{@"pages": @[navigatorOne, navigatorTwo]}
													 options: @{}];
}

- (void)tearDown
{
	// Put teardown code here. This method is called after the invocation of each test method in the class.
	[super tearDown];
}

- (void)testInit
{
	XCTAssertNotNil([[LGRTabBarViewController alloc] init], @"Didn't init");
}

- (void)testNativePage
{
	XCTAssertEqualObjects([LGRTabBarViewController nativePage], @"tab", @"Name of page changed");
}

- (void)testInitWithPage
{
	NSDictionary *pageOne = @{@"page": @"firstPage", @"title": @"First Page"};
	NSDictionary *pageTwo = @{@"page": @"secondPage", @"title": @"Second Page"};

	NSDictionary *navigatorOne = @{@"page": @"navigator", @"title": @"Navigator One", @"args": pageOne};
	NSDictionary *navigatorTwo = @{@"page": @"navigator", @"title": @"Navigator Two", @"args": @{@"pages": @[pageOne, pageTwo]}};

	id tab = [[LGRTabBarViewController alloc] initWithPage: @"tab"
													 title: @"Test"
													  args: @{@"pages": @[navigatorOne, navigatorTwo]}
												   options: @{}];

	XCTAssertNotNil(tab, @"Tab failed to instatiate");
}

- (void)testViewDidLoad
{
	id tab = OCMPartialMock(self.tab);

	[tab viewDidLoad];

	XCTAssertNotNil([tab tab], @"No tab created");
}

- (void)testPushNotificationTokenUpdatedError
{
	id rootPage = OCMPartialMock(self.tab.rootPage);
	OCMExpect([rootPage pushNotificationTokenUpdated:OCMOCK_ANY error:OCMOCK_ANY]);

	id tab = OCMPartialMock(self.tab);
	OCMStub([tab rootPage]).andReturn(rootPage);

	[tab pushNotificationTokenUpdated:nil error:nil];

	OCMVerifyAll(rootPage);
}

- (void)testNotificationArrivedBackground
{
	id rootPage = OCMPartialMock(self.tab.rootPage);
	OCMExpect([rootPage notificationArrived:OCMOCK_ANY background:NO]);

	id tab = OCMPartialMock(self.tab);
	OCMStub([tab rootPage]).andReturn(rootPage);

	[tab notificationArrived:@{} background:NO];

	OCMVerifyAll(rootPage);
}

- (void)testHandleAppOpenURL
{
	id rootPage = OCMPartialMock(self.tab.rootPage);
	OCMExpect([rootPage handleAppOpenURL:[NSURL URLWithString:@"http://reachlocal.github.io/liger"]]);

	id tab = OCMPartialMock(self.tab);
	OCMStub([tab rootPage]).andReturn(rootPage);
	
	[tab handleAppOpenURL:[NSURL URLWithString:@"http://reachlocal.github.io/liger"]];
	
	OCMVerifyAll(rootPage);
}

@end
