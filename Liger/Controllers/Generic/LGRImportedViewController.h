//
//  LGRImportedViewController.h
//  Liger
//
//  Created by John Gustafsson on 12/4/13.
//  Copyright (c) 2013 John Gustafsson. All rights reserved.
//

@class LGRViewController;

@protocol LGRImportedViewController
+ (NSString*)importedPage;
+ (UIViewController*)controllerForImportedPage:(NSString*)page title:(NSString*)title args:(NSDictionary*)args parent:(LGRViewController*)parent;
@end
