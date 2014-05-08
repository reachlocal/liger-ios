//
//  LGRCordovaViewController.m
//  Liger
//
//  Created by John Gustafsson on 2/21/13.
//  Copyright (c) 2013-2014 ReachLocal Inc. All rights reserved.  https://github.com/reachlocal/liger-ios/blob/master/LICENSE
//

#import "LGRCordovaViewController.h"
#import "LGRAppearance.h"
#import "LGRApp.h"
#import "LGRPageFactory.h"

@interface LGRCordovaViewController () {
	LGRViewController *_ligerParent;
}
@property (nonatomic, assign) BOOL toolbarHidden;
@property (nonatomic, strong) NSMutableArray *evalQueue;
@property (nonatomic, assign) BOOL acceptingJS;
@end

@implementation LGRCordovaViewController
@synthesize userCanRefresh = _userCanRefresh;

- (id)initWithPage:(NSString*)page title:(NSString*)title args:(NSDictionary*)args
{
	self = [super init];
	if (self) {
		self.args = args;
		self.title = title;

		self.wwwFolderName = @"app";
		self.startPage = [page hasPrefix:@"http"] ? page : [page stringByAppendingString:@".html"];

		NSArray *pagesWithToolbars = [LGRApp toolbars];
		self.toolbarHidden = ![pagesWithToolbars containsObject:page];

		self.evalQueue = [NSMutableArray arrayWithCapacity:2];

		[[NSNotificationCenter defaultCenter]addObserver:self
												selector:@selector(becameActiveRefresh:)
													name:UIApplicationWillEnterForegroundNotification
												  object:nil];
	}
	return self;
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	UIColor *webBG = [[UIWebView appearance] backgroundColor];
	if (webBG)
		self.webView.backgroundColor = webBG;

	self.webView.allowsInlineMediaPlayback = YES;
	self.webView.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;
	self.webView.dataDetectorTypes = UIDataDetectorTypeNone;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];

	[self.navigationController setToolbarHidden:self.toolbarHidden animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];

	[self refreshPage:NO];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
	self.acceptingJS = NO;
	[super webViewDidStartLoad:webView];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	[super webViewDidFinishLoad:webView];
	self.acceptingJS = YES;
	[self executeQueue];
}

#pragma mark - LGRViewController

- (void)sendArgs:(NSDictionary *)args toJavascript:(NSString*)javascript
{
	NSString *json = @"{}";

	if ([args isKindOfClass:NSDictionary.class]) {
		NSError *error = nil;
		NSData *data = [NSJSONSerialization dataWithJSONObject:args options:0 error:&error];
		json = !error ? [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] : @"{}";
    }

	[self addToQueue:[NSString stringWithFormat:javascript, json]];
	[self executeQueue];
}

- (void)dialogClosed:(NSDictionary *)args
{
	[self sendArgs:args toJavascript:@"PAGE.closeDialogArguments(%@)"];
}

- (void)childUpdates:(NSDictionary *)args
{
	[self sendArgs:args toJavascript:@"PAGE.childUpdates(%@)"];
}

#pragma mark - Refresh

- (void)setUserCanRefresh:(BOOL)userCanRefresh
{
	if (userCanRefresh == _userCanRefresh)
		return;

	_userCanRefresh = userCanRefresh;

	if (_userCanRefresh) {
		self.parentViewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh:)];
	} else {
		self.parentViewController.navigationItem.rightBarButtonItem = nil;
	}
}

- (BOOL)userCanRefresh
{
	return _userCanRefresh;
}

- (void)refresh:(id)sender
{
	[self refreshPage:YES];
}

- (void)becameActiveRefresh:(NSNotification*)notification
{
	if (self.navigationController.visibleViewController == self) {
		[self refreshPage:NO];
	}
}

- (void)refreshPage:(BOOL)wasInitiatedByUser
{
	if (wasInitiatedByUser) {
		NSString *js = [NSString stringWithFormat:@"PAGE.refresh(%@);", wasInitiatedByUser ? @"true" : @"false"];

		[self addToQueue:js];
		[self executeQueue];
	}
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return [LGRAppearance statusBarDialog];
}

- (void)pageWillAppear
{
	NSString *js = @"if(PAGE.onPageAppear) PAGE.onPageAppear();";

	[self addToQueue:js];
	[self executeQueue];
}

- (void)pushNotificationTokenUpdated:(NSString *)token error:(NSError *)error
{
	NSString *js = @"if(PAGE.pushNotificationTokenUpdated) PAGE.pushNotificationTokenUpdated('%@', 'iOSDeviceToken', '%@');";
	js = [NSString stringWithFormat:js, token ? token : @"", error ? [error localizedDescription] : @""];

	[self addToQueue:js];
	[self executeQueue];
}

- (void)notificationArrived:(NSDictionary *)userInfo background:(BOOL)background
{
	NSError *error = nil;
	NSData *json = [NSJSONSerialization dataWithJSONObject:userInfo options:0 error:&error];

	NSString *js = @"if(PAGE.notificationArrived) PAGE.notificationArrived(%@, '%@');";
	js = [NSString stringWithFormat:js, [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding],
		  background ? @"true" : @"false"];

	[self addToQueue:js];
	[self executeQueue];
}

- (void)handleAppOpenURL:(NSURL*)url
{
	NSString *js = @"if(PAGE.handleAppOpenURL) PAGE.handleAppOpenURL('%@');";
	js = [NSString stringWithFormat:js, url];

	[self addToQueue:js];
	[self executeQueue];
}


- (void)addToQueue:(NSString*)js
{
	[self.evalQueue addObject:js];
}

- (void)executeQueue
{
	if (self.acceptingJS && self.evalQueue.count) {
		dispatch_async(dispatch_get_main_queue(), ^{
			while (self.evalQueue.count) {
				NSString* js = [self.evalQueue firstObject];
				[self.webView stringByEvaluatingJavaScriptFromString:js];
				[self.evalQueue removeObjectAtIndex:0];
			}
		});
	}
}

@end
