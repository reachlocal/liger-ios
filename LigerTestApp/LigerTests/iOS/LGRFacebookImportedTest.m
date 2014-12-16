//
//  LGRFacebookImportedTest.m
//  Liger
//
//  Created by John Gustafsson on 7/28/14.
//  Copyright (c) 2014 ReachLocal Inc. All rights reserved.
//

@import XCTest;
@import Social;

#import "LGRFacebookImported.h"

#import "OCMock.h"

@interface LGRFacebookImportedTest : XCTestCase
@end

@implementation LGRFacebookImportedTest

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testImportedPage
{
	XCTAssertEqualObjects([LGRFacebookImported importedPage], @"facebook", @"Imported name wrong");
}

- (void)testControllerForImportedPage
{
	id facebook = OCMClassMock(LGRFacebookImported.class);

	OCMExpect([LGRFacebookImported controllerForImportedPage:OCMOCK_ANY title:OCMOCK_ANY args:@{} options:@{} parent:OCMOCK_ANY serviceType:SLServiceTypeFacebook]);

	[LGRFacebookImported controllerForImportedPage:@"facebook" title:nil args:@{} options:@{} parent:nil];

	OCMVerifyAll(facebook);
	[facebook stopMocking];
}

@end
