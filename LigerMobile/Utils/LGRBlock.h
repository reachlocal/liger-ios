//
//  LGRBlock.h
//  Pods
//
//  Created by John Gustafsson on 8/26/14.
//
//

@import Foundation;

@interface LGRBlock : NSObject {
	void (^_block)();
}
- (id)initWithBlock:(void (^)())block;
- (void)invoke;
@end
