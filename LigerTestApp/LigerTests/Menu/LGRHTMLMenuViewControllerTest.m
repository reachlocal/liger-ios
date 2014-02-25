//
//  LGRHTMLMenuViewControllerTest.m
//  Liger
//
//  Created by John Gustafsson on 11/26/13.
//  Copyright (c) 2013-2014 ReachLocal Inc. All rights reserved.  https://github.com/reachlocal/liger-ios/blob/master/LICENSE
//

@import XCTest;

#import "LGRHTMLMenuViewController.h"
#import "LGRCordovaViewController.h"

#import "OCMock.h"

@interface LGRHTMLMenuViewController (Test)
@property (readonly) LGRCordovaViewController *cordova;
@end

@interface LGRHTMLMenuViewControllerTest : XCTestCase
@property (nonatomic, strong) LGRHTMLMenuViewController *menu;
@end

@implementation LGRHTMLMenuViewControllerTest

- (void)setUp
{
	self.menu = [[LGRHTMLMenuViewController alloc] initWithPage:@"testPage" title:@"testTitle" args:@{}];
}

- (void)testInitWithPage
{
	NSDictionary *args = @{@"test": @YES, @"version": @76};
	LGRViewController *liger = [[LGRHTMLMenuViewController alloc] initWithPage:@"testPage" title:@"testTitle" args:args];
	
	XCTAssertEqual(liger.page, @"testPage", @"Page name is wrong");
	XCTAssertEqual(liger.title, @"testTitle", @"Title is wrong");
	XCTAssertEqualObjects(liger.args, args, @"Args are wrong");
	XCTAssertNil(liger.ligerParent, @"Parent shouldn't be set");
	XCTAssertFalse(liger.userCanRefresh, @"User refresh should be false as default");
}

- (void)testNativePage
{
	XCTAssertNil([LGRHTMLMenuViewController nativePage], @"LGRHTMLMenuViewController page should not have a name");
}

- (void)testDialogClosed
{
	LGRViewController *liger = [OCMockObject partialMockForObject:self.menu];
	
	id mock = [OCMockObject mockForClass:LGRCordovaViewController.class];
	
	[[[(id)liger stub] andReturn:mock] cordova];
	[[mock expect] dialogClosed:OCMOCK_ANY];
	
	[liger dialogClosed:@{}];
	
	XCTAssertNoThrow([mock verify], @"dialogClosed should be sent to the cordova controller");
}

- (void)testChildUpdates
{
	LGRViewController *menu = [OCMockObject partialMockForObject:self.menu];
	
	id mock = [OCMockObject mockForClass:LGRCordovaViewController.class];
	
	[[[(id)menu stub] andReturn:mock] cordova];
	[[mock expect] childUpdates:OCMOCK_ANY];
	
	[menu childUpdates:@{}];
	
	XCTAssertNoThrow([mock verify], @"dialogClosed should be sent to the cordova controller");
}

- (void)testPageWillAppear
{
	LGRViewController *menu = [OCMockObject partialMockForObject:self.menu];
	
	id mock = [OCMockObject mockForClass:LGRCordovaViewController.class];
	id webMock = [OCMockObject mockForClass:UIWebView.class];
	[[[mock stub] andReturn:webMock] webView];
	[[[(id)menu stub] andReturn:mock] cordova];
	
	[[webMock expect] stringByEvaluatingJavaScriptFromString:OCMOCK_ANY];
	
	[menu pageWillAppear];
	
	XCTAssertNoThrow([mock verify], @"pageWillAppear should result in a call to stringByEvaluatingJavaScriptFromString");
}

@end
