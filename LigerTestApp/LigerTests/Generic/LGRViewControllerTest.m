//
//  LGRViewControllerTest.m
//  LigerMobile
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
#import "LGRPageFactory.h"
#import "LGRAppearance.h"

@interface LGRViewController()
- (void)addButtons;
- (UIBarButtonItem*)buttonFromDictionary:(NSDictionary*)buttonInfo;
- (void)buttonAction:(id)sender;
@end

@interface LGRViewControllerTest : XCTestCase
@property (nonatomic, strong) LGRViewController *ligerViewController;
@end

@implementation LGRViewControllerTest

- (void)setUp
{
	[super setUp];
	self.ligerViewController = [[LGRViewController alloc] initWithPage:@"testPage" title:nil args:@{} options:@{}];
}

- (void)testNativePage
{
	XCTAssertNil([LGRViewController nativePage], @"Base class should not have a native page name");
}

- (void)testInitWithPage
{
	NSDictionary *args = @{@"test": @YES, @"version": @76};
	NSDictionary *options = @{@"test": @"test"};
	LGRViewController *ligerViewController = [[LGRViewController alloc] initWithPage:@"testPage" title:@"testTitle" args:args options:options];
	
	XCTAssertEqual(ligerViewController.page, @"testPage", @"Page name is wrong");
	XCTAssertEqual(ligerViewController.title, @"testTitle", @"Title is wrong");
	XCTAssertEqualObjects(ligerViewController.args, args, @"Args are wrong");
	XCTAssertEqualObjects(ligerViewController.options, options, @"Options are wrong");
	XCTAssertNil(ligerViewController.parentPage, @"Parent shouldn't be set");
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
	NSArray *buttons = @[@{@"button":@"done"},
			     @{@"button":@"cancel"},
			     @{@"button":@"edit"},
			     @{@"button":@"save"},
			     @{@"button":@"add"},
			     @{@"button":@"compose"},
			     @{@"button":@"reply"},
			     @{@"button":@"action"},
			     @{@"button":@"organize"},
			     @{@"button":@"bookmarks"},
			     @{@"button":@"search"},
			     @{@"button":@"refresh"},
			     @{@"button":@"stop"},
			     @{@"button":@"camera"},
			     @{@"button":@"trash"},
			     @{@"button":@"play"},
			     @{@"button":@"pause"},
			     @{@"button":@"rewind"},
			     @{@"button":@"forward"},
			     @{@"button":@"undo"},
			     @{@"button":@"redo"},
			     @{@"button":@"TESTING"}
			     ];

	for (NSDictionary* button in buttons) {
		// UIBarButtonItem doesn't give access to the system button type so we can't test that
		XCTAssertNotNil([self.ligerViewController buttonFromDictionary:button], @"Button failed to instantiate.");
	}
}

- (void)testButtonAction
{
	id liger = OCMPartialMock(self.ligerViewController);
	OCMExpect([liger buttonTapped:nil]);
	[liger buttonAction:nil];

	OCMVerifyAll(liger);
}

- (void)testButtonTapped
{
	id liger = OCMPartialMock(self.ligerViewController);

	[liger buttonTapped:nil];
}

- (void)testOpenPage
{
	id page = OCMPartialMock(self.ligerViewController);
	id collection = OCMPartialMock([[LGRViewController alloc] initWithPage:@"" title:@"" args:@{} options:@{}]);
	OCMExpect([collection openPage:@"firstPage" title:@"First Page" args:@{} options:@{} parent:nil success:OCMOCK_ANY fail:OCMOCK_ANY]);

	OCMStub([page collectionPage]).andReturn(collection);

	[page openPage:@"firstPage" title:@"First Page" args:@{} options:@{} parent:nil success:^{} fail:^{}];

	OCMVerifyAll(collection);
}

- (void)testUpdateParent
{
	LGRViewController *liger = [OCMockObject partialMockForObject:self.ligerViewController];

	id mock = [OCMockObject mockForClass:LGRViewController.class];
	[[mock expect] childUpdates:OCMOCK_ANY];
	[[[((id)liger) stub] andReturn:mock] parentPage];
	
	[liger updateParent:nil args:@{} success:^{} fail:^{}];
	
	XCTAssertNoThrow([mock verify], @"Verify failed");
}

- (void)testUpdateParentDestination
{
	id liger = [OCMockObject partialMockForObject:self.ligerViewController];

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
	id page = OCMPartialMock(self.ligerViewController);
	id collection = OCMPartialMock([[LGRViewController alloc] init]);

	OCMExpect([collection closePage:nil sourcePage:self.ligerViewController success:OCMOCK_ANY fail:OCMOCK_ANY]);
	OCMStub([page collectionPage]).andReturn(collection);

	[page closePage:nil success:^{} fail:^{}];

	OCMVerifyAll(collection);
}

- (void)testClosePageWithSource
{
	id page = OCMPartialMock(self.ligerViewController);

	[page closePage:nil sourcePage:nil success:^{} fail:^{}];
}

- (void)testOpenDialog
{
	id page = OCMPartialMock(self.ligerViewController);
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

- (void)testOpenDialogWithoutCollection
{
	id page = OCMPartialMock(self.ligerViewController);
	OCMExpect([page presentViewController:OCMOCK_ANY animated:YES completion:OCMOCK_ANY]).andDo(^(NSInvocation *invocation){
		void (^completion)(void) = nil;
		[invocation getArgument:&completion atIndex:4];

		completion();
	});

	OCMStub([page collectionPage]).andReturn(nil);

	[page openDialog:@"firstPage" title:@"First Page" args:@{} options:@{} parent:nil success:^{} fail:^{}];

	OCMVerifyAll(page);
}

- (void)testOpenDialogWithoutCollectionAndFail
{
	id page = OCMPartialMock(self.ligerViewController);
	id factory = OCMClassMock(LGRPageFactory.class);

	OCMExpect([factory controllerForPage:OCMOCK_ANY title:OCMOCK_ANY args:OCMOCK_ANY options:OCMOCK_ANY parent:OCMOCK_ANY]).andReturn(nil);
//	.andDo(^(NSInvocation * invocation){
//		void* arg = nil;
//		[invocation getArgument:&arg atIndex:4];
//		NSDictionary *d = (NSDictionary*)(__bridge id)(arg);
//		dict = d.copy;
//	}).andReturn(self.delegate.rootPage);

	OCMStub([page collectionPage]).andReturn(nil);

	__block BOOL fail = NO;
	[page openDialog:@"firstPage" title:@"First Page" args:@{} options:@{} parent:nil success:^{} fail:^{
		fail = YES;
	}];

	[factory stopMocking];
	OCMVerifyAll(factory);
	XCTAssertTrue(fail, @"openDialog should fail.");
}
- (void)testCloseDialog
{
	id page = OCMPartialMock(self.ligerViewController);

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
	id page = OCMPartialMock(self.ligerViewController);

	id realApp = OCMPartialMock([UIApplication sharedApplication]);
	id app = OCMClassMock(UIApplication.class);
	OCMStub([app sharedApplication]).andReturn(realApp);

	id delegate = OCMPartialMock([realApp delegate]);
	OCMStub([realApp delegate]).andReturn(delegate);

	id rootPage = OCMPartialMock([delegate rootPage]);
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
	id liger = OCMPartialMock(self.ligerViewController);

	OCMStub([liger presentingViewController]).andReturn(nil);

	__block BOOL failed = NO;
	[liger closeDialog:nil success:^{} fail:^{
		failed = YES;
	}];

	XCTAssertTrue(failed, @"fail() wasn't called.");
}

- (void)testDialogClosed
{
	[self.ligerViewController dialogClosed:@{}];
}

- (void)testChildUpdates
{
	LGRViewController *liger = [[LGRViewController alloc] initWithPage:@"testPage" title:nil args:@{@"Updated": @NO} options:@{}];

	XCTAssertEqualObjects(liger.args, @{@"Updated": @NO}, @"Args don't match before call");
	[liger childUpdates:@{@"Updated": @YES}];
	XCTAssertEqualObjects(liger.args, @{@"Updated": @YES}, @"Args don't match after call");
}

- (void)testPageWillAppear
{
	[self.ligerViewController pageWillAppear];
}

- (void)testPushNotificationTokenUpdatedError
{
	[self.ligerViewController pushNotificationTokenUpdated:@"" error:nil];
}

- (void)testNotificationArrivedState
{
	[self.ligerViewController notificationArrived:@{}state:UIApplicationStateBackground];
}

- (void)testHandleAppOpenURL
{
	[self.ligerViewController handleAppOpenURL:[NSURL URLWithString:@"http://reachlocal.github.io/liger/"]];
}

- (void)testPreferredStatusBarStyleLight
{
	id appearance = OCMClassMock(LGRAppearance.class);
	OCMStub([appearance statusBar]).andReturn(UIStatusBarStyleDefault);

	LGRViewController* ligerViewController = OCMPartialMock(self.ligerViewController);
	NSDictionary *options = @{@"statusBar": @"light"};
	OCMStub([ligerViewController options]).andReturn(options);

	UIStatusBarStyle style = [ligerViewController preferredStatusBarStyle];
	XCTAssertEqual(style, UIStatusBarStyleLightContent, @"Wrong status bar style");
}

- (void)testPreferredStatusBarStyleDark
{
	id appearance = OCMClassMock(LGRAppearance.class);
	OCMStub([appearance statusBar]).andReturn(UIStatusBarStyleLightContent);

	LGRViewController* ligerViewController = OCMPartialMock(self.ligerViewController);
	NSDictionary *options = @{@"statusBar": @"DARK"};
	OCMStub([ligerViewController options]).andReturn(options);

	UIStatusBarStyle style = [ligerViewController preferredStatusBarStyle];
	XCTAssertEqual(style, UIStatusBarStyleDefault, @"Wrong status bar style");
}

- (void)testPreferredStatusBarStyleAppearance
{
	id appearance = OCMClassMock(LGRAppearance.class);
	OCMStub([appearance statusBar]).andReturn(UIStatusBarStyleLightContent);

	LGRViewController* ligerViewController = OCMPartialMock(self.ligerViewController);
	NSDictionary *options = @{};
	OCMStub([ligerViewController options]).andReturn(options);

	UIStatusBarStyle style = [ligerViewController preferredStatusBarStyle];
	XCTAssertEqual(style, UIStatusBarStyleLightContent, @"Wrong status bar style");
}

- (void)testPreferredStatusBarStyleLightDialog
{
	id appearance = OCMClassMock(LGRAppearance.class);
	OCMStub([appearance statusBarDialog]).andReturn(UIStatusBarStyleLightContent);

	LGRViewController* ligerViewController = OCMPartialMock(self.ligerViewController);
	NSDictionary *options = @{@"statusBarDialog": @"light"};
	OCMStub([ligerViewController options]).andReturn(options);
	OCMStub([ligerViewController presentingViewController]).andReturn(self.ligerViewController);

	UIStatusBarStyle style = [ligerViewController preferredStatusBarStyle];
	XCTAssertEqual(style, UIStatusBarStyleLightContent, @"Wrong status bar style");
}

- (void)testPreferredStatusBarStyleDarkDialog
{
	id appearance = OCMClassMock(LGRAppearance.class);
	OCMStub([appearance statusBarDialog]).andReturn(UIStatusBarStyleDefault);

	LGRViewController* ligerViewController = OCMPartialMock(self.ligerViewController);
	NSDictionary *options = @{@"statusBarDialog": @"DARK"};
	OCMStub([ligerViewController options]).andReturn(options);
	OCMStub([ligerViewController presentingViewController]).andReturn(self.ligerViewController);

	UIStatusBarStyle style = [ligerViewController preferredStatusBarStyle];
	XCTAssertEqual(style, UIStatusBarStyleDefault, @"Wrong status bar style");
}

- (void)testPreferredStatusBarStyleAppearanceDialog
{
	id appearance = OCMClassMock(LGRAppearance.class);
	OCMStub([appearance statusBarDialog]).andReturn(UIStatusBarStyleLightContent);

	LGRViewController* ligerViewController = OCMPartialMock(self.ligerViewController);
	NSDictionary *options = @{};
	OCMStub([ligerViewController options]).andReturn(options);
	OCMStub([ligerViewController presentingViewController]).andReturn(self.ligerViewController);

	UIStatusBarStyle style = [ligerViewController preferredStatusBarStyle];
	XCTAssertEqual(style, UIStatusBarStyleLightContent, @"Wrong status bar style");
}
@end
