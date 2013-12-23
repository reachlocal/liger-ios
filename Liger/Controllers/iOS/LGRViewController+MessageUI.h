//
//  LGRViewController+MessageUI.h
//  Liger
//
//  Created by John Gustafsson on 11/18/13.
//  Copyright (c) 2013 John Gustafsson. All rights reserved.
//

#import "LGRViewController.h"
@import MessageUI;

@interface LGRViewController (MessageUI) <MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate, UINavigationControllerDelegate>
@end
