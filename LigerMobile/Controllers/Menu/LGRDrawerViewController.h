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

/** @name Protocol: LGRDrawerViewControllerDelegate */

/**
 * This protocol can be used for any view controller that can be contained
 * in a drawer view controller. Implementing these methods will allow the
 * user to slide the menu in and out, as if it were a drawer.
 */
@protocol LGRDrawerViewControllerDelegate
/** 
 * Setter for menu button and open/close gestures.
 *
 * @param button The button that opens the drawer.
 * @param navigationBarGesture The gesture to open the drawer using the navigation bar.
 * @param openGesture The gesture to open the drawer using the view.
 * @param closeGesture The gesture to close the drawer. Can be passed in as nil.
 */
- (void)setMenuButton:(UIBarButtonItem *)button
 navigationBarGesture:(UIPanGestureRecognizer *)navigationBarGesture
          openGesture:(UIScreenEdgePanGestureRecognizer *)openGesture
         closeGesture:(UIPanGestureRecognizer *)closeGesture;

/**
 * Adds gestures to the view controller.
 */
- (void)useGestures;

/**
 * Enables or disables user interaction with the view while the drawer is
 * being opened or closed. Also adds and removes gestures depending upon the 
 * state of the drawer.
 *
 * @param enabled The boolean stating if user interaction is enabled.
 */
- (void)userInteractionEnabled:(BOOL)enabled;
@end