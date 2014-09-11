//
//  LGRHTMLViewController.m
//  LigerMobile
//
//  Created by John Gustafsson on 11/18/13.
//  Copyright (c) 2013-2014 ReachLocal Inc. All rights reserved.  https://github.com/reachlocal/liger-ios/blob/master/LICENSE
//

#import "LGRHTMLViewController.h"
#import "LGRCordovaViewController.h"
#import "LGRWebKitViewController.h"
#import "LGRHTMLEngine.h"

@import WebKit;

@interface LGRHTMLViewController ()
@property (nonatomic, strong) UIViewController<LGRHTMLEngine> *engine;
@end

@implementation LGRHTMLViewController

- (id)initWithPage:(NSString*)page title:(NSString*)title args:(NSDictionary*)args options:(NSDictionary *)options
{
	self = [super initWithPage:page title:title args:args options:options];
	if (self) {
		self.engine = [LGRHTMLViewController renderFactory:@[@"webkit", @"cordova"] page:page title:title args:args options:options];
		[self addChildViewController:self.engine];
	}
	return self;
}

+ (UIViewController<LGRHTMLEngine>*)renderFactory:(NSArray*)renderers page:(NSString*)page title:(NSString*)title args:(NSDictionary*)args options:(NSDictionary *)options
{
	for (NSString *render in renderers) {
		if ([render caseInsensitiveCompare:@"webkit"] == NSOrderedSame) {
			if (LGRWebKitViewController.class) {
				return [[LGRWebKitViewController alloc] initWithPage:page title:title args:args options:options];
			}
		}

		if ([render caseInsensitiveCompare:@"cordova"] == NSOrderedSame) {
			return [[LGRCordovaViewController alloc] initWithPage:page title:title args:args options:options];
		}
	}
	return nil; // Shouldn't happen
}

- (void)viewDidLoad
{
	[super viewDidLoad];

	[self.view addSubview:self.engine.view];
	self.engine.view.frame = self.view.bounds;
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
}

- (void)sendArgs:(NSDictionary *)args toJavascript:(NSString*)javascript
{
	NSString *json = @"{}";

	if ([args isKindOfClass:NSDictionary.class]) {
		NSError *error = nil;
		NSData *data = [NSJSONSerialization dataWithJSONObject:args options:0 error:&error];
		json = !error ? [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] : @"{}";
	}

	[self.engine addToQueue:[NSString stringWithFormat:javascript, json]];
	[self.engine executeQueue];
}

- (void)dialogClosed:(NSDictionary *)args
{
	[self sendArgs:args toJavascript:@"PAGE.closeDialogArguments(%@)"];
}

- (void)childUpdates:(NSDictionary *)args
{
	[self sendArgs:args toJavascript:@"PAGE.childUpdates(%@)"];
}

- (NSDictionary*)args
{
	return self.engine.args;
}

- (void)pageWillAppear
{
	[super pageWillAppear];

	NSString *js = @"if(PAGE.onPageAppear) PAGE.onPageAppear();";

	[self.engine addToQueue:js];
	[self.engine executeQueue];
}

- (void)pushNotificationTokenUpdated:(NSString *)token error:(NSError *)error
{
	NSString *js = @"if(PAGE.pushNotificationTokenUpdated) PAGE.pushNotificationTokenUpdated('%@', 'iOSDeviceToken', '%@');";
	js = [NSString stringWithFormat:js, token ? token : @"", error ? [error localizedDescription] : @""];

	[self.engine addToQueue:js];
	[self.engine executeQueue];
}

- (void)notificationArrived:(NSDictionary *)userInfo background:(BOOL)background
{
	NSError *error = nil;
	NSData *json = [NSJSONSerialization dataWithJSONObject:userInfo options:0 error:&error];

	NSString *js = @"if(PAGE.notificationArrived) PAGE.notificationArrived(%@, '%@');";
	js = [NSString stringWithFormat:js, [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding],
		  background ? @"true" : @"false"];

	[self.engine addToQueue:js];
	[self.engine executeQueue];
}

- (void)handleAppOpenURL:(NSURL*)url
{
	NSString *js = @"if(PAGE.handleAppOpenURL) PAGE.handleAppOpenURL('%@');";
	js = [NSString stringWithFormat:js, url];

	[self.engine addToQueue:js];
	[self.engine executeQueue];
}

- (void)buttonTapped:(NSDictionary*)button
{
	NSString *js = @"if(PAGE.headerButtonTapped) PAGE.headerButtonTapped('%@');";
	js = [NSString stringWithFormat:js, button[@"button"]];

	[self.engine addToQueue:js];
	[self.engine executeQueue];
}

@end
