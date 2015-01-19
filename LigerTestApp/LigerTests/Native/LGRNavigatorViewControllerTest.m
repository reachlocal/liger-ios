//
//  LGRNavigatorViewControllerTest.m
//  LigerMobile
//
//  Created by John Gustafsson on 7/22/14.
//  Copyright (c) 2013-2014 ReachLocal Inc. All rights reserved.  https://github.com/reachlocal/liger-ios/blob/master/LICENSE
//

#import <XCTest/XCTest.h>
#import "LGRNavigatorViewController.h"
#import "LGRDrawerViewController.h"
#import <OCMock.h>

@interface LGRNavigatorViewController ()
@property(nonatomic, strong) UINavigationController *navigator;
@property(nonatomic, strong) UIPanGestureRecognizer *navigationBarGesture;
@property(nonatomic, strong) UIScreenEdgePanGestureRecognizer *openGesture;
@property(nonatomic, strong) UIPanGestureRecognizer *closeGesture;

- (NSArray*)makePageArrayAndAddNotification;
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
																 args:@{@"page": @"firstPage"}
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
															   args:@{@"page": @"firstPage"}
															options:@{}];

	XCTAssertNotNil(navigator, @"Navigator failed to instantiate");
}

- (void)testInitWithPageWithoutPage
{
	id navigator = [[LGRNavigatorViewController alloc] initWithPage:@"navigator"
															  title:@"Title"
															   args:@{}
															options:@{}];

	XCTAssertNil(navigator, @"Navigator shouldn't instantiate without at least one page in it");
}

- (void)testInitWithPageWithNotification
{
	id navigator = [[LGRNavigatorViewController alloc] initWithPage:@"navigator"
															  title:@"Title"
															   args:@{@"page": @"firstPage", @"notification": @{ @"hello": @"world" }}
															options:@{}];
	LGRViewController *controller = [navigator rootPage];
	XCTAssertEqualObjects([[controller args] objectForKey:@"notification"], @{@"hello": @"world"}, @"Notification not included in root controller's args.");
}

- (void)testInitWithPageWithNotificationWithPageArray
{
	id navigator = [[LGRNavigatorViewController alloc] initWithPage:@"navigator"
															  title:@"Title"
															   args:@{@"pages" : @[@{@"page": @"firstPage"}], @"notification": @{ @"hello": @"world" }}
															options:@{}];
	LGRViewController *controller = [navigator rootPage];
	XCTAssertEqualObjects([[controller args] objectForKey:@"notification"], @{@"hello": @"world"}, @"Notification not included in root controller's args.");
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

- (void)testClosePage
{
	id navigator = OCMPartialMock(self.navigator);

	id top = [[LGRViewController alloc] init];
	id nav = OCMClassMock(UINavigationController.class);
	OCMExpect([nav popViewControllerAnimated:YES]).andReturn(top);
	OCMStub([navigator navigator]).andReturn(nav);
	OCMStub([nav topViewController]).andReturn(top);

	__block BOOL success = NO;
	[navigator closePage:nil sourcePage:top success:^{
		success = YES;
	} fail:^{}];

	OCMVerifyAll(nav);
	XCTAssertTrue(success, @"Should have succeeded.");
}

- (void)testClosePageInternalFail1
{
	id navigator = OCMPartialMock(self.navigator);

	id top = [[LGRViewController alloc] init];
	id nav = OCMClassMock(UINavigationController.class);
	OCMStub([navigator navigator]).andReturn(nav);
	OCMStub([nav topViewController]).andReturn(nil);

	__block BOOL fail = NO;
	[navigator closePage:nil sourcePage:top success:^{} fail:^{
		fail = YES;
	}];

	XCTAssertTrue(fail, @"Should have failed, not matching the top view.");
}

- (void)testClosePageInternalFail2
{
	id navigator = OCMPartialMock(self.navigator);

	OCMStub([navigator navigator]).andReturn(nil);
	id top = [[LGRViewController alloc] init];

	__block BOOL fail = NO;
	[navigator closePage:nil sourcePage:top success:^{} fail:^{
		fail = YES;
	}];

	XCTAssertTrue(fail, @"Should have failed, no navigator.");
}

- (void)testClosePageInternalFail3
{
	id navigator = OCMPartialMock(self.navigator);

	id top = [[LGRViewController alloc] init];
	id nav = OCMClassMock(UINavigationController.class);
	OCMStub([nav popViewControllerAnimated:YES]).andReturn(nil);
	OCMStub([nav topViewController]).andReturn(top);
	OCMStub([navigator navigator]).andReturn(nav);

	__block BOOL fail = NO;
	[navigator closePage:nil sourcePage:top success:^{} fail:^{
		fail = YES;
	}];

	XCTAssertTrue(fail, @"Should have failed, no navigator.");
}

- (void)testClosePageRewind
{
	id navigator = OCMPartialMock(self.navigator);

	id page1 = OCMPartialMock([[LGRViewController alloc] initWithPage:@"test1" title:@"" args:@{} options:@{}]);
	id page2 = OCMPartialMock([[LGRViewController alloc] initWithPage:@"test2" title:@"" args:@{} options:@{}]);
	id page3 = OCMPartialMock([[LGRViewController alloc] initWithPage:@"test3" title:@"" args:@{} options:@{}]);
	[page2 setParentPage:page1];
	[page3 setParentPage:page2];

	id nav = OCMClassMock(UINavigationController.class);
	NSArray *pages = @[page2, page3];
	OCMExpect([nav popToViewController:page1 animated:YES]).andReturn(pages);
	OCMStub([navigator navigator]).andReturn(nav);

	__block BOOL success = NO;
	[navigator closePage:@"test1" sourcePage:page3 success:^{
		success = YES;
	} fail:^{}];

	OCMVerifyAll(nav);
	XCTAssertTrue(success, @"Should have succeeded.");
}

- (void)testClosePageRewindInternalFail
{
	id navigator = OCMPartialMock(self.navigator);

	id page1 = OCMPartialMock([[LGRViewController alloc] initWithPage:@"test1" title:@"" args:@{} options:@{}]);
	id page2 = OCMPartialMock([[LGRViewController alloc] initWithPage:@"test2" title:@"" args:@{} options:@{}]);
	id page3 = OCMPartialMock([[LGRViewController alloc] initWithPage:@"test3" title:@"" args:@{} options:@{}]);
	[page2 setParentPage:page1];
	[page3 setParentPage:page2];

	id nav = OCMClassMock(UINavigationController.class);
	OCMExpect([nav popToViewController:page1 animated:YES]).andReturn(nil);
	OCMStub([navigator navigator]).andReturn(nav);

	__block BOOL fail = NO;
	[navigator closePage:@"test1" sourcePage:page3 success:^{} fail:^{
		fail = YES;
	}];

	OCMVerifyAll(nav);
	XCTAssertTrue(fail, @"Should have failed, popToViewController doesn't return an array.");
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

- (void)testPushNotificationTokenUpdatedError
{
	id rootPage = OCMPartialMock(self.navigator.rootPage);
	OCMExpect([rootPage pushNotificationTokenUpdated:OCMOCK_ANY error:OCMOCK_ANY]);

	id navigator = OCMPartialMock(self.navigator);
	OCMStub([navigator rootPage]).andReturn(rootPage);

	[navigator pushNotificationTokenUpdated:nil error:nil];

	OCMVerifyAll(rootPage);
}

- (void)testNotificationArrivedBackground
{
	id rootPage = OCMPartialMock(self.navigator.rootPage);
	OCMExpect([rootPage notificationArrived:OCMOCK_ANY background:NO]);

	id navigator = OCMPartialMock(self.navigator);
	OCMStub([navigator rootPage]).andReturn(rootPage);

	[navigator notificationArrived:@{} background:NO];

	OCMVerifyAll(rootPage);
}

- (void)testHandleAppOpenURL
{
	id rootPage = OCMPartialMock(self.navigator.rootPage);
	OCMExpect([rootPage handleAppOpenURL:[NSURL URLWithString:@"http://reachlocal.github.io/liger"]]);
	
	id navigator = OCMPartialMock(self.navigator);
	OCMStub([navigator rootPage]).andReturn(rootPage);
	
	[navigator handleAppOpenURL:[NSURL URLWithString:@"http://reachlocal.github.io/liger"]];
	
	OCMVerifyAll(rootPage);
}

- (void)testUserInteractionEnabled
{
    id rootPageView = OCMPartialMock(self.navigator.rootPage.view);
    id rootPage = OCMPartialMock(self.navigator.rootPage);
    id navigationBar = OCMPartialMock(self.navigator.navigationBar);
    id openGesture = OCMClassMock([UIPanGestureRecognizer class]);
    id closeGesture = OCMClassMock([UIPanGestureRecognizer class]);
    id navigationBarGesture = OCMClassMock([UIScreenEdgePanGestureRecognizer class]);
    id navigatorView = OCMClassMock([UIView class]);
    id navigator = OCMPartialMock(self.navigator);
    
    OCMStub([rootPageView addGestureRecognizer:OCMOCK_ANY]);
    OCMStub([rootPage view]).andReturn(rootPageView);
    OCMStub([navigator topPage]).andReturn(rootPage);
    OCMStub([navigator rootPage]).andReturn(rootPage);
    OCMStub([navigationBar addGestureRecognizer:OCMOCK_ANY]);
    OCMStub([navigator navigationBar]).andReturn(navigationBar);
    OCMStub([navigator openGesture]).andReturn(openGesture);
    OCMStub([navigator closeGesture]).andReturn(closeGesture);
    OCMStub([navigator navigationBarGesture]).andReturn(navigationBarGesture);
    OCMStub([navigatorView removeGestureRecognizer:OCMOCK_ANY]);
    OCMStub([navigator view]).andReturn(navigatorView);
    
    BOOL enabled = YES;
    [navigator userInteractionEnabled:enabled];
    
    OCMVerify([rootPageView setUserInteractionEnabled:enabled]);
    OCMVerify([navigationBar setUserInteractionEnabled:YES]);
    OCMVerify([rootPageView addGestureRecognizer:OCMOCK_ANY]);
    OCMVerify([navigatorView removeGestureRecognizer:OCMOCK_ANY]);
    OCMVerify([navigationBar addGestureRecognizer:OCMOCK_ANY]);
}

- (void)testUserInteractionDisabled
{
    id rootPageView = OCMPartialMock(self.navigator.rootPage.view);
    id rootPage = OCMPartialMock(self.navigator.rootPage);
    id navigationBar = OCMPartialMock(self.navigator.navigationBar);
    id openGesture = OCMClassMock([UIPanGestureRecognizer class]);
    id closeGesture = OCMClassMock([UIPanGestureRecognizer class]);
    id navigationBarGesture = OCMClassMock([UIScreenEdgePanGestureRecognizer class]);
    id navigatorView = OCMClassMock([UIView class]);
    id navigator = OCMPartialMock(self.navigator);
    
    OCMStub([rootPageView addGestureRecognizer:OCMOCK_ANY]);
    OCMStub([rootPage view]).andReturn(rootPageView);
    OCMStub([navigator topPage]).andReturn(rootPage);
    OCMStub([navigator rootPage]).andReturn(rootPage);
    OCMStub([navigationBar addGestureRecognizer:OCMOCK_ANY]);
    OCMStub([navigator navigationBar]).andReturn(navigationBar);
    OCMStub([navigator openGesture]).andReturn(openGesture);
    OCMStub([navigator closeGesture]).andReturn(closeGesture);
    OCMStub([navigator navigationBarGesture]).andReturn(navigationBarGesture);
    OCMStub([navigatorView removeGestureRecognizer:OCMOCK_ANY]);
    OCMStub([navigator view]).andReturn(navigatorView);
    
    BOOL enabled = NO;
    [navigator userInteractionEnabled:enabled];
    
    OCMVerify([rootPageView setUserInteractionEnabled:enabled]);
    OCMVerify([navigationBar setUserInteractionEnabled:YES]);
    OCMVerify([rootPageView removeGestureRecognizer:OCMOCK_ANY]);
    OCMVerify([navigatorView addGestureRecognizer:OCMOCK_ANY]);
    OCMVerify([navigationBar removeGestureRecognizer:OCMOCK_ANY]);
}

- (void)testUserInteractionWithoutTopview
{
    id rootPageView = OCMPartialMock(self.navigator.rootPage.view);
    id rootPage = OCMPartialMock(self.navigator.rootPage);
    id navigationBar = OCMPartialMock(self.navigator.navigationBar);
    id openGesture = OCMClassMock([UIPanGestureRecognizer class]);
    id closeGesture = OCMClassMock([UIPanGestureRecognizer class]);
    id navigationBarGesture = OCMClassMock([UIScreenEdgePanGestureRecognizer class]);
    id navigatorView = OCMClassMock([UIView class]);
    id navigator = OCMPartialMock(self.navigator);

    OCMStub([rootPageView addGestureRecognizer:OCMOCK_ANY]);
    OCMStub([rootPage view]).andReturn(rootPageView);
    OCMStub([navigator topPage]).andReturn(nil);
    OCMStub([navigator rootPage]).andReturn(rootPage);
    OCMStub([navigationBar addGestureRecognizer:OCMOCK_ANY]);
    OCMStub([navigator navigationBar]).andReturn(navigationBar);
    OCMStub([navigator openGesture]).andReturn(openGesture);
    OCMStub([navigator closeGesture]).andReturn(closeGesture);
    OCMStub([navigator navigationBarGesture]).andReturn(navigationBarGesture);
    OCMStub([navigatorView removeGestureRecognizer:OCMOCK_ANY]);
    OCMStub([navigator view]).andReturn(navigatorView);

    BOOL enabled = NO;
    [navigator userInteractionEnabled:enabled];

    OCMVerify([navigationBar setUserInteractionEnabled:enabled]);
}

- (void)testPreferredStatusBarStyle
{
	id navigator = OCMPartialMock(self.navigator);
	id nav = OCMPartialMock([[UINavigationController alloc] init]);
	OCMStub([navigator navigator]).andReturn(nav);

	id top = OCMPartialMock([[LGRViewController alloc] init]);
	OCMStub([nav topViewController]).andReturn(top);

	OCMStub([top preferredStatusBarStyle]).andReturn(UIStatusBarStyleLightContent);
	UIStatusBarStyle style = [navigator preferredStatusBarStyle];
	XCTAssertEqual(style, UIStatusBarStyleLightContent, @"Should be UIStatusBarStyleLightContent");

	OCMVerify([[[navigator navigator] topViewController] preferredStatusBarStyle]);
}

- (void)testMakePageArrayAndAddNotification
{
	id navigator = OCMPartialMock(self.navigator);
	NSArray *pages = [navigator makePageArrayAndAddNotification];
	XCTAssertNotNil(pages);
}

@end
