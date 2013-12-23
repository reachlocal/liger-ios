//
//  RLMAppTest.m
//  Liger
//
//  Created by John Gustafsson on 5/9/13.
//  Copyright (c) 2013 ReachLocal, Inc. All rights reserved.
//

#import "LGRApp.h"

@import XCTest;

@interface LGRAppTest : XCTestCase
@property (nonatomic, strong) NSDictionary *appJSON;
@end

@implementation LGRAppTest

- (void)setUp
{
    [super setUp];
	NSString *filePath = [[NSBundle mainBundle] pathForResource:@"app/app" ofType:@"json"];
	NSData *file = [NSData dataWithContentsOfFile:filePath];
	XCTAssertNotNil(file, @"app.json failed to load");
	
	NSError *error = nil;
	self.appJSON = [NSJSONSerialization JSONObjectWithData:file options:0 error:&error];
	
	XCTAssertNil(error, @"app.json failed to load");
}

- (void)tearDown
{
    // Tear-down code here.
    [super tearDown];
}

- (void)testMenu
{
	NSArray *menu = [LGRApp menuItems];
	XCTAssertNotNil(menu, @"No menuItems in app.json");
	
	for (NSDictionary *item in menu[0]) {
		XCTAssertNotNil(item[@"name"], @"Menu item did not have a name");
		XCTAssertNotNil(item[@"page"], @"Menu item did not have a page");
		XCTAssertNotNil(item[@"iconText"], @"Menu item did not have text");
		XCTAssertNotNil(item[@"accessibilityLabel"], @"Menu item did not have a name");
	}
	for (NSDictionary *item in menu[1]) {
		XCTAssertNotNil(item[@"name"], @"Menu item did not have a name");
		XCTAssertNotNil(item[@"page"], @"Menu item did not have a page");
		XCTAssertNotNil(item[@"detail"], @"Menu item did not have a detail");
		XCTAssertNotNil(item[@"accessibilityLabel"], @"Menu item did not have an accessibility level");
	}
}

- (void)testAppearance
{
	NSDictionary *appearance = [LGRApp appearance];
	XCTAssertNotNil(appearance, @"No appearance in app.json");
	
}

- (void)testToolbar
{
	NSArray *pagesWithToolbars = [LGRApp toolbars];
	XCTAssertNotNil(pagesWithToolbars, @"No toolbars in app.json");
	XCTAssert([pagesWithToolbars isKindOfClass:NSArray.class], @"[LGRApp toolbars] didn't return an array");
}
@end
