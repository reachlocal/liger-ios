//
//  LGRHTMLViewController.m
//  Liger
//
//  Created by John Gustafsson on 11/18/13.
//  Copyright (c) 2013-2014 ReachLocal Inc. All rights reserved.  https://github.com/reachlocal/liger-ios/blob/master/LICENSE
//

#import "LGRHTMLViewController.h"
#import "LGRCordovaViewController.h"

@interface LGRHTMLViewController ()
@property (readonly) LGRCordovaViewController *cordova;
@end

@implementation LGRHTMLViewController
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
	
	// iOS 7 properly lays self.cordova.view out, iOS 6.x does not so we help by setting the frame in that case.
	if (![self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
		self.cordova.view.frame = self.view.bounds;
	}
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

- (void)pageWillAppear
{
	[super pageWillAppear];

	NSString *js = @"if(PAGE.onPageAppear) PAGE.onPageAppear();";
	[self.cordova.webView stringByEvaluatingJavaScriptFromString:js];
}

@end
