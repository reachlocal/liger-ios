//
//  LGRViewControllerTest.m
//  Liger
//
//  Created by John Gustafsson on 11/26/13.
//  Copyright (c) 2013-2014 ReachLocal Inc. All rights reserved.  https://github.com/reachlocal/liger-ios/blob/master/LICENSE
//

@import XCTest;
#import "OCMock.h"
#import "OCPartialMockObject.h"

#import "LGRViewController.h"

@interface LGRViewControllerTest : XCTestCase
@property (nonatomic, strong) LGRViewController *liger;
@end

@implementation LGRViewControllerTest

- (void)setUp
{
	[super setUp];
	self.liger = [[LGRViewController alloc] initWithPage:@"testPage" title:nil args:@{}];
}

- (void)testNativePage
{
	XCTAssertNil([LGRViewController nativePage], @"Base class should not have a native page name");
}

- (void)testInitWithPage
{
	NSDictionary *args = @{@"test": @YES, @"version": @76};
	LGRViewController *liger = [[LGRViewController alloc] initWithPage:@"testPage" title:@"testTitle" args:args];
	
	XCTAssertEqual(liger.page, @"testPage", @"Page name is wrong");
	XCTAssertEqual(liger.title, @"testTitle", @"Title is wrong");
	XCTAssertEqualObjects(liger.args, args, @"Args are wrong");
	XCTAssertNil(liger.ligerParent, @"Parent shouldn't be set");
	XCTAssertFalse(liger.userCanRefresh, @"User refresh should be false as default");
}

- (void)testInitWithPageWithNib
{
	NSDictionary *args = @{@"test": @YES, @"version": @76};
	LGRViewController *liger = [[LGRViewController alloc] initWithPage:@"testPage" title:@"testTitle" args:args nibName:nil bundle:nil];
	
	XCTAssertEqual(liger.page, @"testPage", @"Page name is wrong");
	XCTAssertEqual(liger.title, @"testTitle", @"Title is wrong");
	XCTAssertEqualObjects(liger.args, args, @"Args are wrong");
	XCTAssertNil(liger.ligerParent, @"Parent shouldn't be set");
	XCTAssertFalse(liger.userCanRefresh, @"User refresh should be false as default");
}

- (void)testOpenPage
{
	LGRViewController *liger = [OCMockObject partialMockForObject:self.liger];
	
	id mock = [OCMockObject mockForClass:UINavigationController.class];
	[[[mock stub] andReturn:[((OCPartialMockObject*)liger) realObject]] topViewController];
	[[mock expect] pushViewController:OCMOCK_ANY animated:YES];
	[[[((id)liger) stub] andReturn:mock] navigationController];

	[liger openPage:@"firstPage" title:@"First Page" args:@{} success:^{} fail:^{}];
	
	XCTAssertNoThrow([mock verify], @"Verify failed");
}

- (void)testUpdateParent
{
	LGRViewController *liger = [OCMockObject partialMockForObject:self.liger];

	id mock = [OCMockObject mockForClass:LGRViewController.class];
	[[mock expect] childUpdates:OCMOCK_ANY];
	[[[((id)liger) stub] andReturn:mock] ligerParent];
	
	[liger updateParent:nil args:@{} success:^{} fail:^{}];
	
	XCTAssertNoThrow([mock verify], @"Verify failed");
}

- (void)testUpdateParentDestination
{
	id liger = [OCMockObject partialMockForObject:self.liger];

	id test2 = [OCMockObject partialMockForObject:[[LGRViewController alloc] initWithPage:@"test2" title:@"" args:@{}]];
	id test = [OCMockObject partialMockForObject:[[LGRViewController alloc] initWithPage:@"test" title:@"" args:@{}]];

	[[[liger stub] andReturn:test2] ligerParent];
	[[[test2 stub] andReturn:test] ligerParent];
	[[test expect] childUpdates:OCMOCK_ANY];

	[liger updateParent:@"test" args:@{} success:^{} fail:^{}];

	XCTAssertNoThrow([test verify], @"Verify failed");
}

- (void)testClosePage
{
	LGRViewController *liger = [OCMockObject partialMockForObject:self.liger];
	
	id mock = [OCMockObject mockForClass:UINavigationController.class];
	[[[mock expect] ignoringNonObjectArgs] popViewControllerAnimated:YES];
	[[[((id)liger) stub] andReturn:mock] navigationController];
	
	[liger closePage:nil success:^{} fail:^{}];
	
	XCTAssertNoThrow([mock verify], @"Verify failed");
}

- (void)testClosePageRewind
{
	id liger = [OCMockObject partialMockForObject:self.liger];

	id test2 = [OCMockObject partialMockForObject:[[LGRViewController alloc] initWithPage:@"test2" title:@"" args:@{}]];
	id test = [OCMockObject partialMockForObject:[[LGRViewController alloc] initWithPage:@"test" title:@"" args:@{}]];

	[[[liger stub] andReturn:test2] ligerParent];
	[[[test2 stub] andReturn:test] ligerParent];

	id mock = [OCMockObject mockForClass:UINavigationController.class];
	[[[mock expect] ignoringNonObjectArgs] popToViewController:OCMOCK_ANY animated:YES];
	[[[((id)liger) stub] andReturn:mock] navigationController];

	[liger closePage:@"test" success:^{} fail:^{}];

	XCTAssertNoThrow([mock verify], @"Verify failed");
}

- (void)testOpenDialog
{
	LGRViewController *liger = [OCMockObject partialMockForObject:self.liger];
	
	// The order of expect + stub is important and should be expect then stub
	[[((id)liger) expect] presentViewController:OCMOCK_ANY animated:YES completion:OCMOCK_ANY];
	[[((id)liger) stub] presentViewController:OCMOCK_ANY animated:YES completion:OCMOCK_ANY];
	
	[liger openDialog:@"firstPage" title:@"First Page" args:@{} success:^{} fail:^{}];
	
	XCTAssertNoThrow([(id)liger verify], @"Verify failed");
}

- (void)testCloseDialog
{
	LGRViewController *liger = [OCMockObject partialMockForObject:self.liger];
	
	id mock = [OCMockObject mockForClass:UINavigationController.class];
	[[mock expect] dismissViewControllerAnimated:YES completion:OCMOCK_ANY];
	[[[((id)liger) stub] andReturn:mock] presentingViewController];

	[liger closeDialog:nil success:^{} fail:^{}];

	XCTAssertNoThrow([(id)liger verify], @"Verify failed");
}

- (void)testDialogClosed
{
	[self.liger dialogClosed:@{}];
}

- (void)testChildUpdates
{
	LGRViewController *liger = [[LGRViewController alloc] initWithPage:@"testPage" title:nil args:@{@"Updated": @NO}];

	XCTAssertEqualObjects(liger.args, @{@"Updated": @NO}, @"Args don't match before call");
	[liger childUpdates:@{@"Updated": @YES}];
	XCTAssertEqualObjects(liger.args, @{@"Updated": @YES}, @"Args don't match after call");
}

- (void)testRefreshPage
{
	[self.liger refreshPage:YES];
	[self.liger refreshPage:NO];
}

- (void)testPageWillAppear
{
	[self.liger pageWillAppear];
}

- (void)testUserCanRefresh
{
	XCTAssertEqual(self.liger.userCanRefresh, NO, @"Should be NO.");
	self.liger.userCanRefresh = YES;
	XCTAssertEqual(self.liger.userCanRefresh, YES, @"Should be YES.");
	self.liger.userCanRefresh = NO;
	XCTAssertEqual(self.liger.userCanRefresh, NO, @"Should be NO.");
}

- (void)testPushNotificationTokenUpdatedError
{
	[self.liger pushNotificationTokenUpdated:@"" error:nil];
}

- (void)testNotificationArrivedBackground
{
	[self.liger notificationArrived:@{} background:NO];
}

- (void)testHandleAppOpenURL
{
	[self.liger handleAppOpenURL:[NSURL URLWithString:@"http://www.liger.com"]];
}

@end
