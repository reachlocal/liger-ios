//
//  LGRViewController+MessageUITest.m
//  LigerMobile
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
	id control = OCMPartialMock([[LGRViewController alloc] initWithPage:@"testPage" title:nil args:@{} options:@{}]);

	OCMExpect([control dismissViewControllerAnimated:YES completion:OCMOCK_ANY]).andDo(^(NSInvocation *invocation){
		void (^completion)(void) = nil;
		[invocation getArgument:&completion atIndex:3];

		completion();
	});

	[control mailComposeController:nil didFinishWithResult:MFMailComposeResultSent error:nil];

	OCMVerifyAll(control);
}

- (void)testMessageClosing
{
	id control = OCMPartialMock([[LGRViewController alloc] initWithPage:@"testPage" title:nil args:@{} options:@{}]);

	OCMExpect([control dismissViewControllerAnimated:YES completion:OCMOCK_ANY]).andDo(^(NSInvocation *invocation){
		void (^completion)(void) = nil;
		[invocation getArgument:&completion atIndex:3];

		completion();
	});

	[control messageComposeViewController:nil didFinishWithResult:MessageComposeResultSent];

	OCMVerifyAll(control);
}


@end
