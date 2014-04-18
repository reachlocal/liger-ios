//
//  LGRDrawerViewControllerTest.m
//  Liger
//
//  Created by John Gustafsson on 11/25/13.
//  Copyright (c) 2013-2014 ReachLocal Inc. All rights reserved.  https://github.com/reachlocal/liger-ios/blob/master/LICENSE
//

@import XCTest;

#import "LGRDrawerViewController.h"
#import "LGRMenuViewController.h"
#import "LGRPageFactory.h"
#import "OCMock.h"

@interface LGRDrawerViewController ()
@property (nonatomic, strong) LGRMenuViewController *menu;
@end

@interface LGRDrawerViewControllerTest : XCTestCase
@property(nonatomic, strong) LGRDrawerViewController *slider;
@end

@implementation LGRDrawerViewControllerTest

- (void)setUp
{
	self.slider = (LGRDrawerViewController*)[LGRPageFactory controllerForPage:@"Drawer" title:@"" args:@{} parent:nil];
	XCTAssert(self.slider.view, @"Slider has no view");
    [super setUp];
}

- (void)tearDown
{

	[super tearDown];
}

- (void)testResetApp
{
	[self.slider resetApp];
	[self.slider.childViewControllers[0] viewDidAppear:NO]; // We have to fake calling this as slider's view isn't hooked up to anything

	XCTAssert(self.slider.childViewControllers.count == 2, @"Wrong number of child controllers.");
}

- (void)testNativePage
{
	XCTAssertTrue([[LGRDrawerViewController nativePage] isEqualToString:@"Drawer"], @"Native page wasn't named DrawerPage");
}

- (void)testPushNotificationTokenUpdatedError
{
	id menu = [OCMockObject partialMockForObject:self.slider.menu];
	[[menu expect] pushNotificationTokenUpdated:OCMOCK_ANY error:OCMOCK_ANY];

	id slider = [OCMockObject partialMockForObject:self.slider];
	[[[slider stub] andReturn:menu] menu];

	[slider pushNotificationTokenUpdated:nil error:nil];

	XCTAssertNoThrow([menu verify], @"Verify failed");
}

@end
