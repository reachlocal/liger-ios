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
#import "LGRPageFactory.h"

@interface LGRAppDelegate ()
- (LGRViewController*)rootPage;
@end

@interface LGRAppDelegateTest : XCTestCase
@property(assign) LGRAppDelegate *delegate;
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

	self.delegate = [[UIApplication sharedApplication] delegate];
}

- (void)testInit
{
	XCTAssertNotNil([[LGRAppDelegate alloc] init], @"Failed to init");
}

- (void)testDidFinishLaunchingWithOptions
{
	id appDelegate = OCMPartialMock(self.delegate);
	id factory = OCMClassMock(LGRPageFactory.class);

	__block NSDictionary* dict = nil;

	OCMExpect([factory controllerForPage:OCMOCK_ANY title:OCMOCK_ANY args:OCMOCK_ANY options:OCMOCK_ANY parent:OCMOCK_ANY]).andDo(^(NSInvocation * invocation){
		void* arg = nil;
		[invocation getArgument:&arg atIndex:4];
		NSDictionary *d = (NSDictionary*)(__bridge id)(arg);
		dict = d.copy;
	}).andReturn(self.delegate.rootPage);

	[appDelegate application:[UIApplication sharedApplication] didFinishLaunchingWithOptions:@{UIApplicationLaunchOptionsRemoteNotificationKey: @{@"test": @"yes"}}];

	OCMVerifyAll(factory);
	XCTAssertEqualObjects(dict[@"notification"][@"test"], @"yes", @"Couldn't find notification");
}

- (void)testDidRegisterForRemoteNotificationsWithDeviceToken
{
	id appDelegate = OCMPartialMock(self.delegate);

	id rootPage = [OCMockObject partialMockForObject:[[LGRViewController alloc] init]];
	[[[appDelegate stub] andReturn:rootPage] rootPage];

	[[rootPage expect] pushNotificationTokenUpdated:OCMOCK_ANY error:OCMOCK_ANY];

	[appDelegate application:[UIApplication sharedApplication] didRegisterForRemoteNotificationsWithDeviceToken:testToken()];

	XCTAssertNoThrow([rootPage verify], @"Verify failed");
}

- (void)testDidFailToRegisterForRemoteNotificationsWithError
{
	id appDelegate = OCMPartialMock(self.delegate);

	id rootPage = [OCMockObject partialMockForObject:[[LGRViewController alloc] init]];
	[[[appDelegate stub] andReturn:rootPage] rootPage];

	[[rootPage expect] pushNotificationTokenUpdated:OCMOCK_ANY error:OCMOCK_ANY];

	NSError *error = [NSError errorWithDomain:@"Test error" code:42 userInfo:@{}];

	[appDelegate application:[UIApplication sharedApplication] didFailToRegisterForRemoteNotificationsWithError:error];

	XCTAssertNoThrow([rootPage verify], @"Verify failed");
}

- (void)testDidReceiveRemoteNotification
{
	id appDelegate = OCMPartialMock(self.delegate);

	id rootPage = [OCMockObject partialMockForObject:[[LGRViewController alloc] init]];
	[[[appDelegate stub] andReturn:rootPage] rootPage];

	[[rootPage expect] notificationArrived:OCMOCK_ANY background:NO];

	[appDelegate application:[UIApplication sharedApplication] didReceiveRemoteNotification:@{}];

	XCTAssertNoThrow([rootPage verify], @"Verify failed");
}

- (void)testOpenURLSourceApplicationAnnotation
{
	id appDelegate = OCMPartialMock(self.delegate);

	id pageMock = [OCMockObject partialMockForObject:[[LGRViewController alloc] init]];
	[[pageMock expect] handleAppOpenURL:OCMOCK_ANY];

	[[[appDelegate stub] andReturn:pageMock] rootPage];
	[appDelegate application:[UIApplication sharedApplication]
				 openURL:[NSURL URLWithString:@"test://test?test=test&test=test"]
	   sourceApplication:@"org.ligermobile.test"
			  annotation:nil];

	XCTAssertNoThrow([pageMock verify], @"Verify failed");
}

- (void)testApplicationWillEnterForground
{
	id appDelegate = OCMPartialMock(self.delegate);
	id topPage = [OCMockObject partialMockForObject:[[LGRViewController alloc] init]];

	[[topPage expect] pageWillAppear];
	[[[appDelegate stub] andReturn:topPage] topPage];

	[appDelegate applicationWillEnterForeground:[UIApplication sharedApplication]];

	XCTAssertNoThrow([topPage verify], @"pageWillAppear not called.");
}

- (void)testRootPage
{
	LGRAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
	XCTAssertNotNil([appDelegate rootPage], @"Root page must not be nil");
}

@end
