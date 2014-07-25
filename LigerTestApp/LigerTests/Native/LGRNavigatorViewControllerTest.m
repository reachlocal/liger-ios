//
//  LGRNavigatorViewControllerTest.m
// LigerMobile
//
//  Created by John Gustafsson on 7/22/14.
//  Copyright (c) 2013-2014 ReachLocal Inc. All rights reserved.  https://github.com/reachlocal/liger-ios/blob/master/LICENSE
//

#import <XCTest/XCTest.h>
#import "LGRNavigatorViewController.h"

@interface LGRNavigatorViewController ()
@property(nonatomic, strong) UINavigationController *navigator;
@end

@interface LGRNavigatorViewControllerTest : XCTestCase
@end

@implementation LGRNavigatorViewControllerTest

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testNativePage
{
	XCTAssertEqualObjects([LGRNavigatorViewController nativePage], @"Navigator", @"Name of page changed");
}

- (void)testInitWithPage
{
	id navigator = [[LGRNavigatorViewController alloc] initWithPage:@"Navigator"
															  title:@"Title"
															   args:@{}
															options:@{}];

	XCTAssertNotNil(navigator, @"Navigator failed to instatiate");
}

- (void)testViewDidLoad
{
	LGRNavigatorViewController *navigator = [[LGRNavigatorViewController alloc] initWithPage:@"Navigator"
																					   title:@"Title"
																						args:@{}
																					 options:@{}];

	[navigator viewDidLoad];

	XCTAssertNotNil(navigator.navigator, @"No navigator created");
}

@end
