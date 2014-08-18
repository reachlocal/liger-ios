//
//  LGRTabBarViewControllerTest.m
//  LigerMobile
//
//  Created by Gary Moon on 8/13/14.
//  Copyright (c) 2014 ReachLocal Inc. All rights reserved.  https://github.com/reachlocal/liger-ios/blob/master/LICENSE
//

#import <XCTest/XCTest.h>
#import "LGRTabBarViewController.h"
#import "LGRDrawerViewController.h"
#import <OCMock.h>

@interface LGRTabBarViewController () <UITabBarControllerDelegate>
@property(nonatomic, strong) UITabBarController *tab;
@property(nonatomic, strong) UIPanGestureRecognizer *navigationBarGesture;
@property(nonatomic, strong) UIScreenEdgePanGestureRecognizer *openGesture;
@property(nonatomic, strong) UIPanGestureRecognizer *closeGesture;
@end

@interface LGRTabBarViewControllerTest : XCTestCase
@property(nonatomic, strong) LGRTabBarViewController *tab;
@end

@implementation LGRTabBarViewControllerTest

- (void)setUp
{
	[super setUp];
	NSDictionary *pageOne = @{@"page": @"firstPage", @"title": @"First Page"};
	NSDictionary *pageTwo = @{@"page": @"secondPage", @"title": @"Second Page"};

	NSDictionary *navigatorOne = @{@"page": @"navigator", @"title": @"Navigator One", @"args": pageOne};
	NSDictionary *navigatorTwo = @{@"page": @"navigator", @"title": @"Navigator Two", @"args": @{@"pages": @[pageOne, pageTwo]}};

	self.tab = [[LGRTabBarViewController alloc] initWithPage: @"tab"
													   title: @"Test"
														args: @{@"pages": @[navigatorOne, navigatorTwo]}
													 options: @{}];
}

- (void)tearDown
{
	// Put teardown code here. This method is called after the invocation of each test method in the class.
	[super tearDown];
}

- (void)testInit
{
	XCTAssertNotNil([[LGRTabBarViewController alloc] init], @"Didn't init");
}

- (void)testNativePage
{
	XCTAssertEqualObjects([LGRTabBarViewController nativePage], @"tab", @"Name of page changed");
}

- (void)testInitWithPage
{
	NSDictionary *pageOne = @{@"page": @"firstPage", @"title": @"First Page"};
	NSDictionary *pageTwo = @{@"page": @"secondPage", @"title": @"Second Page"};

	NSDictionary *navigatorOne = @{@"page": @"navigator", @"title": @"Navigator One", @"args": pageOne};
	NSDictionary *navigatorTwo = @{@"page": @"navigator", @"title": @"Navigator Two", @"args": @{@"pages": @[pageOne, pageTwo]}};

	id tab = [[LGRTabBarViewController alloc] initWithPage: @"tab"
													 title: @"Test"
													  args: @{@"pages": @[navigatorOne, navigatorTwo]}
												   options: @{}];

	XCTAssertNotNil(tab, @"Tab failed to instatiate");
}

- (void)testInitWithoutPage
{
	id tab = [[LGRTabBarViewController alloc] initWithPage: @"tab"
													 title: @"Test"
													  args: @{}
												   options: @{}];

	XCTAssertNil(tab, @"Tab shouldn't be created of no pages have been specified.");
}

- (void)testViewDidLoad
{
	id tab = OCMPartialMock(self.tab);

	[tab viewDidLoad];

	XCTAssertNotNil([tab tab], @"No tab created");
}

- (void)testPushNotificationTokenUpdatedError
{
	id rootPage = OCMPartialMock(self.tab.rootPage);
	OCMExpect([rootPage pushNotificationTokenUpdated:OCMOCK_ANY error:OCMOCK_ANY]);

	id tab = OCMPartialMock(self.tab);
	OCMStub([tab rootPage]).andReturn(rootPage);

	[tab pushNotificationTokenUpdated:nil error:nil];

	OCMVerifyAll(rootPage);
}

- (void)testNotificationArrivedBackground
{
	id rootPage = OCMPartialMock(self.tab.rootPage);
	OCMExpect([rootPage notificationArrived:OCMOCK_ANY background:NO]);

	id tab = OCMPartialMock(self.tab);
	OCMStub([tab rootPage]).andReturn(rootPage);

	[tab notificationArrived:@{} background:NO];

	OCMVerifyAll(rootPage);
}

- (void)testHandleAppOpenURL
{
	id rootPage = OCMPartialMock(self.tab.rootPage);
	OCMExpect([rootPage handleAppOpenURL:[NSURL URLWithString:@"http://reachlocal.github.io/liger"]]);

	id tab = OCMPartialMock(self.tab);
	OCMStub([tab rootPage]).andReturn(rootPage);
	
	[tab handleAppOpenURL:[NSURL URLWithString:@"http://reachlocal.github.io/liger"]];
	
	OCMVerifyAll(rootPage);
}

- (void)testDidSelectViewController
{
	id delegate = OCMProtocolMock(@protocol(LGRDrawerViewControllerDelegate));
	[self.tab tabBarController:nil didSelectViewController:delegate];

	OCMVerify([delegate useGestures]);
}

- (void)testSetMenuButtonAndGestures
{
    id button = OCMClassMock([UIBarButtonItem class]);
    id openGesture = OCMClassMock([UIPanGestureRecognizer class]);
    id closeGesture = OCMClassMock([UIPanGestureRecognizer class]);
    id navigationBarGesture = OCMClassMock([UIScreenEdgePanGestureRecognizer class]);
    
    id pageOne = OCMProtocolMock(@protocol(LGRDrawerViewControllerDelegate));
    id pageTwo = OCMProtocolMock(@protocol(LGRDrawerViewControllerDelegate));
    NSArray *pages = @[pageOne, pageTwo];
    id UITab = OCMPartialMock(self.tab.tab);
    id tab = OCMPartialMock(self.tab);
    
    OCMStub([pageOne setMenuButton:OCMOCK_ANY navigationBarGesture:OCMOCK_ANY openGesture:OCMOCK_ANY closeGesture:OCMOCK_ANY]);
    OCMStub([pageTwo setMenuButton:OCMOCK_ANY navigationBarGesture:OCMOCK_ANY openGesture:OCMOCK_ANY closeGesture:OCMOCK_ANY]);
    OCMStub([UITab viewControllers]).andReturn(pages);
    OCMStub([tab tab]).andReturn(UITab);
    
    [tab setMenuButton:button navigationBarGesture:navigationBarGesture openGesture:openGesture closeGesture:closeGesture];
    
    XCTAssertEqual([tab openGesture], openGesture);
    XCTAssertEqual([tab closeGesture], closeGesture);
    XCTAssertEqual([tab navigationBarGesture], navigationBarGesture);
    OCMVerify([pageOne setMenuButton:OCMOCK_ANY navigationBarGesture:OCMOCK_ANY openGesture:OCMOCK_ANY closeGesture:nil]);
    OCMVerify([pageTwo setMenuButton:OCMOCK_ANY navigationBarGesture:OCMOCK_ANY openGesture:OCMOCK_ANY closeGesture:nil]);
}

- (void)testUseGestures
{
    id page = OCMProtocolMock(@protocol(LGRDrawerViewControllerDelegate));
    id UITab = OCMPartialMock(self.tab.tab);
    id tab = OCMPartialMock(self.tab);
    
    OCMStub([UITab selectedViewController]).andReturn(page);
    OCMStub([tab tab]).andReturn(UITab);
    
    [tab useGestures];
    
    OCMVerify([page useGestures]);
}

- (void)testUserInteractionEnabled
{
    id page = OCMProtocolMock(@protocol(LGRDrawerViewControllerDelegate));
    id tabBar = OCMPartialMock(self.tab.tab.tabBar);
    id UITab = OCMPartialMock(self.tab.tab);
    id closeGesture = OCMClassMock([UIPanGestureRecognizer class]);
    id tabView = OCMClassMock([UIView class]);
    id tab = OCMPartialMock(self.tab);
    
    OCMStub([UITab selectedViewController]).andReturn(page);
    OCMStub([UITab tabBar]).andReturn(tabBar);
    OCMStub([tab closeGesture]).andReturn(closeGesture);
    OCMStub([tabView removeGestureRecognizer:OCMOCK_ANY]);
    OCMStub([tab view]).andReturn(tabView);
    OCMStub([tab tab]).andReturn(UITab);
    
    BOOL enabled = YES;
    [tab userInteractionEnabled:enabled];
    
    OCMVerify([tabBar setUserInteractionEnabled:enabled]);
    OCMVerify([page userInteractionEnabled:enabled]);
    OCMVerify([tabView removeGestureRecognizer:OCMOCK_ANY]);
}

- (void)testUserInteractionDisabled
{
    id page = OCMProtocolMock(@protocol(LGRDrawerViewControllerDelegate));
    id tabBar = OCMPartialMock(self.tab.tab.tabBar);
    id UITab = OCMPartialMock(self.tab.tab);
    id closeGesture = OCMClassMock([UIPanGestureRecognizer class]);
    id tabView = OCMClassMock([UIView class]);
    id tab = OCMPartialMock(self.tab);
    
    OCMStub([UITab selectedViewController]).andReturn(page);
    OCMStub([UITab tabBar]).andReturn(tabBar);
    OCMStub([tab closeGesture]).andReturn(closeGesture);
    OCMStub([tabView addGestureRecognizer:OCMOCK_ANY]);
    OCMStub([tab view]).andReturn(tabView);
    OCMStub([tab tab]).andReturn(UITab);
    
    BOOL enabled = NO;
    [tab userInteractionEnabled:enabled];
    
    OCMVerify([tabBar setUserInteractionEnabled:enabled]);
    OCMVerify([page userInteractionEnabled:enabled]);
    OCMVerify([tabView addGestureRecognizer:OCMOCK_ANY]);
}
@end
