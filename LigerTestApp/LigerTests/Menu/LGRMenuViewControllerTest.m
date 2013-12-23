//
//  LGRMenuViewControllerTest.m
//  Liger
//
//  Created by John Gustafsson on 11/26/13.
//  Copyright (c) 2013 John Gustafsson. All rights reserved.
//

@import XCTest;
#import "LGRMenuViewController.h"
#import "OCMock.h"

@interface LGRMenuViewControllerTest : XCTestCase

@end

@implementation LGRMenuViewControllerTest

- (void)testOpenPage
{
	LGRMenuViewController *menu = [[LGRMenuViewController alloc] initWithPage:@"testPage" title:nil args:@{}];
	menu = [OCMockObject partialMockForObject:menu];

	menu.displayController = ^(UIViewController* controller){
		XCTAssertNotNil(controller, @"Controller wasn't created for openPage.");
	};
	menu.displayDialog = ^{
		XCTFail(@"Should not be called by an openPage.");
	};
	
	[menu openPage:@"pages" title:@"pages" args:@{} success:^{} fail:^{}];
}

- (void)testClosePage
{
	LGRMenuViewController *menu = [[LGRMenuViewController alloc] initWithPage:@"testPage" title:nil args:@{}];
	
	menu.displayController = ^(UIViewController* controller){
		XCTFail(@"Should not be called by a closePage.");
	};
	menu.displayDialog = ^{
		XCTFail(@"Should not be called by a closePage.");
	};
	
	XCTAssertThrows([menu closePage:nil success:^{} fail:^{}], @"Should throw an exception as it's not supposed to be called in a menu.");
}

- (void)testUpdateParent
{
	LGRMenuViewController *menu = [[LGRMenuViewController alloc] initWithPage:@"testPage" title:nil args:@{}];
	
	menu.displayController = ^(UIViewController* controller){
		XCTFail(@"Should not be called by a closePage.");
	};
	menu.displayDialog = ^{
		XCTFail(@"Should not be called by a closePage.");
	};
	
	XCTAssertThrows([menu updateParent:nil args:@{} success:^{} fail:^{}], @"Should throw an exception as it's not supposed to be called in a menu.");
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
	[[((id)menu) expect] presentViewController:[OCMArg any] animated:[OCMArg any] completion:[OCMArg any]];
	[[((id)menu) stub] presentViewController:[OCMArg any] animated:[OCMArg any] completion:[OCMArg any]];
	
	[menu openDialog:@"pages" title:@"pages" args:@{} success:^{} fail:^{}];
	
	XCTAssertNoThrow([(id)menu verify], @"Verify failed");
}

- (void)testCloseDialog
{
	LGRMenuViewController *menu = [[LGRMenuViewController alloc] initWithPage:@"testPage" title:nil args:@{}];
	
	menu.displayController = ^(UIViewController* controller){
		XCTFail(@"Should not be called by a closePage.");
	};
	menu.displayDialog = ^{
		XCTFail(@"Should not be called by a closePage.");
	};
	
	XCTAssertThrows([menu closeDialog:nil success:^{} fail:^{}], @"Should throw an exception as it's not supposed to be called in a menu.");
}

@end
