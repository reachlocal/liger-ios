//
//  LGRTwitterImportedTest.m
//  Liger
//
//  Created by John Gustafsson on 7/28/14.
//  Copyright (c) 2014 ReachLocal Inc. All rights reserved.
//

@import XCTest;
@import Social;

#import "LGRTwitterImported.h"

#import "OCMock.h"

@interface LGRTwitterImportedTest : XCTestCase

@end

@implementation LGRTwitterImportedTest

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
	XCTAssertEqualObjects([LGRTwitterImported importedPage], @"twitter", @"Imported name wrong");
}

- (void)testControllerForImportedPage
{
	id twitter = OCMClassMock(LGRTwitterImported.class);

	OCMExpect([LGRTwitterImported controllerForImportedPage:OCMOCK_ANY title:OCMOCK_ANY args:@{} options:@{} parent:OCMOCK_ANY serviceType:SLServiceTypeTwitter]);

	[LGRTwitterImported controllerForImportedPage:@"twitter" title:nil args:@{} options:@{} parent:nil];

	OCMVerifyAll(twitter);
	[twitter stopMocking];
}

@end
