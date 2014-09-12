//
//  RLMAppTest.m
//  LigerMobile
//
//  Created by John Gustafsson on 5/9/13.
//  Copyright (c) 2013-2014 ReachLocal Inc. All rights reserved.  https://github.com/reachlocal/liger-ios/blob/master/LICENSE
//

#import "LGRApp.h"
#import "OCMock.h"

@interface LGRApp ()
+ (LGRApp*)shared;
@property (nonatomic, strong) NSDictionary *app;
@end

@import XCTest;

@interface LGRAppTest : XCTestCase
@end

@implementation LGRAppTest

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testInit
{
	XCTAssertNotNil([[LGRApp alloc] init], @"Failed to init");
}

- (void)testReadAppJson
{
    [super setUp];
	NSString *filePath = [[NSBundle mainBundle] pathForResource:@"app/app" ofType:@"json"];
	NSData *file = [NSData dataWithContentsOfFile:filePath];
	XCTAssertNotNil(file, @"app.json failed to load");

	NSError *error = nil;
	[NSJSONSerialization JSONObjectWithData:file options:0 error:&error];

	XCTAssertNil(error, @"app.json failed to load");
}

- (void)testMenu
{
	NSDictionary *rootPage = [LGRApp root];
	NSArray *menu = rootPage[@"args"][@"args"][@"menu"];
	XCTAssertNotNil(menu, @"No menuItems in app.json");
	
	for (NSDictionary *item in menu[0]) {
		XCTAssertNotNil(item[@"name"], @"Menu item did not have a name");
		XCTAssertNotNil(item[@"page"], @"Menu item did not have a page");
		XCTAssertNotNil(item[@"accessibilityLabel"], @"Menu item did not have a name");
	}
	for (NSDictionary *item in menu[1]) {
		XCTAssertNotNil(item[@"name"], @"Menu item did not have a name");
		XCTAssertNotNil(item[@"page"], @"Menu item did not have a page");
		XCTAssertNotNil(item[@"detail"], @"Menu item did not have a detail");
		XCTAssertNotNil(item[@"accessibilityLabel"], @"Menu item did not have an accessibility level");
	}
}

- (void)testRootPage
{
	NSDictionary *rootPage = [LGRApp root];

	XCTAssertNotNil(rootPage, @"No root page");
}

- (void)testAppearance
{
	NSDictionary *appearance = [LGRApp appearance];
	XCTAssertNotNil(appearance, @"No appearance in app.json");
}

- (void)testSetupPushNotifications
{
	UIRemoteNotificationType types = (UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound);

	id sharedApp = [OCMockObject partialMockForObject:[UIApplication sharedApplication]];
	[[sharedApp expect] cancelAllLocalNotifications];
	[[sharedApp expect] registerForRemoteNotificationTypes:types];

	id app = [OCMockObject partialMockForObject:[LGRApp shared]];
	[[[app stub] andReturn:@{@"notifications": @(YES)}] app];

	id app2 = [OCMockObject mockForClass:LGRApp.class];
	[[[app2 stub] andReturn:app] shared];

	[LGRApp setupPushNotifications];

	XCTAssertNoThrow([sharedApp verify], @"Failed expect.");

	[sharedApp stopMocking];
	[app2 stopMocking];
	[app stopMocking];
}

@end
