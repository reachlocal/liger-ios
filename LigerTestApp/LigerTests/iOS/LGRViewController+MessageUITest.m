//
//  LGRViewController+MessageUITest.m
//  Liger
//
//  Created by John Gustafsson on 12/5/13.
//  Copyright (c) 2013 John Gustafsson. All rights reserved.
//

#import "LGRViewController+MessageUI.h"
#import "OCMock.h"

@import XCTest;

@interface LGRViewController_MessageUITest : XCTestCase

@end

@implementation LGRViewController_MessageUITest


- (void)testEmailClosing
{
	LGRViewController *control = [[LGRViewController alloc] initWithPage:@"testPage" title:nil args:@{}];
	control = [OCMockObject partialMockForObject:control];

	[[((id)control) expect] dismissViewControllerAnimated:YES completion:OCMOCK_ANY];

	[control mailComposeController:nil didFinishWithResult:MFMailComposeResultSent error:nil];
	
	XCTAssertNoThrow([(id)control verify], @"Verify failed");
}

- (void)testMessageClosing
{
	LGRViewController *control = [[LGRViewController alloc] initWithPage:@"testPage" title:nil args:@{}];
	control = [OCMockObject partialMockForObject:control];
	
	[[((id)control) expect] dismissViewControllerAnimated:YES completion:OCMOCK_ANY];
	
	[control messageComposeViewController:nil didFinishWithResult:MessageComposeResultSent];

	XCTAssertNoThrow([(id)control verify], @"Verify failed");
}


@end
