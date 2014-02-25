//
//  LGREmailImported.m
//  Liger
//
//  Created by John Gustafsson on 12/4/13.
//  Copyright (c) 2013-2014 ReachLocal Inc. All rights reserved.  https://github.com/reachlocal/liger-ios/blob/master/LICENSE
//

#import "LGREmailImported.h"
#import "LGRViewController+MessageUI.h"

@import MessageUI;
@class LGRViewController;

@implementation LGREmailImported

+ (NSString*)importedPage
{
	return @"email";
}

+ (UIViewController*)controllerForImportedPage:(NSString*)page title:(NSString*)title args:(NSDictionary*)args parent:(LGRViewController*)parent
{
	NSString* toRecipientsString = args[@"toRecipients"];
	NSString* ccRecipientsString = args[@"ccRecipients"];
	NSString* bccRecipientsString = args[@"bccRecipients"];
	NSString* subject = args[@"subject"];
	NSString* body = args[@"body"];
	BOOL html = [args[@"html"] boolValue];
	
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = parent;
	
	NSArray *to = [self recipientsArray:toRecipientsString];
	NSArray *cc = [self recipientsArray:ccRecipientsString];
	NSArray *bcc = [self recipientsArray:bccRecipientsString];
	
	if (subject)
		[picker setSubject:subject];
	if (body)
		[picker setMessageBody:body isHTML:html];
	
	[picker setToRecipients:to];
	[picker setCcRecipients:cc];
	[picker setBccRecipients:bcc];
	
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