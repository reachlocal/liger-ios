//
//  LGRDrawerViewControllerTest.m
//  LigerMobile
//
//  Created by John Gustafsson on 11/25/13.
//  Copyright (c) 2013-2014 ReachLocal Inc. All rights reserved.  https://github.com/reachlocal/liger-ios/blob/master/LICENSE
//

@import XCTest;

#import "LGRDrawerViewController.h"
#import "LGRPageFactory.h"
#import "LGRApp.h"

#import "OCMock.h"


@interface LGRDrawerViewController ()
@property (nonatomic, strong) LGRViewController *menu;
- (LGRViewController*)pageController;
@end

@interface LGRDrawerViewControllerTest : XCTestCase
@property(nonatomic, strong) LGRDrawerViewController *drawer;
@end

@implementation LGRDrawerViewControllerTest

- (void)setUp
{
	UIViewController* drawer = [LGRPageFactory controllerForPage:LGRApp.root[@"page"] title:LGRApp.root[@"title"] args:LGRApp.root[@"args"] options:LGRApp.root[@"options"] parent:nil];
	XCTAssertTrue([drawer isKindOfClass:LGRDrawerViewController.class], @"Drawer page creation failed.");

	self.drawer = (LGRDrawerViewController*)drawer;
	XCTAssert(self.drawer.view, @"drawer has no view");

	[super setUp];
}

- (void)tearDown
{
	[super tearDown];
}

- (void)testResetApp
{
	[self.drawer resetApp];
	[self.drawer.childViewControllers[0] viewWillAppear:NO]; // We have to fake calling this as drawer's view isn't hooked up to anything

	XCTAssert(self.drawer.childViewControllers.count == 2, @"Wrong number of child controllers.");
}

- (void)testNativePage
{
	XCTAssertTrue([[LGRDrawerViewController nativePage] isEqualToString:@"drawer"], @"Native page wasn't named DrawerPage");
}

- (void)testPushNotificationTokenUpdatedError
{
	id menu = [OCMockObject partialMockForObject:self.drawer.menu];
	[[menu expect] pushNotificationTokenUpdated:OCMOCK_ANY error:OCMOCK_ANY];

	id drawer = [OCMockObject partialMockForObject:self.drawer];
	[[[drawer stub] andReturn:menu] menu];

	[drawer pushNotificationTokenUpdated:nil error:nil];

	XCTAssertNoThrow([menu verify], @"Verify failed");
}

- (void)testNotificationArrivedBackground
{
	id menu = [OCMockObject partialMockForObject:self.drawer.menu];
	[[menu expect] notificationArrived:OCMOCK_ANY background:YES];

	id drawer = [OCMockObject partialMockForObject:self.drawer];
	[[[drawer stub] andReturn:menu] menu];

	[drawer notificationArrived:@{} background:YES];

	XCTAssertNoThrow([menu verify], @"Verify failed");
}

- (void)testHandleAppOpenURL
{
	id menu = [OCMockObject partialMockForObject:self.drawer.menu];
	[[menu expect] handleAppOpenURL:[NSURL URLWithString:@"test://test"]];

	id drawer = [OCMockObject partialMockForObject:self.drawer];
	[[[drawer stub] andReturn:menu] menu];

	[drawer handleAppOpenURL:[NSURL URLWithString:@"test://test"]];

	XCTAssertNoThrow([menu verify], @"Verify failed");
}

- (void)testPreferredStatusBarStyle
{
	id drawer = OCMPartialMock(self.drawer);

	id page = OCMPartialMock([[LGRViewController alloc] init]);
	OCMStub([drawer pageController]).andReturn(page);

	OCMStub([page preferredStatusBarStyle]).andReturn(UIStatusBarStyleLightContent);
	UIStatusBarStyle style = [drawer preferredStatusBarStyle];
	XCTAssertEqual(style, UIStatusBarStyleLightContent, @"Should be UIStatusBarStyleLightContent");

	OCMVerify([[drawer pageController] preferredStatusBarStyle]);
}
@end
