//
//  LGRImageImportedTest.m
//  Liger
//
//  Created by John Gustafsson on 7/31/14.
//  Copyright (c) 2014 ReachLocal Inc. All rights reserved.
//

@import XCTest;
#import "LGRImageImported.h"
#import "LGRViewController.h"
#import "OCMock.h"

@interface LGRImageImported()
+ (BOOL)isAlertControllerAvailable;
@end

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
	XCTAssertTrue([image isKindOfClass:UIAlertController.class]);
}

- (void)testControllerForImportedPageiOS7
{
	id alert = OCMClassMock([LGRImageImported class]);
	OCMStub([alert isAlertControllerAvailable]).andReturn(NO);

	id image = [LGRImageImported controllerForImportedPage:@"image" title:nil args:@{} options:@{} parent:nil];

	[alert stopMocking];

	XCTAssertNotNil(image, @"image was not created");
	XCTAssertTrue([image isKindOfClass:UIImagePickerController.class]);
}

- (void)testControllerForImportedPageCamera
{
	id imagePicker = OCMClassMock([UIImagePickerController class]);
	OCMStub([imagePicker isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]).andReturn(YES);

	UIAlertAction *real = [UIAlertAction actionWithTitle:@"Hi" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {}];
	id action = OCMClassMock([UIAlertAction class]);
	OCMExpect([action actionWithTitle:OCMOCK_ANY style:UIAlertActionStyleDefault handler:OCMOCK_ANY]).andDo(^(NSInvocation * invocation){
		void* arg = nil;
		[invocation getArgument:&arg atIndex:4];
		void (^handler)(UIAlertAction *action) = (void (^)(UIAlertAction *action))(__bridge id)(arg);
		handler(nil);
	}).andReturn(real);

	id parent = OCMPartialMock([[LGRViewController alloc] init]);
	OCMStub([parent presentViewController:OCMOCK_ANY animated:YES completion:OCMOCK_ANY]);

	id image = [LGRImageImported controllerForImportedPage:@"image" title:nil args:@{} options:@{} parent:parent];
	XCTAssertNotNil(image, @"image was not created");
	XCTAssertTrue([image isKindOfClass:UIAlertController.class]);
	OCMVerifyAll(action);
}

- (void)testControllerForImportedPageImage
{
	UIAlertAction *real = [UIAlertAction actionWithTitle:@"Hi" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {}];
	id action = OCMClassMock([UIAlertAction class]);
	OCMExpect([action actionWithTitle:OCMOCK_ANY style:UIAlertActionStyleDefault handler:OCMOCK_ANY]).andDo(^(NSInvocation * invocation){
		void* arg = nil;
		[invocation getArgument:&arg atIndex:4];
		void (^handler)(UIAlertAction *action) = (void (^)(UIAlertAction *action))(__bridge id)(arg);
		handler(nil);
	}).andReturn(real);

	id parent = OCMPartialMock([[LGRViewController alloc] init]);
	OCMStub([parent presentViewController:OCMOCK_ANY animated:YES completion:OCMOCK_ANY]);

	id image = [LGRImageImported controllerForImportedPage:@"image" title:nil args:@{} options:@{} parent:parent];
	XCTAssertNotNil(image, @"image was not created");
	XCTAssertTrue([image isKindOfClass:UIAlertController.class]);
	OCMVerifyAll(action);
}

- (void)testControllerForImportedPageCancel
{
	UIAlertAction *real = [UIAlertAction actionWithTitle:@"Hi" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {}];
	id action = OCMClassMock([UIAlertAction class]);
	OCMExpect([action actionWithTitle:OCMOCK_ANY style:UIAlertActionStyleCancel handler:OCMOCK_ANY]).andDo(^(NSInvocation * invocation){
		void* arg = nil;
		[invocation getArgument:&arg atIndex:4];
		void (^handler)(UIAlertAction *action) = (void (^)(UIAlertAction *action))(__bridge id)(arg);
		handler(nil);
	}).andReturn(real);

	id parent = OCMPartialMock([[LGRViewController alloc] init]);
	id image = [LGRImageImported controllerForImportedPage:@"image" title:nil args:@{} options:@{} parent:parent];
	XCTAssertNotNil(image, @"image was not created");
	XCTAssertTrue([image isKindOfClass:UIAlertController.class]);
	OCMVerifyAll(action);
}


@end
