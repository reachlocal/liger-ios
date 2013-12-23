//
//  LGRHTMLMenuViewController.m
//  Liger
//
//  Created by John Gustafsson on 11/25/13.
//  Copyright (c) 2013 John Gustafsson. All rights reserved.
//

#import "LGRHTMLMenuViewController.h"
#import "LGRCordovaViewController.h"

@interface LGRHTMLMenuViewController ()
@property (readonly) LGRCordovaViewController *cordova;
@end

@implementation LGRHTMLMenuViewController
@synthesize cordova = _cordova;

- (id)initWithPage:(NSString*)page title:(NSString*)title args:(NSDictionary*)args
{
	self = [super initWithPage:page title:title args:args];
	if (self) {
		_cordova = [[LGRCordovaViewController alloc] initWithPage:page title:title args:args];
		[self addChildViewController:_cordova];
	}
	return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.view addSubview:self.cordova.view];
}

- (void)dialogClosed:(NSDictionary*)args
{
	[self.cordova dialogClosed:args];
}

- (void)childUpdates:(NSDictionary*)args
{
	[self.cordova childUpdates:args];
}

- (void)refreshPage:(BOOL)wasInitiatedByUser
{
	[self.cordova refreshPage:wasInitiatedByUser];
}

- (NSDictionary*)args
{
	return self.cordova.args;
}

- (void)setUserCanRefresh:(BOOL)userCanRefresh
{
	self.cordova.userCanRefresh = userCanRefresh;
}

- (BOOL)userCanRefresh
{
	return self.cordova.userCanRefresh;
}

@end
