//
//  LGRHTMLMenuViewController.m
//  Liger
//
//  Created by John Gustafsson on 11/25/13.
//  Copyright (c) 2013-2014 ReachLocal Inc. All rights reserved.  https://github.com/reachlocal/liger-ios/blob/master/LICENSE
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
	self.cordova.view.frame = self.view.bounds; // Only needed for iOS 6
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

- (void)pushNotificationTokenUpdated:(NSString *)token error:(NSError *)error
{
	NSString *js = @"if(PAGE.pushNotificationTokenUpdated) PAGE.pushNotificationTokenUpdated('%@', 'iOSDeviceToken', '%@');";
	js = [NSString stringWithFormat:js, token, error ? [error localizedDescription] : @""];
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
		[self.cordova.webView stringByEvaluatingJavaScriptFromString:js];
	});
}

- (void)notificationArrived:(NSDictionary *)userInfo background:(BOOL)background
{
	NSError *error = nil;
	NSData *json = [NSJSONSerialization dataWithJSONObject:userInfo options:0 error:&error];

	NSString *js = @"if(PAGE.notificationArrived) PAGE.notificationArrived('%@', '%@');";
	js = [NSString stringWithFormat:js, [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding], background ? @"true" : @"false"];

	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
		[self.cordova.webView stringByEvaluatingJavaScriptFromString:js];
	});
}

@end
