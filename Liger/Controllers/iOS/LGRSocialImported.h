//
//  LGRSocialImported.h
//  Liger
//
//  Created by John Gustafsson on 12/4/13.
//  Copyright (c) 2013 John Gustafsson. All rights reserved.
//

@class LGRViewController;

@interface LGRSocialImported : NSObject
+ (UIViewController*)controllerForImportedPage:(NSString*)page title:(NSString*)title args:(NSDictionary*)args parent:(LGRViewController*)parent serviceType:(NSString *)serviceType;

@end
