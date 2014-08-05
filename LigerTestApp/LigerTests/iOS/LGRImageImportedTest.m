//
//  LGRImageImportedTest.m
//  Liger
//
//  Created by John Gustafsson on 7/31/14.
//  Copyright (c) 2014 ReachLocal Inc. All rights reserved.
//

@import XCTest;
#import "LGRImageImported.h"
#import "OCMock.h"

@interface LGRImageImportedTest : XCTestCase

@end

@implementation LGRImageImportedTest

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

- (void)testImportedPage
{
	XCTAssertEqualObjects([LGRImageImported importedPage], @"image", @"Imported name wrong");
}

- (void)testControllerForImportedPage
{
	id image = [LGRImageImported controllerForImportedPage:@"image" title:nil args:@{} options:@{} parent:nil];
	XCTAssertNotNil(image, @"image was not created");
}

@end
