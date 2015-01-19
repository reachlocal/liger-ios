//
//  LGRAppDelegateTest.m
//  LigerMobile
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
@property(assign) BOOL wasStartedByNotification;
@end

@interface LGRAppDelegateTest : XCTestCase
@property(assign) LGRAppDelegate *delegate;
@end

NSData* testToken() {
#ifdef __BIG__ENDIAN__
	int32_t hexData[8] = {0x260a0f58, 0x99ac6bd8, 0xa3e0d6b5, 0x1f38a4ad, 0x3475c1e4, 0xeefbeee6, 0x2eca722c, 0xef0c3bf9};
#elif __LITTLE_ENDIAN__
	int32_t hexData[8] = {0x580f0a26, 0xd86bac99, 0xb5d6e0a3, 0xada4381f, 0xe4c17534, 0xe6eefbee, 0x2c72ca2e, 0xf93b0cef};
#endif
	return [NSData dataWithBytes:hexData length:32];
}

NSString* testTokenAsString() {
	return @"260a0f5899ac6bd8a3e0d6b51f38a4ad3475c1e4eefbeee62eca722cef0c3bf9";
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

- (void)testTestTokenAsString
{
	XCTAssertTrue([testTokenAsString() length] == 64, @"Test string should be 64 long");
}

- (void)testTestToken
{
	NSData *tt = testToken();

	XCTAssertEqual([tt length], 32);
	Byte b1 = 0x0;
	Byte b2 = 0x0;
	Byte b3 = 0x0;
	Byte b4 = 0x0;
	[tt getBytes:&b1 range:NSMakeRange(0, 1)];
	[tt getBytes:&b2 range:NSMakeRange(1, 1)];
	[tt getBytes:&b3 range:NSMakeRange(2, 1)];
	[tt getBytes:&b4 range:NSMakeRange(3, 1)];
	XCTAssertEqual(b1, 0x26);
	XCTAssertEqual(b2, 0x0a);
	XCTAssertEqual(b3, 0x0f);
	XCTAssertEqual(b4, 0x58);
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
	[factory stopMocking];
}

- (void)testDidFinishLaunchingWithOptionsWithLocalNotification
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

	UILocalNotification *notification = [[UILocalNotification alloc] init];
	notification.userInfo = @{@"test": @"yes"};
	[appDelegate application:[UIApplication sharedApplication] didFinishLaunchingWithOptions:@{UIApplicationLaunchOptionsLocalNotificationKey:notification}];

	OCMVerifyAll(factory);
	XCTAssertEqualObjects(dict[@"notification"][@"test"], @"yes", @"Couldn't find notification");
	[factory stopMocking];
}

- (void)testDidRegisterForRemoteNotificationsWithDeviceToken
{
	id appDelegate = OCMPartialMock(self.delegate);

	id rootPage = [OCMockObject partialMockForObject:[[LGRViewController alloc] init]];
	[[[appDelegate stub] andReturn:rootPage] rootPage];

	[[rootPage expect] pushNotificationTokenUpdated:testTokenAsString() error:OCMOCK_ANY];

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

- (void)testDidReceiveLocalNotification
{
	UIApplicationState state = [[UIApplication sharedApplication] applicationState];
	BOOL background = state == UIApplicationStateInactive || state == UIApplicationStateBackground;

	id appDelegate = OCMPartialMock(self.delegate);
	[appDelegate setWasStartedByNotification:NO];

	id rootPage = OCMPartialMock([[LGRViewController alloc] init]);
	OCMStub([appDelegate rootPage]).andReturn(rootPage);
	OCMExpect([rootPage notificationArrived:@{@"hello": @"world"} background:background]);

	UILocalNotification *notification = [[UILocalNotification alloc] init];
	notification.userInfo = @{@"hello": @"world"};
	[appDelegate application:[UIApplication sharedApplication] didReceiveLocalNotification:notification];

	OCMVerifyAll(rootPage);
}

- (void)testDidReceiveRemoteNotification
{
	UIApplicationState state = [[UIApplication sharedApplication] applicationState];
	BOOL background = state == UIApplicationStateInactive || state == UIApplicationStateBackground;

	id appDelegate = OCMPartialMock(self.delegate);
	[appDelegate setWasStartedByNotification:NO];

	id rootPage = OCMPartialMock([[LGRViewController alloc] init]);
	OCMStub([appDelegate rootPage]).andReturn(rootPage);
	OCMExpect([rootPage notificationArrived:OCMOCK_ANY background:background]);

	[appDelegate application:[UIApplication sharedApplication] didReceiveRemoteNotification:@{}];

	OCMVerifyAll(rootPage);
}

- (void)testNotificationArrived
{
	id appDelegate = OCMPartialMock(self.delegate);
	[appDelegate setWasStartedByNotification:YES];

	[appDelegate application:[UIApplication sharedApplication] didReceiveRemoteNotification:@{}];

	XCTAssertFalse([appDelegate wasStartedByNotification]);
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
