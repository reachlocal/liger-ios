//
//  LGRCordovaViewControllerTest.m
// LigerMobile
//
//  Created by John Gustafsson on 4/18/14.
//  Copyright (c) 2014 ReachLocal Inc. All rights reserved.
//

@import XCTest;
#import "LGRCordovaViewController.h"
#import "LGRAppearance.h"

#import "OCMock.h"

@interface LGRCordovaViewController()
@property (nonatomic, strong) NSMutableArray *evalQueue;

- (void)setAcceptingJS:(BOOL)acceptingJS;

- (void)refresh:(id)sender;

- (void)addToQueue:(NSString*)js;
- (void)executeQueue;
@end

@interface LGRCordovaViewControllerTest : XCTestCase
@property (nonatomic, strong) LGRCordovaViewController* cordova;
@end

@implementation LGRCordovaViewControllerTest

- (void)setUp
{
    [super setUp];

	self.cordova = [[LGRCordovaViewController alloc] initWithPage:@"firstPage" title:@"title" args:@{}];
}

- (void)tearDown
{

    [super tearDown];
}

- (void)testWebViewDidStartLoad
{
	id cordova = OCMPartialMock(self.cordova);
	OCMExpect([cordova setAcceptingJS:NO]);

	[cordova webViewDidStartLoad:nil];

	OCMVerifyAll(cordova);
}

- (void)testWebViewDidFinishLoad
{
	id cordova = OCMPartialMock(self.cordova);
	OCMExpect([cordova setAcceptingJS:YES]);
	OCMExpect([cordova executeQueue]);

	[cordova webViewDidFinishLoad:nil];

	OCMVerifyAll(cordova);
}

- (void)testDialogClosed
{
	id cordova = OCMPartialMock(self.cordova);

	[[cordova expect] addToQueue:OCMOCK_ANY];
	[[cordova expect] executeQueue];

	[cordova dialogClosed:@{@"hello": @"test"}];

	XCTAssertNoThrow([cordova verify], @"dialogClose should push to queue");
}

- (void)testChildUpdates
{
	id cordova = OCMPartialMock(self.cordova);

	[[cordova expect] addToQueue:OCMOCK_ANY];
	[[cordova expect] executeQueue];

	[cordova childUpdates:@{@"hello": @"test"}];

	XCTAssertNoThrow([cordova verify], @"childUpdates should push to queue");
}

- (void)testUserCanRefresh
{
	id cordova = OCMPartialMock(self.cordova);
	[[cordova reject] parentViewController];

	[cordova setUserCanRefresh:[cordova userCanRefresh]];
}

- (void)testRefresh
{
	id cordova = OCMPartialMock(self.cordova);

	[[cordova expect] refreshPage:YES];

	[cordova refresh:nil];

	XCTAssertNoThrow([cordova verify], @"refresh should call refresh page");
}

- (void)testRefreshPage
{
	id cordova = OCMPartialMock(self.cordova);

	[[cordova expect] addToQueue:OCMOCK_ANY];
	[[cordova expect] executeQueue];

	[cordova refreshPage:YES];

	XCTAssertNoThrow([cordova verify], @"refreshPage should push to queue");
}

- (void)testPreferredStatusBarStyle
{
	UIStatusBarStyle style = [self.cordova preferredStatusBarStyle];

	XCTAssertEqual(style, [LGRAppearance statusBarDialog], @"Appearance and preferred should match.");
}

- (void)testPushNotificationTokenUpdatedError
{
	id cordova = OCMPartialMock(self.cordova);

	[[cordova expect] addToQueue:OCMOCK_ANY];
	[[cordova expect] executeQueue];

	[cordova pushNotificationTokenUpdated:@"Token" error:nil];

	XCTAssertNoThrow([cordova verify], @"pushNotificationTokenUpdated:error: should push to queue");
}

- (void)testNotificationArrivedBackground
{
	id cordova = OCMPartialMock(self.cordova);

	[[cordova expect] addToQueue:OCMOCK_ANY];
	[[cordova expect] executeQueue];

	[cordova notificationArrived:@{} background:YES];

	XCTAssertNoThrow([cordova verify], @"notificationArrived:background: should push to queue");
}

- (void)testHandleAppOpenURL
{
	id cordova = OCMPartialMock(self.cordova);

	[[cordova expect] addToQueue:OCMOCK_ANY];
	[[cordova expect] executeQueue];

	[cordova handleAppOpenURL:[NSURL URLWithString:@"test://test"]];

	XCTAssertNoThrow([cordova verify], @"handleAppOpenURL: should push to queue");
}

- (void)testButtonTapped
{
	id cordova = OCMPartialMock(self.cordova);

	[[cordova expect] addToQueue:OCMOCK_ANY];
	[[cordova expect] executeQueue];

	[cordova buttonTapped:@{@"button": @"left"}];

	XCTAssertNoThrow([cordova verify], @"testButtonTapped: should push to queue");
}

- (void)testAddToQueue
{
	id cordova = OCMPartialMock(self.cordova);
	id mockArray = [OCMockObject partialMockForObject:[NSMutableArray array]];
	[[mockArray expect] addObject:OCMOCK_ANY];

	[[[cordova stub] andReturn:mockArray] evalQueue];
	[[cordova expect] executeQueue];

	[cordova addToQueue:@"Console.log('test');"];

	XCTAssertNoThrow([mockArray verify], @"array should be added to");
}

- (void)testExecuteQueue
{
	id cordova = OCMPartialMock(self.cordova);
	[cordova addToQueue:@"Console.log('test');"];
	[cordova setAcceptingJS:YES];

	id webMock = [OCMockObject mockForClass:UIWebView.class];
	[[[cordova stub] andReturn:webMock] webView];

	[[webMock expect] stringByEvaluatingJavaScriptFromString:OCMOCK_ANY];

	[cordova executeQueue];

	XCTAssertNoThrow([webMock verifyWithDelay:2.0], @"");
}

@end
