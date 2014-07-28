//
//  LGRViewControllerTest.m
// LigerMobile
//
//  Created by John Gustafsson on 11/26/13.
//  Copyright (c) 2013-2014 ReachLocal Inc. All rights reserved.  https://github.com/reachlocal/liger-ios/blob/master/LICENSE
//

@import XCTest;
#import "OCMock.h"
#import <OCMock/OCMockObject.h>

#import "LGRAppDelegate.h"
#import "LGRDrawerViewController.h"
#import "LGRViewController.h"

@interface LGRViewController()
- (void)addButtons;
- (UIBarButtonItem*)buttonFromDictionary:(NSDictionary*)buttonInfo;
- (void)buttonAction:(id)sender;
@end

@interface LGRViewControllerTest : XCTestCase
@property (nonatomic, strong) LGRViewController *liger;
@end

@implementation LGRViewControllerTest

- (void)setUp
{
	[super setUp];
	self.liger = [[LGRViewController alloc] initWithPage:@"testPage" title:nil args:@{} options:@{}];
}

- (void)testNativePage
{
	XCTAssertNil([LGRViewController nativePage], @"Base class should not have a native page name");
}

- (void)testInitWithPage
{
	NSDictionary *args = @{@"test": @YES, @"version": @76};
	NSDictionary *options = @{@"test": @"test"};
	LGRViewController *liger = [[LGRViewController alloc] initWithPage:@"testPage" title:@"testTitle" args:args options:options];
	
	XCTAssertEqual(liger.page, @"testPage", @"Page name is wrong");
	XCTAssertEqual(liger.title, @"testTitle", @"Title is wrong");
	XCTAssertEqualObjects(liger.args, args, @"Args are wrong");
	XCTAssertEqualObjects(liger.options, options, @"Options are wrong");
	XCTAssertNil(liger.parentPage, @"Parent shouldn't be set");
	XCTAssertFalse(liger.userCanRefresh, @"User refresh should be false as default");
}

- (void)testInitWithPageWithNib
{
	NSDictionary *args = @{@"test": @YES, @"version": @76};
	NSDictionary *options = @{@"test": @"test"};
	LGRViewController *liger = [[LGRViewController alloc] initWithPage:@"testPage" title:@"testTitle" args:args options:options nibName:nil bundle:nil];
	
	XCTAssertEqual(liger.page, @"testPage", @"Page name is wrong");
	XCTAssertEqual(liger.title, @"testTitle", @"Title is wrong");
	XCTAssertEqualObjects(liger.args, args, @"Args are wrong");
	XCTAssertEqualObjects(liger.options, options, @"Options are wrong");
	XCTAssertNil(liger.parentPage, @"Parent shouldn't be set");
	XCTAssertFalse(liger.userCanRefresh, @"User refresh should be false as default");
}

- (void)testAddButtons
{
	LGRViewController* liger = [[LGRViewController alloc] initWithPage:@"testPage" title:nil args:@{} options:@{@"left": @{@"button": @"done"}, @"right": @{@"button": @"done"}}];

	[liger addButtons];
	XCTAssertNotNil(liger.navigationItem.leftBarButtonItem, @"No left button");
	XCTAssertNotNil(liger.navigationItem.rightBarButtonItem, @"No right button");
}

- (void)testButtonFromDictionary
{
	NSArray *buttons = @[@{@"button":@"done"}, @{@"button":@"cancel"}, @{@"button":@"save"}, @{@"button":@"search"}];

	for (NSDictionary* button in buttons) {
		// UIBarButtonItem doesn't give access to the system button type so we can't test that
		XCTAssertNotNil([self.liger buttonFromDictionary:button], @"Button failed to instantiate.");
	}
}

- (void)testButtonAction
{
	id liger = OCMPartialMock(self.liger);
	OCMExpect([liger buttonTapped:nil]);
	[liger buttonAction:nil];

	OCMVerifyAll(liger);
}

- (void)testButtonTapped
{
	id liger = OCMPartialMock(self.liger);

	[liger buttonTapped:nil];
}

- (void)testOpenPage
{
	id page = OCMPartialMock(self.liger);
	id collection = OCMPartialMock([[LGRViewController alloc] initWithPage:@"" title:@"" args:@{} options:@{}]);
	OCMExpect([collection openPage:@"firstPage" title:@"First Page" args:@{} options:@{} parent:nil success:OCMOCK_ANY fail:OCMOCK_ANY]);

	OCMStub([page collectionPage]).andReturn(collection);

	[page openPage:@"firstPage" title:@"First Page" args:@{} options:@{} parent:nil success:^{} fail:^{}];

	OCMVerifyAll(collection);
}

- (void)testUpdateParent
{
	LGRViewController *liger = [OCMockObject partialMockForObject:self.liger];

	id mock = [OCMockObject mockForClass:LGRViewController.class];
	[[mock expect] childUpdates:OCMOCK_ANY];
	[[[((id)liger) stub] andReturn:mock] parentPage];
	
	[liger updateParent:nil args:@{} success:^{} fail:^{}];
	
	XCTAssertNoThrow([mock verify], @"Verify failed");
}

- (void)testUpdateParentDestination
{
	id liger = [OCMockObject partialMockForObject:self.liger];

	id test2 = [OCMockObject partialMockForObject:[[LGRViewController alloc] initWithPage:@"test2" title:@"" args:@{} options:@{}]];
	id test = [OCMockObject partialMockForObject:[[LGRViewController alloc] initWithPage:@"test" title:@"" args:@{} options:@{}]];

	[[[liger stub] andReturn:test2] parentPage];
	[[[test2 stub] andReturn:test] parentPage];
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

- (void)testClosePageInternalFail
{
	id liger = OCMPartialMock(self.liger);
	OCMStub([liger navigationController]).andReturn(nil);

	__block BOOL failed = NO;

	[liger closePage:nil success:^{} fail:^{
		failed = YES;
	}];

	XCTAssertTrue(failed, @"fail() wasn't called.");
}

- (void)testClosePageRewind
{
	id liger = [OCMockObject partialMockForObject:self.liger];

	id test2 = [OCMockObject partialMockForObject:[[LGRViewController alloc] initWithPage:@"test2" title:@"" args:@{} options:@{}]];
	id test = [OCMockObject partialMockForObject:[[LGRViewController alloc] initWithPage:@"test" title:@"" args:@{} options:@{}]];

	[[[liger stub] andReturn:test2] parentPage];
	[[[test2 stub] andReturn:test] parentPage];

	id mock = [OCMockObject mockForClass:UINavigationController.class];
	[[[mock expect] ignoringNonObjectArgs] popToViewController:OCMOCK_ANY animated:YES];
	[[[((id)liger) stub] andReturn:mock] navigationController];

	[liger closePage:@"test" success:^{} fail:^{}];

	XCTAssertNoThrow([mock verify], @"Verify failed");
}

- (void)testOpenDialog
{
	id page = OCMPartialMock(self.liger);
	id collection = OCMPartialMock([[LGRViewController alloc] init]);

	OCMExpect([collection openDialog:@"firstPage"
							   title:@"First Page"
								args:@{}
							 options:@{}
							  parent:nil
							 success:OCMOCK_ANY
								fail:OCMOCK_ANY]);
	OCMStub([page collectionPage]).andReturn(collection);

	[page openDialog:@"firstPage" title:@"First Page" args:@{} options:@{} parent:nil success:^{} fail:^{}];

	OCMVerifyAll(collection);
}

- (void)testCloseDialog
{
	id page = OCMPartialMock(self.liger);

	id presenting = OCMPartialMock([[LGRViewController alloc] init]);
	OCMExpect([presenting dismissViewControllerAnimated:YES completion:OCMOCK_ANY]).andDo(^(NSInvocation *invocation){
		void (^completion)(void) = nil;
		[invocation getArgument:&completion atIndex:3];

		completion();

	});
	OCMStub([page presentingViewController]).andReturn(presenting);

	id parent = OCMPartialMock([[LGRViewController alloc] init]);
	OCMExpect([parent dialogClosed:nil]);
	OCMStub([page parentPage]).andReturn(parent);


	[page closeDialog:nil success:^{} fail:^{}];

	OCMVerifyAll(presenting);
	OCMVerifyAll(parent);
}

- (void)testCloseDialogAndReset
{
	id page = OCMPartialMock(self.liger);

	id realApp = OCMPartialMock([UIApplication sharedApplication]);
	id app = OCMClassMock(UIApplication.class);
	OCMStub([app sharedApplication]).andReturn(realApp);

	id delegate = OCMPartialMock([realApp delegate]);
	OCMStub([realApp delegate]).andReturn(delegate);

	id rootPage = OCMPartialMock([[realApp delegate] rootPage]);
	OCMStub([delegate rootPage]).andReturn(rootPage);

	OCMExpect([rootPage resetApp]);

	id presenting = OCMPartialMock([[LGRViewController alloc] init]);
	OCMExpect([presenting dismissViewControllerAnimated:YES completion:OCMOCK_ANY]).andDo(^(NSInvocation *invocation){
		void (^completion)(void) = nil;
		[invocation getArgument:&completion atIndex:3];

		completion();

	});
	OCMStub([page presentingViewController]).andReturn(presenting);

	[page closeDialog:@{@"resetApp": @YES} success:^{} fail:^{}];

	OCMVerifyAll(rootPage);
	OCMVerifyAll(presenting);
}

- (void)testCloseDialogInternalFail
{
	id liger = OCMPartialMock(self.liger);

	OCMStub([liger presentingViewController]).andReturn(nil);

	__block BOOL failed = NO;
	[liger closeDialog:nil success:^{} fail:^{
		failed = YES;
	}];

	XCTAssertTrue(failed, @"fail() wasn't called.");
}

- (void)testDialogClosed
{
	[self.liger dialogClosed:@{}];
}

- (void)testChildUpdates
{
	LGRViewController *liger = [[LGRViewController alloc] initWithPage:@"testPage" title:nil args:@{@"Updated": @NO} options:@{}];

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
