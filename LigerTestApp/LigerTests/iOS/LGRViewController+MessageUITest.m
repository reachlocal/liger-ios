//
//  LGRViewController+MessageUITest.m
// LigerMobile
//
//  Created by John Gustafsson on 12/5/13.
//  Copyright (c) 2013-2014 ReachLocal Inc. All rights reserved.  https://github.com/reachlocal/liger-ios/blob/master/LICENSE
//

#import "LGRViewController+MessageUI.h"
#import "OCMock.h"

@import XCTest;

@interface LGRViewController_MessageUITest : XCTestCase

@end

@implementation LGRViewController_MessageUITest


- (void)testEmailClosing
{
	LGRViewController *control = [[LGRViewController alloc] initWithPage:@"testPage" title:nil args:@{} options:@{}];
	control = [OCMockObject partialMockForObject:control];

	[[((id)control) expect] dismissViewControllerAnimated:YES completion:OCMOCK_ANY];

	[control mailComposeController:nil didFinishWithResult:MFMailComposeResultSent error:nil];
	
	XCTAssertNoThrow([(id)control verify], @"Verify failed");
}

- (void)testMessageClosing
{
	LGRViewController *control = [[LGRViewController alloc] initWithPage:@"testPage" title:nil args:@{} options:@{}];
	control = [OCMockObject partialMockForObject:control];
	
	[[((id)control) expect] dismissViewControllerAnimated:YES completion:OCMOCK_ANY];
	
	[control messageComposeViewController:nil didFinishWithResult:MessageComposeResultSent];

	XCTAssertNoThrow([(id)control verify], @"Verify failed");
}


@end
