//
//  LGRMenuCell.m
//  Liger
//
//  Created by John Gustafsson on 4/30/13.
//  Copyright (c) 2013 ReachLocal, Inc. All rights reserved.
//

#import "LGRMenuCell2.h"

#import <QuartzCore/QuartzCore.h>

CG_INLINE CGFloat LGRDeltaX(CGRect outer, CGRect inner)
{
	return floorf((outer.size.width - inner.size.width)/2);
}

CG_INLINE CGFloat LGRDeltaY(CGRect outer, CGRect inner)
{
	return floorf((outer.size.height - inner.size.height)/2);
}

@implementation UIView (Rects)

- (void)leftTopInRect:(CGRect)rect
{
	[self sizeToFit];
	self.frame = CGRectMake(rect.origin.x, rect.origin.y, self.frame.size.width, self.frame.size.height);
}

- (void)leftCenterInRect:(CGRect)rect
{
	[self sizeToFit];
	self.frame = CGRectMake(rect.origin.x, rect.origin.y + LGRDeltaY(rect, self.frame), self.frame.size.width, self.frame.size.height);
}

- (void)centerCenterInRect:(CGRect)rect
{
	[self sizeToFit];
	self.frame = CGRectMake(LGRDeltaX(rect, self.frame), LGRDeltaY(rect, self.frame), self.frame.size.width, self.frame.size.height);
}

- (void)rightCenterInRect:(CGRect)rect
{
	[self sizeToFit];
	self.frame = CGRectMake(rect.origin.x + (rect.size.width - self.frame.size.width), rect.origin.y + LGRDeltaY(rect, self.frame), self.frame.size.width, self.frame.size.height);
}

@end
@interface LGRMenuCell2 ()
@property(nonatomic, assign) UITableViewCellStyle style;
@end

@implementation LGRMenuCell2
@synthesize menuName = _menuName;
@synthesize menuDetail = _menuDetail;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
		self.style = style;
		
		_menuName = [[UILabel alloc] initWithFrame:CGRectZero];
		_menuName.backgroundColor = UIColor.clearColor;
		[self addSubview:_menuName];
		
		_menuDetail = [[UILabel alloc] initWithFrame:CGRectZero];
		_menuDetail.backgroundColor = UIColor.clearColor;
		[self addSubview:_menuDetail];
		
		self.backgroundColor = UIColor.clearColor;
    }
    return self;
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	
	if (!self.menuNameFont)
		return;

	_menuName.font = self.menuNameFont;
	_menuDetail.font = self.menuDetailFont;

	CGFloat width = 11;
	
	CGRect frame = self.bounds;
	frame.origin.x += width;
	frame.size.width -= width;
	

	if (_menuDetail.text.length)
		frame.size.height = roundf(frame.size.height/2);

	[_menuName leftCenterInRect:frame];

	frame.origin.y += frame.size.height;

	[_menuDetail leftTopInRect:frame];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

	if (selected) {
		_menuName.textColor = [self selectedColor];
		_menuDetail.textColor = [self selectedColor];
	} else {
		_menuName.textColor = self.menu2TextColor;
		_menuDetail.textColor = self.menu2TextColor;
	}
}

- (UIColor*)selectedColor
{
	if (self.menu2TextColorSelected)
		return self.menu2TextColorSelected;
	
	if ([self respondsToSelector:@selector(tintColor)])
		return self.tintColor;
	
	return nil;
}

@end
