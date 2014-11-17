//
//  LGRImageImported.m
//  LigerMobile
//
//  Created by John Gustafsson on 12/4/13.
//  Copyright (c) 2013-2014 ReachLocal Inc. All rights reserved.  https://github.com/reachlocal/liger-ios/blob/master/LICENSE
//

#import "LGRImageImported.h"
#import "LGRViewController+UIImagePickerControllerDelegate.h"

@implementation LGRImageImported

+ (NSString*)importedPage
{
	return @"image";
}

+ (UIViewController*)controllerForImportedPage:(NSString*)page title:(NSString*)title args:(NSDictionary*)args options:(NSDictionary*)options parent:(LGRViewController*)parent
{
	if (![self isAlertControllerAvailable]) {
		UIImagePickerController *picker = [[UIImagePickerController alloc] init];
		picker.delegate = parent;

		return picker;
	}

	return [self alertController:parent];
}

+ (BOOL)isAlertControllerAvailable
{
	return [UIAlertController class];
}

+ (UIAlertController*)alertController:(LGRViewController *)parent
{
	UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];

	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
		[alertController addAction:[UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
			UIImagePickerController *picker = [[UIImagePickerController alloc] init];
			picker.sourceType = UIImagePickerControllerSourceTypeCamera;
			picker.delegate = parent;
			[parent presentViewController:picker animated:YES completion:nil];
		}]];
	}

	[alertController addAction:[UIAlertAction actionWithTitle:@"Photo Library" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
		UIImagePickerController *picker = [[UIImagePickerController alloc] init];
		picker.delegate = parent;
		[parent presentViewController:picker animated:YES completion:nil];
	}]];

	[alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {

	}]];


	return alertController;
}

@end
