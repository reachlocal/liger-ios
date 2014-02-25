//
//  LGRViewController+UIImagePickerControllerDelegate.m
//  Liger
//
//  Created by John Gustafsson on 11/18/13.
//  Copyright (c) 2013-2014 ReachLocal Inc. All rights reserved.  https://github.com/reachlocal/liger-ios/blob/master/LICENSE
//

#import "LGRViewController+UIImagePickerControllerDelegate.h"

@implementation LGRViewController (UIImagePickerControllerDelegate)
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
	
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	NSString *url = [info[UIImagePickerControllerMediaURL] absoluteString];
	if (!url)
		url = [info[UIImagePickerControllerReferenceURL] absoluteString];

	if (!url)
		url = @"";

	NSDictionary *metaData = info[UIImagePickerControllerMediaMetadata];
	if (!metaData) {
		metaData = @{};
	}
	
	[self dismissViewControllerAnimated:YES completion:^{
		[self dialogClosed:@{@"MediaType": info[UIImagePickerControllerMediaType], @"URL": url, @"MetaData": metaData}];
	}];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	
}

@end
