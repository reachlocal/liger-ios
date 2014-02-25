//
//  LGRSocialImported.m
//  Liger
//
//  Created by John Gustafsson on 12/4/13.
//  Copyright (c) 2013-2014 ReachLocal Inc. All rights reserved.  https://github.com/reachlocal/liger-ios/blob/master/LICENSE
//

#import "LGRSocialImported.h"
#import "LGRViewController.h"

@import Social;

@implementation LGRSocialImported

+ (UIViewController*)controllerForImportedPage:(NSString*)page title:(NSString*)title args:(NSDictionary*)args parent:(LGRViewController*)parent serviceType:(NSString *)serviceType;
{
	// TODO Make into option for args
	//	if (![SLComposeViewController isAvailableForServiceType:serviceType])
	//		return nil;
	
	SLComposeViewController *social = [SLComposeViewController composeViewControllerForServiceType:serviceType];
	[social setInitialText:args[@"text"]];
	
	social.completionHandler = ^(SLComposeViewControllerResult result) {
		// iOS doesn't guarantee which thread we are in
		dispatch_async(dispatch_get_main_queue(), ^{
			[parent dialogClosed:@{@"result": [NSNumber numberWithInteger:result]}];
		});
	};
	
	return social;
}

@end
