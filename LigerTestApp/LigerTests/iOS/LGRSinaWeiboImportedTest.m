//
//  LGRSinaWeiboImportedTest.m
//  Liger
//
//  Created by John Gustafsson on 7/28/14.
//  Copyright (c) 2014 ReachLocal Inc. All rights reserved.
//

@import XCTest;
@import Social;

#import "LGRSinaWeiboImported.h"

#import "OCMock.h"

@interface LGRSinaWeiboImportedTest : XCTestCase

@end

@implementation LGRSinaWeiboImportedTest

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
	XCTAssertEqualObjects([LGRSinaWeiboImported importedPage], @"sinaweibo", @"Imported name wrong");
}

- (void)testControllerForImportedPage
{
	id sinaweibo = OCMClassMock(LGRSinaWeiboImported.class);

	OCMExpect([LGRSinaWeiboImported controllerForImportedPage:OCMOCK_ANY title:OCMOCK_ANY args:@{} options:@{} parent:OCMOCK_ANY serviceType:SLServiceTypeTwitter]);

	[LGRSinaWeiboImported controllerForImportedPage:@"sinaweibo" title:nil args:@{} options:@{} parent:nil];

	OCMVerifyAll(sinaweibo);
	[sinaweibo stopMocking];
}

@end
