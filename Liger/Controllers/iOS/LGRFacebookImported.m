//
//  LGRFacebookImported.m
//  Liger
//
//  Created by John Gustafsson on 12/4/13.
//  Copyright (c) 2013 John Gustafsson. All rights reserved.
//

#import "LGRFacebookImported.h"
@import Social;

@implementation LGRFacebookImported

+ (NSString*)importedPage
{
	return @"facebook";
}

+ (UIViewController*)controllerForImportedPage:(NSString*)page title:(NSString*)title args:(NSDictionary*)args parent:(LGRViewController*)parent
{
	return [self controllerForImportedPage:page title:title args:args parent:parent serviceType:SLServiceTypeFacebook];
}

@end
