//
//  LGRTabContainerControllerTest.m
//  LigerMobile
//
//  Created by John Gustafsson on 11/25/13.
//  Copyright (c) 2013-2015 ReachLocal Inc. All rights reserved.  https://github.com/reachlocal/liger-ios/blob/master/LICENSE
//

@import XCTest;

#import "LGRTabContainerController.h"
#import "LGRPageFactory.h"
#import "LGRApp.h"

#import "OCMock.h"

@interface LGRTabContainerController ()
@property (nonatomic, strong) LGRViewController *tab;
- (LGRViewController*)pageController;
- (void)displayController:(LGRViewController*)controller;
@end

@interface LGRTabContainerControllerTest : XCTestCase
@property(nonatomic, strong) LGRTabContainerController *tabContainer;
@end

@implementation LGRTabContainerControllerTest

- (void)setUp
{
	NSDictionary *args = @{@"page": @"appMenu",
						   @"accessibilityLabel": @"menu",
						   @"args": @{
								   @"menu": @[@[@{
												  @"title": @"First Page",
												  @"page": @"firstPage",
												  @"accessibilityLabel": @"firstPage",
												  @"args": @{
													  @"hello": @"world"
													  }
												  }
												  ],@[
												  ]]}};
	UIViewController* tabContainer = [LGRPageFactory controllerForPage:@"tabcontainer" title:@"" args:args options:@{} parent:nil];
	XCTAssertTrue([tabContainer isKindOfClass:LGRTabContainerController.class], @"TabContainer page creation failed.");

	self.tabContainer = (LGRTabContainerController*)tabContainer;
	XCTAssert(self.tabContainer.view, @"tabContainer has no view");

	[super setUp];
}

- (void)tearDown
{
	[super tearDown];
}

- (void)testResetApp
{
	[self.tabContainer resetApp];

	XCTAssert(self.tabContainer.childViewControllers.count == 2, @"Wrong number of child controllers.");
}

- (void)testNativePage
{
	XCTAssertTrue([[LGRTabContainerController nativePage] isEqualToString:@"tabcontainer"], @"Native page wasn't named tabcontainer");
}

- (void)testOpenPage
{
	id tabContainer = OCMPartialMock(self.tabContainer);
	OCMExpect([tabContainer displayController:OCMOCK_ANY]);
	__block BOOL succeeded = NO;

	[tabContainer openPage:@"firstPage" title:@"First Page" args:@{} options:@{@"reuseIdentifier":@"one"} parent:tabContainer success:^{
		succeeded = YES;
	} fail:^{}];

	XCTAssertTrue(succeeded, @"success() wasn't called.");
	OCMVerifyAll(tabContainer);
}

- (void)testOpenPageInternalFail1
{
	id tabContainer = OCMPartialMock(self.tabContainer);
	__block BOOL failed = NO;

	[tabContainer openPage:@"that_does't_exist" title:@"First Page" args:@{} options:@{} parent:tabContainer success:^{} fail:^{
		failed = YES;
	}];

	XCTAssertTrue(failed, @"fail() wasn't called.");
}

- (void)testOpenDialog
{
	id tabContainer = OCMPartialMock(self.tabContainer);
	OCMExpect([tabContainer presentViewController:OCMOCK_ANY animated:YES completion:OCMOCK_ANY]).andDo(^(NSInvocation *invocation){
		void (^completion)(void) = nil;
		[invocation getArgument:&completion atIndex:4];

		completion();
	});

	__block BOOL success = NO;

	[tabContainer openDialog:@"firstPage" title:@"First Page" args:@{} options:@{} parent:nil success:^{
		success = YES;
	} fail:^{}];

	XCTAssertTrue(success, @"success() wasn't called.");
}

- (void)testPushNotificationTokenUpdatedError
{
	id tab = [OCMockObject partialMockForObject:self.tabContainer.tab];
	[[tab expect] pushNotificationTokenUpdated:OCMOCK_ANY error:OCMOCK_ANY];

	id tabContainer = [OCMockObject partialMockForObject:self.tabContainer];
	[[[tabContainer stub] andReturn:tab] tab];

	[tabContainer pushNotificationTokenUpdated:nil error:nil];

	XCTAssertNoThrow([tab verify], @"Verify failed");
}

- (void)testNotificationArrivedBackground
{
	id tab = [OCMockObject partialMockForObject:self.tabContainer.tab];
	[[tab expect] notificationArrived:OCMOCK_ANY background:YES];

	id tabContainer = [OCMockObject partialMockForObject:self.tabContainer];
	[[[tabContainer stub] andReturn:tab] tab];

	[tabContainer notificationArrived:@{} background:YES];

	XCTAssertNoThrow([tab verify], @"Verify failed");
}

- (void)testHandleAppOpenURL
{
	id tab = [OCMockObject partialMockForObject:self.tabContainer.tab];
	[[tab expect] handleAppOpenURL:[NSURL URLWithString:@"test://test"]];

	id tabContainer = [OCMockObject partialMockForObject:self.tabContainer];
	[[[tabContainer stub] andReturn:tab] tab];

	[tabContainer handleAppOpenURL:[NSURL URLWithString:@"test://test"]];

	XCTAssertNoThrow([tab verify], @"Verify failed");
}

- (void)testPreferredStatusBarStyle
{
	id tabContainer = OCMPartialMock(self.tabContainer);

	id page = OCMPartialMock([[LGRViewController alloc] init]);
	OCMStub([tabContainer pageController]).andReturn(page);

	OCMStub([page preferredStatusBarStyle]).andReturn(UIStatusBarStyleLightContent);
	UIStatusBarStyle style = [tabContainer preferredStatusBarStyle];
	XCTAssertEqual(style, UIStatusBarStyleLightContent, @"Should be UIStatusBarStyleLightContent");

	OCMVerify([[tabContainer pageController] preferredStatusBarStyle]);
}
@end
