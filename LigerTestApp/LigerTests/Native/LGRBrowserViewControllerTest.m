//
//  LGRBrowserViewControllerTest.m
//  LigerMobile
//
//  Created by John Gustafsson on 11/26/13.
//  Copyright (c) 2013-2014 ReachLocal Inc. All rights reserved.  https://github.com/reachlocal/liger-ios/blob/master/LICENSE
//

@import XCTest;

#import "LGRBrowserViewController.h"
#import "OCMock.h"

@interface LGRBrowserViewController () <UIWebViewDelegate>
@property (nonatomic, strong) IBOutlet UIWebView* webView;

- (void)goBack:(id)sender;
- (void)goForward:(id)sender;
- (void)reload:(id)sender;

@end

@interface LGRBrowserViewControllerTest : XCTestCase
@property(nonatomic, strong) LGRBrowserViewController *browser;
@end

@implementation LGRBrowserViewControllerTest

- (void)setUp
{
	[super setUp];

	NSDictionary *args = @{@"link" : @"http://reachlocal.github.io/liger/", @"allowZoom": @YES};
	self.browser = [[LGRBrowserViewController alloc] initWithPage:@"browser" title:@"testTitle" args:args options:@{}];
}

- (void)testInitWithPage
{
	XCTAssertEqual(self.browser.page, @"browser", @"Page name is wrong");
	XCTAssertEqual(self.browser.title, @"testTitle", @"Title is wrong");

	NSDictionary *args = @{@"link" : @"http://reachlocal.github.io/liger/", @"allowZoom": @YES};
	XCTAssertEqualObjects(self.browser.args, args, @"Args are wrong");
	XCTAssertNil(self.browser.parentPage, @"Parent shouldn't be set");
}

- (void)testNativePage
{
	XCTAssertEqualObjects([LGRBrowserViewController nativePage], @"browser", @"LGRBrowserViewController page should be named browser");
}

- (void)testViewDidLoad
{
	id browser = OCMPartialMock(self.browser);
	id web = OCMPartialMock([[UIWebView alloc] init]);
	OCMExpect([web loadRequest:OCMOCK_ANY]);
	OCMExpect([web setScalesPageToFit:YES]);
	OCMStub([browser webView]).andReturn(web);

	[browser viewDidLoad];

	OCMVerifyAll(web);
}

- (void)testViewWillAppear
{
	id browser = OCMPartialMock(self.browser);
	id nav = OCMPartialMock([[UINavigationController alloc] init]);
	OCMExpect([nav setToolbarHidden:NO animated:YES]);
	OCMStub([browser navigationController]).andReturn(nav);

	[browser viewWillAppear:YES];

	OCMVerifyAll(nav);
}

- (void)testWebViewDidStartLoad
{
	id app = [OCMockObject partialMockForObject:[UIApplication sharedApplication]];
	id appClass = [OCMockObject mockForClass:UIApplication.class];
	[[[appClass stub] andReturn:app] sharedApplication];
	[[app expect] setNetworkActivityIndicatorVisible:YES];

	[self.browser webViewDidStartLoad:self.browser.webView];

	XCTAssertNoThrow([app verify], @"Network indicator fail");

	[appClass stopMocking];
}

- (void)testWebViewDidFinishLoad
{
	id app = [OCMockObject partialMockForObject:[UIApplication sharedApplication]];
	id appClass = [OCMockObject mockForClass:UIApplication.class];
	[[[appClass stub] andReturn:app] sharedApplication];
	[[app expect] setNetworkActivityIndicatorVisible:NO];

	[self.browser webViewDidFinishLoad:self.browser.webView];

	XCTAssertNoThrow([app verify], @"Network indicator fail");

	[appClass stopMocking];
}

- (void)testWebViewDidFailWithError
{
	id app = [OCMockObject partialMockForObject:[UIApplication sharedApplication]];
	id appClass = [OCMockObject mockForClass:UIApplication.class];
	[[[appClass stub] andReturn:app] sharedApplication];
	[[app expect] setNetworkActivityIndicatorVisible:NO];

	[self.browser webView:self.browser.webView didFailLoadWithError:[[NSError alloc] init]];

	XCTAssertNoThrow([app verify], @"Network indicator fail");

	[appClass stopMocking];
}

- (void)testGoBack
{
	id web = [OCMockObject partialMockForObject:[[UIWebView alloc] init]];
	[[web expect] goBack];

	id browser = [OCMockObject partialMockForObject:self.browser];
	[[[browser stub] andReturn:web] webView];

	[browser goBack:nil];

	XCTAssertNoThrow([web verify], @"");
}

- (void)testGoForward
{
	id web = [OCMockObject partialMockForObject:[[UIWebView alloc] init]];
	[[web expect] goForward];

	id browser = [OCMockObject partialMockForObject:self.browser];
	[[[browser stub] andReturn:web] webView];

	[browser goForward:nil];

	XCTAssertNoThrow([web verify], @"");
}

- (void)testReload
{
	id web = [OCMockObject partialMockForObject:[[UIWebView alloc] init]];
	[[web expect] reload];

	id browser = [OCMockObject partialMockForObject:self.browser];
	[[[browser stub] andReturn:web] webView];

	[browser reload:nil];

	XCTAssertNoThrow([web verify], @"");
}

- (void)testButtonTapped
{
	id browser = OCMPartialMock(self.browser);
	OCMExpect([browser closeDialog:@{} success:OCMOCK_ANY fail:OCMOCK_ANY]);

	[browser buttonTapped:@{@"button": @"done"}];

	OCMVerifyAll(browser);
}
@end
