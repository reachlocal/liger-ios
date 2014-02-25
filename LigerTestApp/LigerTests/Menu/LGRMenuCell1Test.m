//
//  LGRMenuCell1Test.m
//  Liger
//
//  Created by John Gustafsson on 12/23/13.
//  Copyright (c) 2013-2014 ReachLocal Inc. All rights reserved.  https://github.com/reachlocal/liger-ios/blob/master/LICENSE
//

@import XCTest;
#import "OCMock.h"

#import "LGRMenuCell1.h"

@interface LGRMenuCell1 (Tests)
- (UIColor*)selectedColor;
@end

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

- (void)testSelectedColor
{
	XCTAssertEqual([[[UIView alloc] init] tintColor], [self.cell selectedColor], @"Should have the tint color as basis.");
}

- (void)testSelectedColorSet
{
	self.cell.menu1TextColorSelected = UIColor.greenColor;
	XCTAssertEqual(UIColor.greenColor, [self.cell selectedColor], @"Should have the same color as menu1TextColorSelected.");
}

- (BOOL)doNotRespondToSelector:(SEL)selector
{
	if (selector == @selector(tintColor))
		return NO;

	XCTFail(@"This should never happen, fix the test.");
	return YES;
}

- (void)testSelectedColoriOS6
{
	id cell = [OCMockObject partialMockForObject:self.cell];
	[[[cell stub] andCall:@selector(doNotRespondToSelector:) onObject:self] respondsToSelector:@selector(tintColor)];

	XCTAssertNil([cell selectedColor], @"iOS doesnt' respond to tint color and thus the color should be nil.");
}

@end
