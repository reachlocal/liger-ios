//
//  LGRHTMLViewControllerTest.m
//  Liger
//
//  Created by John Gustafsson on 11/26/13.
//  Copyright (c) 2013 John Gustafsson. All rights reserved.
//

@import XCTest;

#import "LGRHTMLViewController.h"
#import "LGRCordovaViewController.h"
#import "OCMock.h"

@interface LGRHTMLViewController (Test)
@property (readonly) LGRCordovaViewController *cordova;
@end

@interface LGRHTMLViewControllerTest : XCTestCase
@property (nonatomic, strong) LGRHTMLViewController *liger;
@end

@implementation LGRHTMLViewControllerTest

- (void)setUp
{
	[super setUp];
	self.liger = [[LGRHTMLViewController alloc] initWithPage:@"testPage" title:@"Test Title" args:@{}];
}

- (void)testInitWithPage
{
	NSDictionary *args = @{@"test": @YES, @"version": @76};
	LGRViewController *liger = [[LGRHTMLViewController alloc] initWithPage:@"testPage" title:@"Test Title" args:args];
	
	XCTAssertEqual(liger.page, @"testPage", @"Page name is wrong");
	XCTAssertEqual(liger.title, @"Test Title", @"Title is wrong");
	XCTAssertEqualObjects(liger.args, args, @"Args are wrong");
	XCTAssertNil(liger.ligerParent, @"Parent shouldn't be set");
	XCTAssertFalse(liger.userCanRefresh, @"User refresh should be false as default");
}

- (void)testNativePage
{
	XCTAssertNil([LGRHTMLViewController nativePage], @"LGRHTMLViewController page should not have a name");
}

- (void)testRefreshPage
{
	LGRViewController *liger = [OCMockObject partialMockForObject:self.liger];

	id mock = [OCMockObject mockForClass:LGRCordovaViewController.class];
	
	[[[(id)liger stub] andReturn:mock] cordova];
	
	[[mock expect] refreshPage:YES];
	[[mock expect] refreshPage:NO];
	
	[liger refreshPage:YES];
	[liger refreshPage:NO];
	
	XCTAssertNoThrow([mock verify], @"refreshPage should be sent to the cordova controller");
}

- (void)testDialogClosed
{
	LGRViewController *liger = [OCMockObject partialMockForObject:self.liger];
	
	id mock = [OCMockObject mockForClass:LGRCordovaViewController.class];
	
	[[[(id)liger stub] andReturn:mock] cordova];
	[[mock expect] dialogClosed:OCMOCK_ANY];
	
	[liger dialogClosed:@{}];
	
	XCTAssertNoThrow([mock verify], @"dialogClosed should be sent to the cordova controller");
}

- (void)testChildUpdates
{
	LGRViewController *liger = [OCMockObject partialMockForObject:self.liger];
	
	id mock = [OCMockObject mockForClass:LGRCordovaViewController.class];
	
	[[[(id)liger stub] andReturn:mock] cordova];
	[[mock expect] childUpdates:OCMOCK_ANY];
	
	[liger childUpdates:@{}];
	
	XCTAssertNoThrow([mock verify], @"dialogClosed should be sent to the cordova controller");
}

- (void)testPageWillAppear
{
	LGRViewController *liger = [OCMockObject partialMockForObject:self.liger];

	id mock = [OCMockObject mockForClass:LGRCordovaViewController.class];
	id webMock = [OCMockObject mockForClass:UIWebView.class];
	[[[mock stub] andReturn:webMock] webView];
	[[[(id)liger stub] andReturn:mock] cordova];
	
	[[webMock expect] stringByEvaluatingJavaScriptFromString:OCMOCK_ANY];
	
	[liger pageWillAppear];
	
	XCTAssertNoThrow([mock verify], @"pageWillAppear should result in a call to stringByEvaluatingJavaScriptFromString");
}

@end
