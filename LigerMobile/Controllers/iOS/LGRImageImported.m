//
//  LGRImageImported.m
// LigerMobile
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
	UIImagePickerController *picker = [[UIImagePickerController alloc] init];
	picker.delegate = parent;
	
	return picker;	
}

@end
