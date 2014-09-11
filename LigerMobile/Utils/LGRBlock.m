//
//  LGRBlock.m
//  Pods
//
//  Created by John Gustafsson on 8/26/14.
//
//

#import "LGRBlock.h"

@implementation LGRBlock

- (id)initWithBlock:(void (^)())block
{
	self = [super init];
	if (self) {
		_block = block;
	}
	return self;
}

- (void)invoke
{
	_block();
}

@end
