//
//  LGRDrawerViewController.h
//  LigerMobile
//
//  Created by John Gustafsson on 2/20/13.
//  Copyright (c) 2013-2014 ReachLocal Inc. All rights reserved.  https://github.com/reachlocal/liger-ios/blob/master/LICENSE
//

#import "LGRViewController.h"

@interface LGRDrawerViewController : LGRViewController
- (void)resetApp;
@end

// This protocol can be used for any view controller that can be contained
// in a drawer view controller. Implementing these methods will allow the
// user to slide the menu in and out, as if it were a drawer.
@protocol LGRDrawerViewControllerDelegate
// Setter for menu button and open/close gestures.
// This function should only be called once!
// closeGesture is allowed to be nil.
- (void)setMenuButton:(UIBarButtonItem *)button
       menuBarGesture:(UIPanGestureRecognizer *)menuBarGesture
          OpenGesture:(UIPanGestureRecognizer *)openGesture
         closeGesture:(UIPanGestureRecognizer *)closeGesture;

// Add gestures to the view.
// This should be called whenever a new page comes into view.
- (void)useGestures;

// Enable or disable user interaction with the view controller while the
// drawer is closed or open. Also, add or remove gestures depending on
// whether the drawer is closed or open.
- (void)userInteractionEnabled:(BOOL)enabled;
@end