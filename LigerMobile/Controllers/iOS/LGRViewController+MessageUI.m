//
//  LGRViewController+MessageUI.m
//  Liger
//
//  Created by John Gustafsson on 11/18/13.
//  Copyright (c) 2013-2014 ReachLocal Inc. All rights reserved.  https://github.com/reachlocal/liger-ios/blob/master/LICENSE
//

#import "LGRViewController+MessageUI.h"

@implementation LGRViewController (MessageUI) 

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
	[self dismissViewControllerAnimated:YES completion:^{
		NSString *errorString = error ? error.debugDescription : @"";
		[self dialogClosed:@{@"result": [NSNumber numberWithInteger:result], @"error": errorString}];
	}];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
	[self dismissViewControllerAnimated:YES completion:^{
		[self dialogClosed:@{@"result": [NSNumber numberWithInteger:result]}];
	}];
}

@end
