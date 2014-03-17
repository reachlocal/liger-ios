//
//  LGRViewController+MessageUI.h
//  Liger
//
//  Created by John Gustafsson on 11/18/13.
//  Copyright (c) 2013-2014 ReachLocal Inc. All rights reserved.  https://github.com/reachlocal/liger-ios/blob/master/LICENSE
//

#import "LGRViewController.h"
@import MessageUI;

@interface LGRViewController (MessageUI) <MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate, UINavigationControllerDelegate>
@end
