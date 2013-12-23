//
//  LGREmailImportedTest.m
//  Liger
//
//  Created by John Gustafsson on 12/5/13.
//  Copyright (c) 2013 John Gustafsson. All rights reserved.
//

#import "LGREmailImported.h"
@import XCTest;
@import MessageUI;
@import ObjectiveC;

@interface LGREmailImportedTest : XCTestCase

@end

@implementation LGREmailImportedTest

- (void)testCreation
{
	UIViewController *email = [LGREmailImported controllerForImportedPage:nil title:nil args:@{} parent:nil];
	XCTAssertNotNil(email, @"LGREmailImported failed to create a page.");
}

- (void)testCreationParameters
{
	NSDictionary *args = @{@"toRecipients": @"foo@bar.com, bar@foo.com", @"subject" : @"tests"};
	
	MFMailComposeViewController *email = (MFMailComposeViewController*)[LGREmailImported controllerForImportedPage:nil title:nil args:args parent:nil];
	XCTAssertNotNil(email, @"LGREmailImported failed to create a page.");
}

- (void)testImportedPage
{
	XCTAssertEqualObjects([LGREmailImported importedPage], @"email", @"LGREmailImported page should have a name");
}

@end
