//
//  LGRMenuViewControllerTest.m
//  Liger
//
//  Created by John Gustafsson on 11/26/13.
//  Copyright (c) 2013-2014 ReachLocal Inc. All rights reserved.  https://github.com/reachlocal/liger-ios/blob/master/LICENSE
//

@import XCTest;
#import "LGRMenuViewController.h"
#import "OCMock.h"

@interface LGRMenuViewControllerTest : XCTestCase
@property(nonatomic, strong) LGRMenuViewController *menu;
@end

@implementation LGRMenuViewControllerTest

- (void)setUp
{
	[super setUp];
	self.menu = [[LGRMenuViewController alloc] initWithPage:@"testPage" title:nil args:@{}];
}

- (void)testOpenPage
{
	LGRMenuViewController *menu = [OCMockObject partialMockForObject:self.menu];

	menu.displayController = ^(UIViewController* controller){
		XCTAssertNotNil(controller, @"Controller wasn't created for openPage.");
	};
	menu.displayDialog = ^{
		XCTFail(@"Should not be called by an openPage.");
	};
	
	[menu openPage:@"firstPage" title:@"First Page" args:@{} success:^{} fail:^{}];
}

- (void)testClosePage
{
	__weak LGRMenuViewControllerTest *me = self;

	me.menu.displayController = ^(UIViewController* controller){
		XCTFail(@"Should not be called by a closePage.");
	};
	me.menu.displayDialog = ^{
		XCTFail(@"Should not be called by a closePage.");
	};
	
	XCTAssertThrows([self.menu closePage:nil success:^{} fail:^{}], @"Should throw an exception as it's not supposed to be called in a menu.");
}

- (void)testUpdateParent
{
	__weak LGRMenuViewControllerTest *me = self;
	
	me.menu.displayController = ^(UIViewController* controller){
		XCTFail(@"Should not be called by a closePage.");
	};
	me.menu.displayDialog = ^{
		XCTFail(@"Should not be called by a closePage.");
	};
	
	XCTAssertThrows([me.menu updateParent:nil args:@{} success:^{} fail:^{}], @"Should throw an exception as it's not supposed to be called in a menu.");
}

- (void)testOpenDialog
{
	LGRMenuViewController *menu = [[LGRMenuViewController alloc] initWithPage:@"testPage" title:nil args:@{}];
	menu = [OCMockObject partialMockForObject:menu];

	menu.displayController = ^(UIViewController* controller){
		XCTFail(@"Should not be called by an openDialog.");
	};
	menu.displayDialog = ^{
		XCTFail(@"Should not be called as it's stubbed.");
	};

	// The order of expect + stub is important and should be expect then stub
	[[((id)menu) expect] presentViewController:OCMOCK_ANY animated:YES completion:OCMOCK_ANY];
	[[((id)menu) stub] presentViewController:OCMOCK_ANY animated:YES completion:OCMOCK_ANY];
	
	[menu openDialog:@"firstPage" title:@"First Page" args:@{} success:^{} fail:^{}];
	
	XCTAssertNoThrow([(id)menu verify], @"Verify failed");
}

- (void)testCloseDialog
{
	__weak LGRMenuViewControllerTest *me = self;
	
	me.menu.displayController = ^(UIViewController* controller){
		XCTFail(@"Should not be called by a closePage.");
	};
	me.menu.displayDialog = ^{
		XCTFail(@"Should not be called by a closePage.");
	};
	
	XCTAssertThrows([me.menu closeDialog:nil success:^{} fail:^{}], @"Should throw an exception as it's not supposed to be called in a menu.");
}

- (void)testDialogClosed
{
	[self.menu dialogClosed:@{}];
}

- (void)testChildUpdates
{
	LGRViewController *liger = [[LGRMenuViewController alloc] initWithPage:@"testPage" title:nil args:@{@"Updated": @NO}];
	
	XCTAssertEqualObjects(liger.args, @{@"Updated": @NO}, @"Args don't match before call");
	[liger childUpdates:@{@"Updated": @YES}];
	XCTAssertEqualObjects(liger.args, @{@"Updated": @YES}, @"Args don't match after call");
}

- (void)testRefreshPage
{
	[self.menu refreshPage:YES];
	[self.menu refreshPage:NO];
}

- (void)testPageWillAppear
{
	[self.menu pageWillAppear];
}
@end
