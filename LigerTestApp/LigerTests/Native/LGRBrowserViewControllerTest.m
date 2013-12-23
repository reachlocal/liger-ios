//
//  LGRBrowserViewControllerTest.m
//  Liger
//
//  Created by John Gustafsson on 11/26/13.
//  Copyright (c) 2013 John Gustafsson. All rights reserved.
//

@import XCTest;

#import "LGRBrowserViewController.h"

@interface LGRBrowserViewControllerTest : XCTestCase

@end

@implementation LGRBrowserViewControllerTest

- (void)testInitWithPage
{
	NSDictionary *args = @{@"link" : @"http://liger.com"};
	LGRViewController *liger = [[LGRBrowserViewController alloc] initWithPage:@"testPage" title:@"testTitle" args:args];
	
	XCTAssertEqual(liger.page, @"testPage", @"Page name is wrong");
	XCTAssertEqual(liger.title, @"testTitle", @"Title is wrong");
	XCTAssertEqualObjects(liger.args, args, @"Args are wrong");
	XCTAssertNil(liger.ligerParent, @"Parent shouldn't be set");
	XCTAssertFalse(liger.userCanRefresh, @"User refresh should be false as default");
}

- (void)testNativePage
{
	XCTAssertEqualObjects([LGRBrowserViewController nativePage], @"browser", @"LGRBrowserViewController page should have a name");
}
@end
