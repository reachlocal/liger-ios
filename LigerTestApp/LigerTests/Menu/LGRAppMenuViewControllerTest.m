//
//  LGRAppMenuViewControllerTest.m
//  LigerMobile
//
//  Created by John Gustafsson on 11/26/13.
//  Copyright (c) 2013-2014 ReachLocal Inc. All rights reserved.  https://github.com/reachlocal/liger-ios/blob/master/LICENSE
//

@import XCTest;
#import "LGRAppMenuViewController.h"
#import "OCMock.h"

@interface LGRAppMenuViewController()
- (void)addShadowToView:(UIViewController*)viewController;
- (BOOL)is7OrHigher;
@end

@interface LGRAppMenuViewControllerTest : XCTestCase
@property(nonatomic, strong) LGRAppMenuViewController *menu;
@end

@implementation LGRAppMenuViewControllerTest

- (void)setUp
{
	[super setUp];

	NSDictionary *args = @{@"menu": @[@[
										  @{
											  @"accessibilityLabel" : @"firstPage",
											  @"title" : @"First Page",
											  @"page" : @"firstPage",
											  @"args" : @{@"hello":@"world"}
											  },
										  @{
											  @"accessibilityLabel" : @"nativePages",
											  @"title" : @"Native Pages",
											  @"page" : @"nativePages",
											  @"args" : @{@"hello":@"world"},
											  @"dialog" : @YES
											  }]]};

	self.menu = [[LGRAppMenuViewController alloc] initWithPage:@"appMenu" title:nil args:args options:@{}];
}

- (void)testNativePage
{
	XCTAssertNotNil([LGRAppMenuViewController nativePage], @"LGRAppMenuViewController page should have a name");
	XCTAssertEqualObjects([LGRAppMenuViewController nativePage], @"appMenu", @"LGRAppMenuViewController page should have a name");
}

- (void)testSelectionWithPage
{
	id menu = OCMPartialMock(self.menu);
	OCMExpect([menu openPage:@"firstPage" title:@"First Page" args:@{@"hello": @"world"} options:OCMOCK_ANY parent:OCMOCK_ANY success:OCMOCK_ANY fail:OCMOCK_ANY]);

	[menu tableView:nil didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
	OCMVerifyAll(menu);
}

- (void)testSelectionWithDialog
{
	id menu = OCMPartialMock(self.menu);
	OCMExpect([menu openDialog:@"nativePages" title:@"Native Pages" args:@{@"hello": @"world"} options:nil parent:OCMOCK_ANY success:OCMOCK_ANY fail:OCMOCK_ANY]);

	[menu tableView:nil didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
	OCMVerifyAll(menu);
}

- (void)testAddShadowToView
{
	id menu = OCMPartialMock(self.menu);

	[menu addShadowToView:nil];
	OCMStub([menu is7OrHigher]).andReturn(NO);
	[menu addShadowToView:nil];
}

@end
