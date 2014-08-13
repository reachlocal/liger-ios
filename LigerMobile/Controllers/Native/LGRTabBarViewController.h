//
//  LGRTabBarViewController.h
//  Pods
//
//  Created by Gary Moon on 8/13/14.
//  Copyright (c) 2014 ReachLocal Inc. All rights reserved.  https://github.com/reachlocal/liger-ios/blob/master/LICENSE
//

#import "LGRViewController.h"
#import "LGRDrawerViewController.h"

@interface LGRTabBarViewController : LGRViewController <LGRDrawerViewControllerDelegate, UITabBarControllerDelegate>
@property(readonly) LGRViewController *rootPage;
@end
