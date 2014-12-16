//
//  LGRTencentWeiboImportedTest.m
//  Liger
//
//  Created by John Gustafsson on 7/28/14.
//  Copyright (c) 2014 ReachLocal Inc. All rights reserved.
//

@import XCTest;
@import Social;

#import "LGRTencentWeiboImported.h"

#import "OCMock.h"

@interface LGRTencentWeiboImportedTest : XCTestCase

@end

@implementation LGRTencentWeiboImportedTest

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
	XCTAssertEqualObjects([LGRTencentWeiboImported importedPage], @"tencentweibo", @"Imported name wrong");
}

- (void)testControllerForImportedPage
{
	id twitter = OCMClassMock(LGRTencentWeiboImported.class);

	OCMExpect([LGRTencentWeiboImported controllerForImportedPage:OCMOCK_ANY title:OCMOCK_ANY args:@{} options:@{} parent:OCMOCK_ANY serviceType:SLServiceTypeTwitter]);

	[LGRTencentWeiboImported controllerForImportedPage:@"tencentweibo" title:nil args:@{} options:@{} parent:nil];

	OCMVerifyAll(twitter);
	[twitter stopMocking];
}

@end
