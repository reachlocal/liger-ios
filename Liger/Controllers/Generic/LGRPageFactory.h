//
//  LGRPageFactory.h
//  Liger
//
//  Created by John Gustafsson on 11/13/13.
//  Copyright (c) 2013 John Gustafsson. All rights reserved.
//

@class LGRViewController;
@class LGRMenuViewController;

@interface LGRPageFactory : NSObject
+ (LGRMenuViewController*)controllerForMenuPage:(NSString*)page title:(NSString*)title args:(NSDictionary*)args;
+ (UIViewController*)controllerForPage:(NSString*)page title:(NSString*)title args:(NSDictionary*)args parent:(LGRViewController*)parent;
+ (UIViewController*)controllerForDialogPage:(NSString*)page title:(NSString*)title args:(NSDictionary*)args parent:(LGRViewController*)parent;
@end
