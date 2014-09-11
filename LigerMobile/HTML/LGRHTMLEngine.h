//
//  LGRHTMLEngine.h
//  LigerMobile
//
//  Created by John Gustafsson on 8/25/14.
//  Copyright (c) 2014 ReachLocal Inc. All rights reserved.  https://github.com/reachlocal/liger-ios/blob/master/LICENSE
//

@protocol LGRHTMLEngine
@property (readonly) NSDictionary *args;

- (void)addToQueue:(NSString*)js;
- (void)executeQueue;
@end
