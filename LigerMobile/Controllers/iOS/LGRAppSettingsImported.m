//
//  RLMMapsImported.m
//  LigerMobile
//
//  Created by John Gustafsson on 11/18/14.
//  Copyright (c) 2014 ReachLocal Inc. All rights reserved.  https://github.com/reachlocal/liger-ios/blob/master/LICENSE
//

#import "LGRAppSettingsImported.h"
#import "LGRViewController.h"

@implementation LGRAppSettingsImported

+ (NSString*)importedPage
{
	return @"appSettings";
}

+ (UIViewController*)controllerForImportedPage:(NSString*)page title:(NSString*)title args:(NSDictionary*)args options:(NSDictionary*)options parent:(LGRViewController*)parent
{
	NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
	[[UIApplication sharedApplication] openURL:url];
	return nil;
}

@end
