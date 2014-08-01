//
//  LGRViewController+UIImagePickerControllerDelegate.m
//  LigerMobile
//
//  Created by John Gustafsson on 11/18/13.
//  Copyright (c) 2013-2014 ReachLocal Inc. All rights reserved.  https://github.com/reachlocal/liger-ios/blob/master/LICENSE
//

#import "LGRViewController+UIImagePickerControllerDelegate.h"

@implementation LGRViewController (UIImagePickerControllerDelegate)

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	NSString *url = [info[UIImagePickerControllerMediaURL] absoluteString];
	if (!url)
		url = [info[UIImagePickerControllerReferenceURL] absoluteString];

	if (!url)
		url = @"";

	NSDictionary *metaData = info[UIImagePickerControllerMediaMetadata]? : @{};
	NSString *type = info[UIImagePickerControllerMediaType] ?: @"";

	[self dismissViewControllerAnimated:YES completion:^{
		[self dialogClosed:@{@"MediaType": type, @"URL": url, @"MetaData": metaData}];
	}];
}

@end
