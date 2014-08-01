//
//  LGRViewController+UIImagePickerControllerDelegateTest.m
//  Liger
//
//  Created by John Gustafsson on 7/31/14.
//  Copyright (c) 2014 ReachLocal Inc. All rights reserved.
//

@import XCTest;
#import "LGRViewController+UIImagePickerControllerDelegate.h"
#import "LGRViewController.h"
#import "OCMock.h"

@interface LGRViewController_UIImagePickerControllerDelegateTest : XCTestCase
@property(nonatomic, strong) LGRViewController *controller;
@end

@implementation LGRViewController_UIImagePickerControllerDelegateTest

- (void)setUp
{
    [super setUp];
	self.controller = [[LGRViewController alloc] init];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testDidFinishPickingMediaWithInfo
{
	id controller = OCMPartialMock(self.controller);
	OCMExpect([controller dismissViewControllerAnimated:YES completion:OCMOCK_ANY]).andDo(^(NSInvocation *invocation){
		void (^completion)(void) = nil;
		[invocation getArgument:&completion atIndex:3];

		completion();
	});

	OCMExpect([controller dialogClosed:OCMOCK_ANY]);

	[controller imagePickerController:nil didFinishPickingMediaWithInfo:@{}];

	OCMVerifyAll(controller);
}
@end
