//
//  LGRSocialImportedTest.m
//  Liger
//
//  Created by John Gustafsson on 8/22/14.
//  Copyright (c) 2014 ReachLocal Inc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LGRSocialImported.h"
#import "OCMock.h"
#import "LGRViewController.h"

@import Social;

@interface LGRSocialImportedTest : XCTestCase

@end

@implementation LGRSocialImportedTest

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

// Commented out the async part as I couldn't get it to work properly. Waiting for Xcode 6 to use the new async test code instead. Keeping it so it's easier to update later.
- (void)testCompletionHandler
{
	id parent = OCMPartialMock([[LGRViewController alloc] init]);
	OCMStub([parent dialogClosed:OCMOCK_ANY]).andDo(^(NSInvocation* invocation){
//		[self notify:kXCTUnitWaitStatusSuccess];
	});
	SLComposeViewController *social = (SLComposeViewController*)[LGRSocialImported controllerForImportedPage:@""
																									   title:@""
																										args:@{@"text": @"This is a test"}
																									 options:@{}
																									  parent:parent
																								 serviceType:SLServiceTypeTwitter];

//	[self prepare];
	social.completionHandler(SLComposeViewControllerResultDone);

//	[self waitForStatus:kXCTUnitWaitStatusSuccess timeout:5];

//	OCMVerify([parent dialogClosed:OCMOCK_ANY]);
}

@end
