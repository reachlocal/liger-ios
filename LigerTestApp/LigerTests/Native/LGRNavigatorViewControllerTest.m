//
//  LGRNavigatorViewControllerTest.m
// LigerMobile
//
//  Created by John Gustafsson on 7/22/14.
//  Copyright (c) 2013-2014 ReachLocal Inc. All rights reserved.  https://github.com/reachlocal/liger-ios/blob/master/LICENSE
//

#import <XCTest/XCTest.h>
#import "LGRNavigatorViewController.h"
#import <OCMock.h>

@interface LGRNavigatorViewController ()
@property(nonatomic, strong) UINavigationController *navigator;
@end

@interface LGRNavigatorViewControllerTest : XCTestCase
@property(nonatomic, strong) LGRNavigatorViewController *navigator;
@end

@implementation LGRNavigatorViewControllerTest

- (void)setUp
{
    [super setUp];
	self.navigator = [[LGRNavigatorViewController alloc] initWithPage:@"navigator"
																title:@"Title"
																 args:@{}
															  options:@{}];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testInit
{
	XCTAssertNotNil([[LGRNavigatorViewController alloc] init], @"Didn't init");
}

- (void)testNativePage
{
	XCTAssertEqualObjects([LGRNavigatorViewController nativePage], @"navigator", @"Name of page changed");
}

- (void)testInitWithPage
{
	id navigator = [[LGRNavigatorViewController alloc] initWithPage:@"navigator"
															  title:@"Title"
															   args:@{}
															options:@{}];

	XCTAssertNotNil(navigator, @"Navigator failed to instatiate");
}

- (void)testViewDidLoad
{
	id navigator = OCMPartialMock(self.navigator);

	[navigator viewDidLoad];

	XCTAssertNotNil([navigator navigator], @"No navigator created");
}

- (void)testOpenPage
{
	id navigator = OCMPartialMock(self.navigator);
	id navigationController = OCMClassMock(UINavigationController.class);
	OCMStub([navigationController topViewController]).andReturn(navigator);
	OCMStub([navigator navigator]).andReturn(navigationController);

	OCMExpect([navigationController pushViewController:OCMOCK_ANY animated:YES]);

	__block BOOL succeeded = NO;

	[navigator openPage:@"firstPage" title:@"First Page" args:@{} options:@{} parent:navigator success:^{
		succeeded = YES;
	} fail:^{}];

	XCTAssertTrue(succeeded, @"success() wasn't called.");
	OCMVerifyAll(navigationController);
}

- (void)testOpenPageInternalFail1
{
	id navigator = OCMPartialMock(self.navigator);
	OCMStub([navigator navigator]).andReturn(nil);

	__block BOOL failed = NO;

	[navigator openPage:@"firstPage" title:@"First Page" args:@{} options:@{} parent:nil success:^{} fail:^{
		failed = YES;
	}];

	XCTAssertTrue(failed, @"fail() wasn't called.");
}

- (void)testOpenPageInternalFail2
{
	id navigator = OCMPartialMock(self.navigator);
	id mock = OCMClassMock(UINavigationController.class);
	OCMStub([mock topViewController]).andReturn(navigator);
	OCMStub([navigator navigator]).andReturn(mock);

	__block BOOL failed = NO;

	[navigator openPage:@"that_does't_exist" title:@"First Page" args:@{} options:@{} parent:navigator success:^{} fail:^{
		failed = YES;
	}];

	XCTAssertTrue(failed, @"fail() wasn't called.");
}

- (void)testOpenDialog
{
	id navigator = OCMPartialMock(self.navigator);
	OCMExpect([navigator presentViewController:OCMOCK_ANY animated:YES completion:OCMOCK_ANY]).andDo(^(NSInvocation *invocation){
		void (^completion)(void) = nil;
		[invocation getArgument:&completion atIndex:4];

		completion();
	});

	__block BOOL success = NO;

	[navigator openDialog:@"firstPage" title:@"First Page" args:@{} options:@{} parent:nil success:^{
		success = YES;
	} fail:^{}];

	XCTAssertTrue(success, @"success() wasn't called.");
}

- (void)testOpenDialogInternalFail1
{
	id navigator = OCMPartialMock(self.navigator);

	__block BOOL failed = NO;

	[navigator openDialog:@"that_does't_exist" title:@"First Page" args:@{} options:@{} parent:nil success:^{} fail:^{
		failed = YES;
	}];

	XCTAssertTrue(failed, @"fail() wasn't called.");
}

- (void)testDialogClosed
{
	id navigator = OCMPartialMock(self.navigator);
	id page = OCMPartialMock([[LGRViewController alloc] init]);
	OCMExpect([page dialogClosed:nil]);
	OCMStub([navigator parentPage]).andReturn(page);
	[navigator dialogClosed:nil];

	OCMVerifyAll(page);
}

@end
