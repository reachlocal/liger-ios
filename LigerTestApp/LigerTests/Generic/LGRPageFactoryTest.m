//
//  LGRPageFactoryTest.m
// LigerMobile
//
//  Created by John Gustafsson on 11/26/13.
//  Copyright (c) 2013-2014 ReachLocal Inc. All rights reserved.  https://github.com/reachlocal/liger-ios/blob/master/LICENSE
//

@import XCTest;
#import "LGRPageFactory.h"
#import "LGRMenuViewController.h"

// From LGRPageFactory.m
@interface LGRPageFactory ()
@property (nonatomic, strong) NSDictionary *menuPages;
@property (nonatomic, strong) NSDictionary *nativePages;
@end

@interface LGRPageFactoryTest : XCTestCase

@end

@implementation LGRPageFactoryTest

- (void)testInit
{
	LGRPageFactory *factory = [[LGRPageFactory alloc] init];
	
	XCTAssertTrue(factory.menuPages[@"appMenu"], @"The menu pages are missing appMenu");
	XCTAssertFalse(factory.nativePages[@"appMenu"], @"The natives pages shouldn't include appMenu");
	
	XCTAssertTrue(factory.nativePages[@"browser"], @"The native pages are missing browser");
}

- (void)testMenuFactory
{
	LGRMenuViewController* controller = [LGRPageFactory controllerForMenuPage:@"appMenu"
																		title:@"menu"
																		 args:@{}
																	  options:@{}];
	
	XCTAssertNotNil(controller, @"controller failed to be created");
	XCTAssertEqualObjects(controller.title, @"menu", @"Title wasn't properly set");
	XCTAssertEqualObjects(controller.page, @"appMenu", @"Page wasn't properly set");
	XCTAssertEqualObjects(controller.args, @{}, @"Page shouldn have empty args");
	XCTAssertEqualObjects(controller.options, @{}, @"Page shouldn have empty args");
}

- (void)testPageFactory
{
	UIViewController* controller = [LGRPageFactory controllerForPage:@"browser"
															   title:@"Internet"
																args:@{@"link": @"http://www.example.com"}
															 options:@{}
															  parent:nil];
	
	XCTAssertNotNil(controller, @"controller failed to be created");
	XCTAssertEqualObjects(controller.title, @"Internet", @"Title wasn't properly set");
}

- (void)testPageDialogFactory
{
	UIViewController* controller = [LGRPageFactory controllerForDialogPage:@"browser"
																	 title:@"Internet"
																	  args:@{@"link": @"http://www.example.com"}
																   options:@{}
																	parent:nil];
	
	XCTAssertNotNil(controller, @"controller failed to be created");
	XCTAssertEqualObjects(controller.title, @"Internet", @"Title wasn't properly set");
}

@end
