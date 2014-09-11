//
//  LGRCordovaViewController.h
//  LigerMobile
//
//  Created by John Gustafsson on 2/21/13.
//  Copyright (c) 2013-2014 ReachLocal Inc. All rights reserved.  https://github.com/reachlocal/liger-ios/blob/master/LICENSE
//

#import "CDVViewController.h"
#import "LGRHTMLEngine.h"

@interface LGRCordovaViewController : CDVViewController <LGRHTMLEngine>

- (id)initWithPage:(NSString*)page title:(NSString*)title args:(NSDictionary*)args options:(NSDictionary*)options;

@end
