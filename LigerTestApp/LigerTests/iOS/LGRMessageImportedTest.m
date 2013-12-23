//
//  LGRMessageImportedTest.m
//  Liger
//
//  Created by John Gustafsson on 12/5/13.
//  Copyright (c) 2013 John Gustafsson. All rights reserved.
//

#import "LGRMessageImported.h"
#include "TargetConditionals.h"

@import XCTest;
@import MessageUI;
@import ObjectiveC;

@interface LGRMessageImportedTest : XCTestCase

@end

@implementation LGRMessageImportedTest

- (void)testCreation
{
	UIViewController *message = [LGRMessageImported controllerForImportedPage:nil title:nil args:@{} parent:nil];
#if !(TARGET_IPHONE_SIMULATOR)
	XCTAssertNotNil(message, @"LGRMessageImported failed to create a page.");
#else // Not available on the simulator
	XCTAssertNil(message, @"LGRMessageImported did create a page.");
#endif
}

- (void)testCreationParameters
{
	NSDictionary *args = @{@"toRecipients": @"foo@bar.com, bar@foo.com", @"subject" : @"tests"};
	
	MFMailComposeViewController *message = (MFMailComposeViewController*)[LGRMessageImported controllerForImportedPage:nil title:nil args:args parent:nil];
#if !(TARGET_IPHONE_SIMULATOR)
	XCTAssertNotNil(message, @"LGRMessageImported failed to create a page.");
#else // Not available on the simulator
	XCTAssertNil(message, @"LGRMessageImported did create a page.");
#endif
}

- (void)testImportedPage
{
	XCTAssertEqualObjects([LGRMessageImported importedPage], @"message", @"LGRMessageImported page should have a name");
}

@end
