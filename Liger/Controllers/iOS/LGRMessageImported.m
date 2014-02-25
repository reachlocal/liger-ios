//
//  LGRMessageImported.m
//  Liger
//
//  Created by John Gustafsson on 12/4/13.
//  Copyright (c) 2013-2014 ReachLocal Inc. All rights reserved.  https://github.com/reachlocal/liger-ios/blob/master/LICENSE
//

#import "LGRMessageImported.h"
#import "LGRViewController+MessageUI.h"

@import MessageUI;
@class LGRViewController;

@implementation LGRMessageImported

+ (NSString*)importedPage
{
	return @"message";
}

+ (UIViewController*)controllerForImportedPage:(NSString*)page title:(NSString*)title args:(NSDictionary*)args parent:(LGRViewController*)parent
{
	MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];

	picker.recipients = [self recipientsArray:args[@"recipients"]];
	picker.subject = args[@"subject"];
	picker.body = args[@"body"];
	
	picker.delegate = parent;
	
	return picker;
}

+ (NSArray*)recipientsArray:(NSString*)string
{
	if (!string || !string.length) {
		return @[];
	}
	
	NSPredicate *noEmpty = [NSPredicate predicateWithFormat:@"SELF.length > 0"];
	
	NSArray *array = [string componentsSeparatedByString:@","].mutableCopy;
	NSMutableArray *trimmedArray = [NSMutableArray arrayWithCapacity:array.count];
	[array enumerateObjectsUsingBlock:^(NSString *email, NSUInteger idx, BOOL *stop) {
		[trimmedArray addObject:[email stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
	}];
	
	return [trimmedArray filteredArrayUsingPredicate:noEmpty];
}


@end
