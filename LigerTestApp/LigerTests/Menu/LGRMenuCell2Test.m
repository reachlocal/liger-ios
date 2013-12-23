//
//  LGRMenuCell2Test.m
//  Liger
//
//  Created by John Gustafsson on 12/23/13.
//  Copyright (c) 2013 John Gustafsson. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LGRMenuCell2.h"

@interface LGRMenuCell2Test : XCTestCase
@property (nonatomic, strong) LGRMenuCell2 *cell;
@end

@implementation LGRMenuCell2Test

- (void)setUp
{
    [super setUp];
	self.cell = [[LGRMenuCell2 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
	[self.cell setNeedsLayout]; // Called directly only for tests so that the appearance protocol kicks in
	[self.cell layoutIfNeeded];
}

- (void)tearDown
{
	self.cell = nil;
    [super tearDown];
}

- (void)testMenuName
{
	XCTAssertNotNil(self.cell.menuName, @"The cell has no menu label");
}

- (void)testMenuDetail
{
	XCTAssertNotNil(self.cell.menuDetail, @"The cell has no menu label");
}

- (void)testMenu1TextColor
{
	XCTAssertNil(self.cell.menu2TextColor, @"Cell isn't in a menu and shouldn't have a color");
}

- (void)testMenu1TextColorSelected
{
	XCTAssertNil(self.cell.menu2TextColorSelected, @"Cell isn't in a menu and shouldn't have a color");
}

- (void)testMenuNameFont
{
	XCTAssertNil(self.cell.menuNameFont, @"Cell isn't in a menu and shouldn't have a font");
}

- (void)testMenuDetailFont
{
	XCTAssertNil(self.cell.menuDetailFont, @"Cell isn't in a menu and shouldn't have a font");
}

@end
