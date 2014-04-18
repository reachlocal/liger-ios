//
//  LGRAppMenuViewControllerTest.m
//  Liger
//
//  Created by John Gustafsson on 11/26/13.
//  Copyright (c) 2013-2014 ReachLocal Inc. All rights reserved.  https://github.com/reachlocal/liger-ios/blob/master/LICENSE
//

@import XCTest;
#import "LGRAppMenuViewController.h"
#import "OCMock.h"

@interface LGRAppMenuViewControllerTest : XCTestCase

@end

@implementation LGRAppMenuViewControllerTest

- (void)testNativePage
{
	XCTAssertNotNil([LGRAppMenuViewController nativePage], @"LGRAppMenuViewController page should have a name");
	XCTAssertEqualObjects([LGRAppMenuViewController nativePage], @"appMenu", @"LGRAppMenuViewController page should have a name");
}

- (void)testSelection
{
	NSDictionary *args = @{@"menu": @[@[
								   @{
									   @"accessibilityLabel" : @"firstPage",
									   @"iconText" : @"P",
									   @"name" : @"First Page",
									   @"page" : @"firstPage",
									   @"args" : @"{'hello':'world'}"
									   },
								   @{
									   @"accessibilityLabel" : @"nativePages",
									   @"iconText" : @"N",
									   @"name" : @"Native Pages",
									   @"page" : @"nativePages",
									   @"args" : @"{'hello':'world'}",
									   @"dialog" : @YES
									   }]]};
	LGRAppMenuViewController *menu = [[LGRAppMenuViewController alloc] initWithPage:@"appMenu" title:nil args:args];
	
	menu.displayController = ^(UIViewController* controller){
		XCTAssertNotNil(controller, @"Controller wasn't created.");
	};
	menu.displayDialog = ^{
		XCTFail(@"Should not be called.");
	};

	[(id)menu tableView:nil didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
}

- (void)testSelectionWithDialog
{
	NSDictionary *args = @{@"menu": @[@[
										  @{
											  @"accessibilityLabel" : @"firstPage",
											  @"title" : @"First Page",
											  @"name" : @"First Page",
											  @"page" : @"firstPage",
											  @"args" : @"{'hello':'world'}"
											  },
										  @{
											  @"accessibilityLabel" : @"nativePages",
											  @"title": @"Native Page",
											  @"name" : @"Native Pages",
											  @"page" : @"nativePages",
											  @"args" : @"{'hello':'world'}",
											  @"dialog" : @YES
											  }]]};
	LGRAppMenuViewController *menu = [[LGRAppMenuViewController alloc] initWithPage:@"appMenu" title:nil args:args];
	
	menu.displayController = ^(UIViewController* controller){
		XCTFail(@"Should not be called.");
	};
	__block BOOL displayDialog = NO;
	menu.displayDialog = ^{
		displayDialog = YES;
	};
	
	menu = [OCMockObject partialMockForObject:menu];
	[[(id)menu expect] presentViewController:OCMOCK_ANY animated:YES completion:[OCMArg checkWithBlock:^BOOL(id param)
	{
		void (^passedBlock)() = param;
		passedBlock();
		return YES;
	}]];

	[(id)menu tableView:nil didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
	
	XCTAssertNoThrow([(id)menu verify], @"Verify failed");
	XCTAssertTrue(displayDialog, @"displayDialog was not called.");
}

@end
