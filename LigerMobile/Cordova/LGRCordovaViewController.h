//
//  LGRCordovaViewController.h
//  Liger
//
//  Created by John Gustafsson on 2/21/13.
//  Copyright (c) 2013-2014 ReachLocal Inc. All rights reserved.  https://github.com/reachlocal/liger-ios/blob/master/LICENSE
//

#import "CDVViewController.h"

@interface LGRCordovaViewController : CDVViewController
@property (nonatomic, assign) BOOL userCanRefresh;
@property (nonatomic, strong) NSDictionary *args;

// LGRViewController

- (id)initWithPage:(NSString*)page title:(NSString*)title args:(NSDictionary*)args;

- (void)dialogClosed:(NSDictionary*)args;
- (void)childUpdates:(NSDictionary*)args;
- (void)refreshPage:(BOOL)wasInitiatedByUser;
@end
