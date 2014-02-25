//
//  LGRLigerTest.m
//  Liger
//
//  Created by John Gustafsson on 12/24/13.
//  Copyright (c) 2013-2014 ReachLocal Inc. All rights reserved.  https://github.com/reachlocal/liger-ios/blob/master/LICENSE
//

@import XCTest;
#import "LGRLiger.h"
#import "LGRViewController.h"
#import "OCMock.h"

@interface LGRLiger (ExposingForTest)
- (UIViewController*)ligerViewController;
- (void)sendOK:(NSString*)callbackId messageAsDictionary:(NSDictionary *)message;
@end

@interface LGRLigerTest : XCTestCase
@property (nonatomic, strong) LGRLiger *ligerPlugin;
@end

@implementation LGRLigerTest

- (void)setUp
{
    [super setUp];
	self.ligerPlugin = [OCMockObject partialMockForObject:[[LGRLiger alloc] init]];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testopenPage
{
	id viewController = [OCMockObject mockForClass:LGRViewController.class];
	[[viewController expect] openPage:OCMOCK_ANY title:@"Home" args:@{} success:OCMOCK_ANY fail:OCMOCK_ANY];
	[[viewController stub] openPage:OCMOCK_ANY title:OCMOCK_ANY args:OCMOCK_ANY success:OCMOCK_ANY fail:OCMOCK_ANY];
	
	[[[(id)self.ligerPlugin stub] andReturn:viewController] ligerViewController];
	
	CDVInvokedUrlCommand *cmd = [[CDVInvokedUrlCommand alloc] initWithArguments:@[ @"Home", @"home" ]
																	 callbackId:@"callback"
																	  className:@"Liger"
																	 methodName:@"openPage"];

	[self.ligerPlugin openPage:cmd];
	[viewController verify];
}


- (void)testOpenDialog
{
	id viewController = [OCMockObject mockForClass:LGRViewController.class];
	[[viewController expect] openDialog:OCMOCK_ANY title:nil args:@{} success:OCMOCK_ANY fail:OCMOCK_ANY];
	[[viewController stub] openDialog:OCMOCK_ANY title:OCMOCK_ANY args:OCMOCK_ANY success:OCMOCK_ANY fail:OCMOCK_ANY];

	[[[(id)self.ligerPlugin stub] andReturn:viewController] ligerViewController];
	
	CDVInvokedUrlCommand *cmd = [[CDVInvokedUrlCommand alloc] initWithArguments:@[ @"home", @{} ]
																	 callbackId:@"callback"
																	  className:@"Liger"
																	 methodName:@"openDialog"];
	[self.ligerPlugin openDialog:cmd];
	[viewController verify];
}

- (void)testOpenDialogWithTitle
{
	id viewController = [OCMockObject mockForClass:LGRViewController.class];
	[[viewController expect] openDialog:OCMOCK_ANY title:@"Home" args:@{} success:OCMOCK_ANY fail:OCMOCK_ANY];
	[[viewController stub] openDialog:OCMOCK_ANY title:OCMOCK_ANY args:OCMOCK_ANY success:OCMOCK_ANY fail:OCMOCK_ANY];
	
	[[[(id)self.ligerPlugin stub] andReturn:viewController] ligerViewController];
	
	CDVInvokedUrlCommand *cmd = [[CDVInvokedUrlCommand alloc] initWithArguments:@[ @"Home", @"home", @{} ]
																	 callbackId:@"callback"
																	  className:@"Liger"
																	 methodName:@"openDialogWithTitle"];
	[self.ligerPlugin openDialogWithTitle:cmd];
	[viewController verify];
}

- (void)testCloseDialog
{
	id viewController = [OCMockObject mockForClass:LGRViewController.class];
	[[viewController expect] closeDialog:@{} success:OCMOCK_ANY fail:OCMOCK_ANY];
	[[viewController stub] closeDialog:OCMOCK_ANY success:OCMOCK_ANY fail:OCMOCK_ANY];
	
	[[[(id)self.ligerPlugin stub] andReturn:viewController] ligerViewController];
	
	CDVInvokedUrlCommand *cmd = [[CDVInvokedUrlCommand alloc] initWithArguments:@[ @{} ]
																	 callbackId:@"callback"
																	  className:@"Liger"
																	 methodName:@"closeDialog"];
	[self.ligerPlugin closeDialog:cmd];
	[viewController verify];
}

- (void)testToolbar
{
	id viewController = [OCMockObject mockForClass:LGRViewController.class];
	[[[(id)self.ligerPlugin stub] andReturn:viewController] ligerViewController];
	
	[[viewController expect] setToolbarItems:OCMOCK_ANY];
	[[viewController stub] setToolbarItems:OCMOCK_ANY];
	
	
	NSArray *args = @[@{@"icon": @"h", @"callback": @"console.log('test');"},
					  @{@"icon": @"h", @"callback": @"console.log('test');"},
					  @{@"icon": @"h", @"callback": @"console.log('test');"},
					  @{@"icon": @"h", @"callback": @"console.log('test');"},
					  @{@"icon": @"h", @"callback": @"console.log('test');"}];
	
	CDVInvokedUrlCommand *cmd = [[CDVInvokedUrlCommand alloc] initWithArguments:@[args]
																	 callbackId:@"callback"
																	  className:@"Liger"
																	 methodName:@"toolbar"];

	[self.ligerPlugin toolbar:cmd];
	[viewController verify];
}

- (void)testGetPageArgs
{
	id viewController = [OCMockObject mockForClass:LGRViewController.class];
	[[[(id)self.ligerPlugin stub] andReturn:viewController] ligerViewController];
	[[(id)self.ligerPlugin expect] sendOK:OCMOCK_ANY messageAsDictionary:OCMOCK_ANY];
	[[[(id)self.ligerPlugin stub] andReturn:viewController] sendOK:OCMOCK_ANY messageAsDictionary:OCMOCK_ANY];

	[[viewController expect] args];
	[[[viewController stub] andReturn:@{}] args];

	CDVInvokedUrlCommand *cmd = [[CDVInvokedUrlCommand alloc] initWithArguments:@[]
																	 callbackId:@"callback"
																	  className:@"Liger"
																	 methodName:@"getPageArgs"];
	
	[self.ligerPlugin getPageArgs:cmd];
	[viewController verify];
	[(id)self.ligerPlugin verify];
}

@end
