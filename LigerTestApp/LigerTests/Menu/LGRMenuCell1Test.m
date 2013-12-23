//
//  LGRMenuCell1Test.m
//  Liger
//
//  Created by John Gustafsson on 12/23/13.
//  Copyright (c) 2013 John Gustafsson. All rights reserved.
//

@import XCTest;

#import "LGRMenuCell1.h"

@interface LGRMenuCell1Test : XCTestCase
@property (nonatomic, strong) LGRMenuCell1 *cell;
@end

@implementation LGRMenuCell1Test

- (void)setUp
{
    [super setUp];
	self.cell = [[LGRMenuCell1 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
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

- (void)testMenu1TextColor
{
	XCTAssertNil(self.cell.menu1TextColor, @"Cell isn't in a menu and shouldn't have a color");
}

- (void)testMenu1TextColorSelected
{
	XCTAssertNil(self.cell.menu1TextColorSelected, @"Cell isn't in a menu and shouldn't have a color");
}

- (void)testMenuNameFont
{
	XCTAssertNil(self.cell.menuNameFont, @"Cell isn't in a menu and shouldn't have a font");
}

@end
