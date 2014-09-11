//
//  LGRWebKitViewController.m
//  Pods
//
//  Created by John Gustafsson on 8/25/14.
//
//

#import "LGRWebKitViewController.h"
#import "LGRViewController.h"
#import "LGRAppearance.h"
#import "LGRApp.h"
#import "LGRBlock.h"

@import WebKit;

@interface LGRWebKitViewController () <WKScriptMessageHandler>
@property (nonatomic, assign) BOOL toolbarHidden;
@property (nonatomic, strong) NSMutableArray *evalQueue;
@property (nonatomic, assign) BOOL acceptingJS;
@property (nonatomic, strong) NSString *page;
@property (nonatomic, strong) NSDictionary *args;

@property (nonatomic, strong) NSMutableArray *toolbarCallbacks;
@property (readonly) WKWebView *webView;
@end

@implementation LGRWebKitViewController

- (id)initWithPage:(NSString*)page title:(NSString*)title args:(NSDictionary*)args options:(NSDictionary*)options
{
	self = [super init];
	if (self) {
		self.args = args;
		self.title = title;
		self.page = page;

		self.toolbarHidden = ![[LGRApp toolbars] containsObject:page];

		self.evalQueue = [NSMutableArray arrayWithCapacity:2];
	}
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];

	self.automaticallyAdjustsScrollViewInsets = YES;

	// Seems like UIWebView and WKWebView doesn't honour the backgroundColor properly
	UIColor *webBG = [[WKWebView appearance] backgroundColor];
	if (webBG)
		self.webView.backgroundColor = webBG;

	NSURL *url = [[NSBundle mainBundle] URLForResource:self.page withExtension:@"html" subdirectory:@"app"];
	[self.webView loadRequest:[[NSURLRequest alloc] initWithURL:url]];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];

	[self.navigationController setToolbarHidden:self.toolbarHidden animated:YES];
}

- (void)loadView
{
	NSString *js = [NSString stringWithFormat:@"window.webkit.messageHandlers.ready.postMessage([]);"];
	WKUserScript *ready = [[WKUserScript alloc] initWithSource:js
												injectionTime:WKUserScriptInjectionTimeAtDocumentEnd
											 forMainFrameOnly:YES];

	WKUserContentController *userContentController = [[WKUserContentController alloc] init];
	[userContentController addUserScript:ready];
	[userContentController addScriptMessageHandler:self name:@"ready"];

	[userContentController addScriptMessageHandler:self name:@"openPage"];
	[userContentController addScriptMessageHandler:self name:@"openDialog"];
	[userContentController addScriptMessageHandler:self name:@"closePage"];
	[userContentController addScriptMessageHandler:self name:@"closeDialog"];

	[userContentController addScriptMessageHandler:self name:@"updateParent"];

	[userContentController addScriptMessageHandler:self name:@"getPageArgs"];
	[userContentController addScriptMessageHandler:self name:@"toolbar"];

	WKWebViewConfiguration *conf = [[WKWebViewConfiguration alloc] init];
	conf.userContentController = userContentController;
	conf.allowsInlineMediaPlayback = YES;
	//	conf.dataDetectorTypes = UIDataDetectorTypeNone; // TODO: Oddly seems to be missing

	WKWebView *web = [[WKWebView alloc] initWithFrame:CGRectZero configuration:conf];
	web.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;

	[self setView:web];
}

- (WKWebView*)webView
{
	return (WKWebView*)self.view;
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage*)message
{
	NSLog(@"%@", message.name);

	if ([message.name isEqualToString:@"ready"]) {
		self.acceptingJS = YES;
		[self executeQueue];
	}

	if ([message.name isEqualToString:@"openPage"]) {
		[[self ligerViewController] openPage:message.body[0]
									   title:message.body[1]
										args:message.body[2]
									 options:message.body[3]
									  parent:[self ligerViewController]
									 success:^{}
										fail:^{}];
	}

	if ([message.name isEqualToString:@"openDialog"]) {
		[self.ligerViewController openDialog:message.body[0]
									   title:message.body[1]
										args:message.body[2]
									 options:message.body[3]
									  parent:self.ligerViewController
									 success:^{}
										fail:^{}];
	}

	if ([message.name isEqualToString:@"closePage"]) {
		[[self ligerViewController] closePage:[message.body count] > 0 ? message.body[0] : nil
									  success:^{}
										 fail:^{}];
	}

	if ([message.name isEqualToString:@"closeDialog"]) {
		[[self ligerViewController] closeDialog:message.body[0]
										success:^{}
										   fail:^{}];
	}

	if ([message.name isEqualToString:@"updateParent"]) {
		[self.ligerViewController updateParent:message.body[0] args:message.body[1] success:^{} fail:^{}];
	}

	if ([message.name isEqualToString:@"getPageArgs"]) {
		[self sendPageArgs];
	}

	if ([message.name isEqualToString:@"toolbar"]) {
		NSArray *items = [message.body isKindOfClass:NSArray.class] ? (NSArray*)message.body[0] : @[];
		self.ligerViewController.toolbarItems = [self buildToolbar:items];
	}
}

- (void)sendPageArgs
{
	NSString *json = @"{}";

	if ([self.args isKindOfClass:NSDictionary.class]) {
		NSError *error = nil;
		NSData *data = [NSJSONSerialization dataWithJSONObject:self.args options:0 error:&error];
		if (!error) {
			json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		}
	}

	NSString *js = [NSString stringWithFormat:@"PAGE.gotPageArgs(%@);", json];
	[self.webView evaluateJavaScript:js completionHandler:^(id result, NSError *error) {}];
}

- (LGRViewController*)ligerViewController
{
	NSAssert([self.parentViewController isKindOfClass:LGRViewController.class], @"Internal Liger webkit renderer error");
	return (LGRViewController*)self.parentViewController;
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
				[self.webView evaluateJavaScript:js completionHandler:^(id result, NSError *error) {
					// TODO: Should we do something here?
				}];
				[self.evalQueue removeObjectAtIndex:0];
			}
		});
	}
}

- (NSArray*)buildToolbar:(NSArray*)items
{
	self.toolbarCallbacks = [NSMutableArray array];
	NSMutableArray *toolbarItems = [NSMutableArray arrayWithCapacity:items.count];

	for (NSDictionary *item in items) {
		if (!toolbarItems.count) {
			[toolbarItems addObject:[[UIBarButtonItem  alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil]];
		}

		WKWebView *web = self.webView;

		LGRBlock *block = [[LGRBlock alloc] initWithBlock:^{
			dispatch_async(dispatch_get_main_queue(), ^{
				[web evaluateJavaScript:item[@"callback"] completionHandler:^(id s, NSError *e) {}];
			});
		}];
		[self.toolbarCallbacks addObject:block];

		UIBarButtonItem *button = [[UIBarButtonItem  alloc] initWithTitle:item[@"iconText"]
																	style:UIBarButtonItemStylePlain
																   target:block
																   action:@selector(invoke)];

		[toolbarItems addObject:button];
		[toolbarItems addObject:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil]];
	}
	return toolbarItems;
}

@end
