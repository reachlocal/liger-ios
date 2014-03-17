//
//  LGRImportedViewController.h
//  Liger
//
//  Created by John Gustafsson on 12/4/13.
//  Copyright (c) 2013-2014 ReachLocal Inc. All rights reserved.  https://github.com/reachlocal/liger-ios/blob/master/LICENSE
//

@class LGRViewController;

@protocol LGRImportedViewController
+ (NSString*)importedPage;
+ (UIViewController*)controllerForImportedPage:(NSString*)page title:(NSString*)title args:(NSDictionary*)args parent:(LGRViewController*)parent;
@end
