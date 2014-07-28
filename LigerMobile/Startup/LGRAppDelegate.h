//
//  LGRAppDelegate.h
// LigerMobile
//
//  Created by John Gustafsson on 1/11/13.
//  Copyright (c) 2013-2014 ReachLocal Inc. All rights reserved.  https://github.com/reachlocal/liger-ios/blob/master/LICENSE
//

@class LGRViewController;

@interface LGRAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property(nonatomic, weak) LGRViewController* topPage;
@property(nonatomic, readonly) LGRViewController *rootPage;
@end
