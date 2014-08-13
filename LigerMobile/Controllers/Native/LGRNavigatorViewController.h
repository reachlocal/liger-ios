//
//  LGRNavigatorViewController.h
//  Pods
//
//  Created by John Gustafsson on 7/22/14.
//
//  Copyright (c) 2014 ReachLocal Inc. All rights reserved.  https://github.com/reachlocal/liger-ios/blob/master/LICENSE
//

#import "LGRViewController.h"
#import "LGRDrawerViewController.h"

@interface LGRNavigatorViewController : LGRViewController <LGRDrawerViewControllerDelegate>
@property(readonly) LGRViewController *rootPage;
@property(readonly) LGRViewController *topPage;
@property(nonatomic,readonly) UINavigationBar *navigationBar;
@end
