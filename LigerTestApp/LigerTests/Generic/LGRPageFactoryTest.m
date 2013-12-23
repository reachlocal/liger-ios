//
//  LGRPageFactoryTest.m
//  Liger
//
//  Created by John Gustafsson on 11/26/13.
//  Copyright (c) 2013 John Gustafsson. All rights reserved.
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
	
	
	NSLog(@"%@", [factory nativePages]);
}

- (void)testMenuFactory
{
	LGRMenuViewController* controller = [LGRPageFactory controllerForMenuPage:@"appMenu"
																		title:@"menu"
																		 args:nil];
	
	XCTAssertNotNil(controller, @"controller failed to be created");
	XCTAssertEqualObjects(controller.title, @"menu", @"Title wasn't properly set");
	XCTAssertEqualObjects(controller.page, @"appMenu", @"Page wasn't properly set");
	XCTAssertNil(controller.args,@"Page shouldn't have args");
}

- (void)testPageFactory
{
	UIViewController* controller = [LGRPageFactory controllerForPage:@"browser"
															   title:@"Internet"
																args:@{@"link": @"http://www.example.com"}
															  parent:nil];
	
	XCTAssertNotNil(controller, @"controller failed to be created");
	XCTAssertEqualObjects(controller.title, @"Internet", @"Title wasn't properly set");
}

- (void)testPageDialogFactory
{
	UIViewController* controller = [LGRPageFactory controllerForDialogPage:@"browser"
																	 title:@"Internet"
																	  args:@{@"link": @"http://www.example.com"}
																	parent:nil];
	
	XCTAssertNotNil(controller, @"controller failed to be created");
	XCTAssertEqualObjects(controller.title, @"Internet", @"Title wasn't properly set");
}

@end
