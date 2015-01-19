//
//  LGRHTMLViewControllerTest.m
//  LigerMobile
//
//  Created by John Gustafsson on 11/26/13.
//  Copyright (c) 2013-2014 ReachLocal Inc. All rights reserved.  https://github.com/reachlocal/liger-ios/blob/master/LICENSE
//

@import XCTest;

#import "LGRHTMLViewController.h"
#import "LGRCordovaViewController.h"

#import "OCMock.h"

@interface LGRHTMLViewController (Test)
@property (readonly) LGRCordovaViewController *cordova;
@end

@interface LGRHTMLViewControllerTest : XCTestCase
@property (nonatomic, strong) LGRHTMLViewController *liger;
@end

@implementation LGRHTMLViewControllerTest

- (void)setUp
{
	[super setUp];
	self.liger = [[LGRHTMLViewController alloc] initWithPage:@"testPage" title:@"Test Title" args:@{} options:@{}];
}

- (void)testInitWithPage
{
	NSDictionary *args = @{@"test": @YES, @"version": @76};
	LGRViewController *liger = [[LGRHTMLViewController alloc] initWithPage:@"testPage" title:@"Test Title" args:args options:@{}];
	
	XCTAssertEqual(liger.page, @"testPage", @"Page name is wrong");
	XCTAssertEqual(liger.title, @"Test Title", @"Title is wrong");
	XCTAssertEqualObjects(liger.args, args, @"Args are wrong");
	XCTAssertNil(liger.parentPage, @"Parent shouldn't be set");
}

- (void)testNativePage
{
	XCTAssertNil([LGRHTMLViewController nativePage], @"LGRHTMLViewController page should not have a name");
}

- (void)testDialogClosed
{
	LGRViewController *liger = [OCMockObject partialMockForObject:self.liger];
	
	id mock = [OCMockObject mockForClass:LGRCordovaViewController.class];
	
	[[[(id)liger stub] andReturn:mock] cordova];
	[[mock expect] dialogClosed:OCMOCK_ANY];
	
	[liger dialogClosed:@{}];
	
	XCTAssertNoThrow([mock verify], @"dialogClosed should be sent to the cordova controller");
}

- (void)testChildUpdates
{
	LGRViewController *liger = [OCMockObject partialMockForObject:self.liger];
	
	id mock = [OCMockObject mockForClass:LGRCordovaViewController.class];
	
	[[[(id)liger stub] andReturn:mock] cordova];
	[[mock expect] childUpdates:OCMOCK_ANY];
	
	[liger childUpdates:@{}];
	
	XCTAssertNoThrow([mock verify], @"dialogClosed should be sent to the cordova controller");
}

- (void)testPageWillAppear
{
	id liger = [OCMockObject partialMockForObject:self.liger];

	id cordova = [OCMockObject mockForClass:LGRCordovaViewController.class];
	[[[liger stub] andReturn:cordova] cordova];

	[[cordova expect] pageWillAppear];

	[liger pageWillAppear];

	XCTAssertNoThrow([cordova verify], @"pageWillAppear should call cordova");
}

- (void)testPushNotificationTokenUpdatedError
{
	id liger = [OCMockObject partialMockForObject:self.liger];

	id mock = [OCMockObject mockForClass:LGRCordovaViewController.class];
	[[[liger stub] andReturn:mock] cordova];

	[[mock expect] pushNotificationTokenUpdated:@"26ea0f5899ac6bd8a3e0d6b51f38a4ad3475c1e4eefbeee62eca722cef0c3bf9" error:nil];

	[liger pushNotificationTokenUpdated:@"26ea0f5899ac6bd8a3e0d6b51f38a4ad3475c1e4eefbeee62eca722cef0c3bf9" error:nil];

	XCTAssertNoThrow([mock verify], @"pushNotificationTokenUpdated:error should call cordova");
}

- (void)testNotificationArrivedState
{
	id liger = [OCMockObject partialMockForObject:self.liger];

	id cordova = [OCMockObject mockForClass:LGRCordovaViewController.class];
	[[[liger stub] andReturn:cordova] cordova];

	[[cordova expect] notificationArrived:OCMOCK_ANY state:UIApplicationStateActive];
	[[cordova expect] notificationArrived:OCMOCK_ANY state:UIApplicationStateInactive];
	[[cordova expect] notificationArrived:OCMOCK_ANY state:UIApplicationStateBackground];

	[liger notificationArrived:@{@"example": @(NO)} state:UIApplicationStateActive];
	[liger notificationArrived:@{@"example": @(NO)} state:UIApplicationStateInactive];
	[liger notificationArrived:@{@"example": @(NO)} state:UIApplicationStateBackground];

	XCTAssertNoThrow([cordova verify], @"notificationArrived:background should call cordova");
}

- (void)testHandleAppOpenURL
{
	id menu = [OCMockObject partialMockForObject:self.liger];

	id mock = [OCMockObject mockForClass:LGRCordovaViewController.class];
	[[[menu stub] andReturn:mock] cordova];

	[[mock expect] handleAppOpenURL:[NSURL URLWithString:@"test://test"]];

	[menu handleAppOpenURL:[NSURL URLWithString:@"test://test"]];

	XCTAssertNoThrow([mock verify], @"pushNotificationTokenUpdated:error should call cordova");
}

- (void)testButtonTapped
{
	id menu = [OCMockObject partialMockForObject:self.liger];

	id mock = [OCMockObject mockForClass:LGRCordovaViewController.class];
	[[[menu stub] andReturn:mock] cordova];

	[[mock expect] buttonTapped:OCMOCK_ANY];

	[menu buttonTapped:@{@"button": @"done"}];

	XCTAssertNoThrow([mock verify], @"pushNotificationTokenUpdated:error should call cordova");
}

@end
