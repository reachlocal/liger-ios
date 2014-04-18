//
//  LGRCordovaViewControllerTest.m
//  Liger
//
//  Created by John Gustafsson on 4/18/14.
//  Copyright (c) 2014 ReachLocal Inc. All rights reserved.
//

@import XCTest;
#import "LGRCordovaViewController.h"

#import "OCMock.h"
#import "XCTAsyncTestCase.h"

@interface LGRCordovaViewControllerTest : XCTAsyncTestCase
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

- (void)testDialogClosed
{
	id cordova = [OCMockObject partialMockForObject:self.cordova];

	id webMock = [OCMockObject mockForClass:UIWebView.class];
	[[[cordova stub] andReturn:webMock] webView];

	[[webMock expect] stringByEvaluatingJavaScriptFromString:OCMOCK_ANY];

	[self prepare];
	[cordova dialogClosed:@{@"hello": @"test"}];
	[self waitForTimeout:2.0];

	XCTAssertNoThrow([webMock verify], @"childUpdates: should call the webview controller");
}

- (void)testChildUpdates
{
	id cordova = [OCMockObject partialMockForObject:self.cordova];

	id webMock = [OCMockObject mockForClass:UIWebView.class];
	[[[cordova stub] andReturn:webMock] webView];

	[[webMock expect] stringByEvaluatingJavaScriptFromString:OCMOCK_ANY];

	[self prepare];
	[cordova childUpdates:@{@"hello": @"test"}];
	[self waitForTimeout:2.0];

	XCTAssertNoThrow([webMock verify], @"childUpdates: should call the webview controller");
}

- (void)testRefreshPage
{
	id cordova = [OCMockObject partialMockForObject:self.cordova];
	[cordova refreshPage:NO];

	id webMock = [OCMockObject mockForClass:UIWebView.class];
	[[[cordova stub] andReturn:webMock] webView];

	[[webMock expect] stringByEvaluatingJavaScriptFromString:OCMOCK_ANY];

	[self prepare];
	[cordova refreshPage:YES];
	[self waitForTimeout:2.0];

	XCTAssertNoThrow([webMock verify], @"refreshPage should call the webview controller");
}

@end
