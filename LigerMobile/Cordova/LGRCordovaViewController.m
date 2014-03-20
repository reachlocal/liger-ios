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

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
	return [super webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
	[super webView:webView didFailLoadWithError:error];
	NSLog(@"%@", error);
}

#pragma mark - LGRViewController

- (void)sendArgs:(NSDictionary *)args toJavascript:(NSString*)javascript
{
	if ([args isKindOfClass:NSDictionary.class]) {
		NSError *error = nil;
		NSData *data = [NSJSONSerialization dataWithJSONObject:args options:0 error:&error];
		NSString *json = !error ? [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] : @"{}";
		[self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:javascript, json]];
	} else {
        [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:javascript, @"{}"]];
    }
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
		NSString *javascript = [NSString stringWithFormat:@"PAGE.refresh(%@);", wasInitiatedByUser ? @"true" : @"false"];
		[self.webView stringByEvaluatingJavaScriptFromString:javascript];
	}
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return [LGRAppearance statusBarDialog];
}

@end
