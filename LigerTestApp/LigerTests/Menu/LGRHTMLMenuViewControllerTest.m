//
//  LGRHTMLMenuViewControllerTest.m
//  Liger
//
//  Created by John Gustafsson on 11/26/13.
//  Copyright (c) 2013-2014 ReachLocal Inc. All rights reserved.  https://github.com/reachlocal/liger-ios/blob/master/LICENSE
//

@import XCTest;

#import "LGRHTMLMenuViewController.h"
#import "LGRCordovaViewController.h"

#import "XCTAsyncTestCase.h"
#import "OCMock.h"

@interface LGRHTMLMenuViewController (Test)
@property (readonly) LGRCordovaViewController *cordova;
@end

@interface LGRHTMLMenuViewControllerTest : XCTAsyncTestCase
@property (nonatomic, strong) LGRHTMLMenuViewController *menu;
@end

@implementation LGRHTMLMenuViewControllerTest

- (void)setUp
{
	self.menu = [[LGRHTMLMenuViewController alloc] initWithPage:@"testPage" title:@"testTitle" args:@{}];
}

- (void)testInitWithPage
{
	NSDictionary *args = @{@"test": @YES, @"version": @76};
	LGRViewController *liger = [[LGRHTMLMenuViewController alloc] initWithPage:@"testPage" title:@"testTitle" args:args];
	
	XCTAssertEqual(liger.page, @"testPage", @"Page name is wrong");
	XCTAssertEqual(liger.title, @"testTitle", @"Title is wrong");
	XCTAssertEqualObjects(liger.args, args, @"Args are wrong");
	XCTAssertNil(liger.ligerParent, @"Parent shouldn't be set");
	XCTAssertFalse(liger.userCanRefresh, @"User refresh should be false as default");
}

- (void)testNativePage
{
	XCTAssertNil([LGRHTMLMenuViewController nativePage], @"LGRHTMLMenuViewController page should not have a name");
}

- (void)testViewDidLoad
{
	id menu = [OCMockObject partialMockForObject:self.menu];

	id view = [OCMockObject mockForClass:UIView.class];
	[[view expect] addSubview:OCMOCK_ANY];
	[[[view stub] andReturnValue:OCMOCK_VALUE(CGRectMake(0, 0, 0, 0))] bounds];
	[[view stub] setFrame:CGRectMake(0, 0, 0, 0)];
	[[[menu stub] andReturn:view] view];

	id cordova = [OCMockObject mockForClass:LGRCordovaViewController.class];
	[[[cordova stub] andReturn:view] view];
	[[[menu stub] andReturn:cordova] cordova];

	[menu viewDidLoad];

	XCTAssertNoThrow([view verify], @"View wasn't added");
}

- (void)testRefreshPage
{
	LGRViewController *liger = [OCMockObject partialMockForObject:self.menu];

	id mock = [OCMockObject mockForClass:LGRCordovaViewController.class];

	[[[(id)liger stub] andReturn:mock] cordova];

	[[mock expect] refreshPage:YES];
	[[mock expect] refreshPage:NO];

	[liger refreshPage:YES];
	[liger refreshPage:NO];

	XCTAssertNoThrow([mock verify], @"refreshPage should be sent to the cordova controller");
}

- (void)testDialogClosed
{
	LGRViewController *liger = [OCMockObject partialMockForObject:self.menu];
	
	id mock = [OCMockObject mockForClass:LGRCordovaViewController.class];
	
	[[[(id)liger stub] andReturn:mock] cordova];
	[[mock expect] dialogClosed:OCMOCK_ANY];
	
	[liger dialogClosed:@{}];
	
	XCTAssertNoThrow([mock verify], @"dialogClosed should be sent to the cordova controller");
}

- (void)testChildUpdates
{
	LGRViewController *menu = [OCMockObject partialMockForObject:self.menu];
	
	id mock = [OCMockObject mockForClass:LGRCordovaViewController.class];
	
	[[[(id)menu stub] andReturn:mock] cordova];
	[[mock expect] childUpdates:OCMOCK_ANY];
	
	[menu childUpdates:@{}];
	
	XCTAssertNoThrow([mock verify], @"dialogClosed should be sent to the cordova controller");
}

- (void)testPageWillAppear
{
	id menu = [OCMockObject partialMockForObject:self.menu];
	
	id cordova = [OCMockObject mockForClass:LGRCordovaViewController.class];
	[[[menu stub] andReturn:cordova] cordova];
	
	[[cordova expect] pageWillAppear];

	[menu pageWillAppear];

	XCTAssertNoThrow([cordova verify], @"pageWillAppear should call cordova");
}

- (void)testUserCanRefresh
{
	XCTAssertEqual(self.menu.userCanRefresh, NO, @"Should be NO.");
	self.menu.userCanRefresh = YES;
	XCTAssertEqual(self.menu.userCanRefresh, YES, @"Should be YES.");
	self.menu.userCanRefresh = NO;
	XCTAssertEqual(self.menu.userCanRefresh, NO, @"Should be NO.");
	self.menu.userCanRefresh = NO;
	XCTAssertEqual(self.menu.userCanRefresh, NO, @"Should be NO.");
}

- (void)testPushNotificationTokenUpdatedError
{
	id menu = [OCMockObject partialMockForObject:self.menu];

	id mock = [OCMockObject mockForClass:LGRCordovaViewController.class];
	[[[menu stub] andReturn:mock] cordova];

	[[mock expect] pushNotificationTokenUpdated:@"26ea0f5899ac6bd8a3e0d6b51f38a4ad3475c1e4eefbeee62eca722cef0c3bf9" error:nil];

	[menu pushNotificationTokenUpdated:@"26ea0f5899ac6bd8a3e0d6b51f38a4ad3475c1e4eefbeee62eca722cef0c3bf9" error:nil];

	XCTAssertNoThrow([mock verify], @"pushNotificationTokenUpdated:error should call cordova");
}

- (void)testNotificationArrivedBackground
{
	id menu = [OCMockObject partialMockForObject:self.menu];

	id cordova = [OCMockObject mockForClass:LGRCordovaViewController.class];
	[[[menu stub] andReturn:cordova] cordova];

	[[cordova expect] notificationArrived:OCMOCK_ANY background:YES];
	[[cordova expect] notificationArrived:OCMOCK_ANY background:NO];

	[menu notificationArrived:@{@"example": @(NO)} background:YES];
	[menu notificationArrived:@{@"example": @(NO)} background:NO];

	XCTAssertNoThrow([cordova verify], @"notificationArrived:background should call cordova");
}

- (void)testHandleAppOpenURL
{
	id menu = [OCMockObject partialMockForObject:self.menu];

	id mock = [OCMockObject mockForClass:LGRCordovaViewController.class];
	[[[menu stub] andReturn:mock] cordova];

	[[mock expect] handleAppOpenURL:[NSURL URLWithString:@"test://test"]];

	[menu handleAppOpenURL:[NSURL URLWithString:@"test://test"]];

	XCTAssertNoThrow([mock verify], @"pushNotificationTokenUpdated:error should call cordova");
}

@end
