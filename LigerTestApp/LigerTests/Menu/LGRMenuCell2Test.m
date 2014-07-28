//
//  LGRMenuCell2Test.m
//  LigerMobile
//
//  Created by John Gustafsson on 12/23/13.
//  Copyright (c) 2013-2014 ReachLocal Inc. All rights reserved.  https://github.com/reachlocal/liger-ios/blob/master/LICENSE
//

#import <XCTest/XCTest.h>
#import "LGRMenuCell2.h"
#import "OCMock.h"

@interface LGRMenuCell2 (Tests)
- (UIColor*)textColor:(BOOL)selected;
@end

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

- (void)testTextColor
{
	XCTAssertNil([self.cell textColor:NO], @"Should be nil.");
}

- (void)testTextColorSet
{
	self.cell.menu2TextColor = UIColor.greenColor;
	XCTAssertEqual(UIColor.greenColor, [self.cell textColor:NO], @"Should be the same as menu2TextColor.");
}

- (void)testSelectedColor
{
	XCTAssertEqual([[[UIView alloc] init] tintColor], [self.cell textColor:YES], @"Should have the tint color as basis.");
}

- (void)testSelectedColorSet
{
	self.cell.menu2TextColorSelected = UIColor.greenColor;
	XCTAssertEqual(UIColor.greenColor, [self.cell textColor:YES], @"Should be the same as menu2TextColorSelected.");
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
	
	XCTAssertNil([cell textColor:YES], @"iOS6 doesn't respond to tint color and thus the color should be nil.");
}

@end
