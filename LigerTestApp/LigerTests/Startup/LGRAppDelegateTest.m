//
//  LGRAppDelegateTest.m
//  Liger
//
//  Created by John Gustafsson on 4/10/14.
//  Copyright (c) 2014 ReachLocal Inc. All rights reserved.  https://github.com/reachlocal/liger-ios/blob/master/LICENSE
//

#import "LGRAppDelegate.h"
#import <XCTest/XCTest.h>
#import "OCMock.h"
#import "LGRViewController.h"

@interface LGRAppDelegate ()
- (LGRViewController*)rootPage;
@end

@interface LGRAppDelegateTest : XCTestCase

@end

NSData* testToken()
{
	int32_t hexData[8] = {0x26ea0f58, 0x99ac6bd8, 0xa3e0d6b5, 0x1f38a4ad, 0x3475c1e4, 0xeefbeee6, 0x2eca722c, 0xef0c3bf9};
	return [NSData dataWithBytes:hexData length:32];
}

@implementation LGRAppDelegateTest

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testDidRegisterForRemoteNotificationsWithDeviceToken
{
	id appDelegate = [OCMockObject partialMockForObject:[[UIApplication sharedApplication] delegate]];

	id rootPage = [OCMockObject partialMockForObject:[[LGRViewController alloc] init]];
	[[[appDelegate stub] andReturn:rootPage] rootPage];

	[[rootPage expect] pushNotificationTokenUpdated:OCMOCK_ANY error:OCMOCK_ANY];

	[appDelegate application:[UIApplication sharedApplication] didRegisterForRemoteNotificationsWithDeviceToken:testToken()];

	XCTAssertNoThrow([rootPage verify], @"Verify failed");
}

- (void)testDidFailToRegisterForRemoteNotificationsWithError
{
	id appDelegate = [OCMockObject partialMockForObject:[[UIApplication sharedApplication] delegate]];

	id rootPage = [OCMockObject partialMockForObject:[[LGRViewController alloc] init]];
	[[[appDelegate stub] andReturn:rootPage] rootPage];

	[[rootPage expect] pushNotificationTokenUpdated:OCMOCK_ANY error:OCMOCK_ANY];

	NSError *error = [NSError errorWithDomain:@"Test error" code:42 userInfo:@{}];

	[appDelegate application:[UIApplication sharedApplication] didFailToRegisterForRemoteNotificationsWithError:error];

	XCTAssertNoThrow([rootPage verify], @"Verify failed");
}

- (void)testDidReceiveRemoteNotification
{
	id appDelegate = [OCMockObject partialMockForObject:[[UIApplication sharedApplication] delegate]];

	id rootPage = [OCMockObject partialMockForObject:[[LGRViewController alloc] init]];
	[[[appDelegate stub] andReturn:rootPage] rootPage];

	[[rootPage expect] notificationArrived:OCMOCK_ANY background:NO];

	[appDelegate application:[UIApplication sharedApplication] didReceiveRemoteNotification:@{}];

	XCTAssertNoThrow([rootPage verify], @"Verify failed");
}

- (void)testOpenURLSourceApplicationAnnotation
{
	LGRAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];

	id pageMock = [OCMockObject partialMockForObject:[[LGRViewController alloc] init]];
	[[pageMock expect] handleAppOpenURL:OCMOCK_ANY];
	id appMock = [OCMockObject partialMockForObject:appDelegate];

	[[[appMock stub] andReturn:pageMock] rootPage];
	[appMock application:[UIApplication sharedApplication]
				 openURL:[NSURL URLWithString:@"test://test?test=test&test=test"]
	   sourceApplication:@"org.ligermobile.test"
			  annotation:nil];

	XCTAssertNoThrow([pageMock verify], @"Verify failed");
}

- (void)testRootPage
{
	LGRAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
	XCTAssertNotNil([appDelegate rootPage], @"Root page must not be nil");
}

@end
