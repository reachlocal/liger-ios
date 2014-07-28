//
//  LGRPageFactoryTest.m
// LigerMobile
//
//  Created by John Gustafsson on 11/26/13.
//  Copyright (c) 2013-2014 ReachLocal Inc. All rights reserved.  https://github.com/reachlocal/liger-ios/blob/master/LICENSE
//

@import XCTest;
#import "LGRPageFactory.h"
#import "LGRViewController.h"
#import "LGRNavigatorViewController.h"
#import "LGRImportedViewController.h"

#import <MessageUI/MessageUI.h>

// From LGRPageFactory.m
@interface LGRPageFactory ()
@property (nonatomic, strong) NSDictionary *nativePages;
@property (nonatomic, strong) NSDictionary *importedPages;

+ (LGRPageFactory*)shared;
+ (BOOL)hasHTMLPage:(NSString*)page;
@end


@interface FailedImported : NSObject <LGRImportedViewController>
@end

@implementation FailedImported

+ (NSString*)importedPage
{
	return nil;
}

+ (UIViewController*)controllerForImportedPage:(NSString*)page title:(NSString*)title args:(NSDictionary*)args options:(NSDictionary*)options parent:(LGRViewController*)parent
{
	return nil;
}

@end

@interface LGRPageFactoryTest : XCTestCase

@end

@implementation LGRPageFactoryTest

- (void)testInit
{
	[LGRPageFactory alloc];
	LGRPageFactory *factory = [LGRPageFactory shared];
	
	XCTAssertTrue(factory.nativePages[@"appMenu"], @"The native pages are missing appMenu");
	XCTAssertFalse(factory.importedPages[@"appMenu"], @"The imported pages shouldn't include appMenu");
	
	XCTAssertTrue(factory.nativePages[@"browser"], @"The native pages are missing browser");
	XCTAssertFalse(factory.importedPages[@"appMenu"], @"The imported pages shouldn't include appMenu");
}

- (void)testPageFactory
{
	LGRViewController* controller = [LGRPageFactory controllerForPage:@"browser"
															   title:@"Internet"
																args:@{@"link": @"http://www.example.com"}
															 options:@{}
															  parent:nil];
	
	XCTAssertNotNil(controller, @"controller failed to be created");
	XCTAssertEqualObjects(controller.title, @"Internet", @"Title wasn't properly set");
}

- (void)testPageDialogFactory
{
	id controller = [LGRPageFactory controllerForDialogPage:@"browser"
													  title:@"Internet"
													   args:@{@"link": @"http://www.example.com"}
													options:@{}
													 parent:nil];


	XCTAssertTrue([controller isKindOfClass:LGRNavigatorViewController.class], @"Title should create a navigator");
	XCTAssertEqualObjects([[controller topPage] title], @"Internet", @"Title wasn't properly set");
}

- (void)testPageDialogFactoryNoTitle
{
	id controller = [LGRPageFactory controllerForDialogPage:@"browser"
													  title:nil
													   args:@{@"link": @"http://www.example.com"}
													options:@{}
													 parent:nil];


	XCTAssertFalse([controller isKindOfClass:LGRNavigatorViewController.class], @"No title should nott create a navigator");
	XCTAssertTrue([controller isKindOfClass:LGRViewController.class], @"No title should create a Liger View Controller");
}

- (void)testPageDialogFactoryImported
{
	id controller = [LGRPageFactory controllerForDialogPage:@"email"
													  title:@"Email"
													   args:@{}
													options:@{}
													 parent:nil];


	XCTAssertTrue([controller isKindOfClass:[MFMailComposeViewController class]], @"Should have created a MFMailComposeViewController");
}

- (void)testHasHTMLPage
{
	XCTAssertTrue([LGRPageFactory hasHTMLPage:@"http://reachlocal.github.io/liger/"], @"http should be true");
	XCTAssertTrue([LGRPageFactory hasHTMLPage:@"firstPage"], @"firstPage should be true");
	XCTAssertFalse([LGRPageFactory hasHTMLPage:@"we_don't_have_a_page_called_this"], @"No page like that should be found");
}

@end
