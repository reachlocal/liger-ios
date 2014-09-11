//
//  LGRCordovaViewController.m
//  LigerMobile
//
//  Created by John Gustafsson on 2/21/13.
//  Copyright (c) 2013-2014 ReachLocal Inc. All rights reserved.  https://github.com/reachlocal/liger-ios/blob/master/LICENSE
//

#import "LGRCordovaViewController.h"
#import "LGRAppearance.h"
#import "LGRApp.h"

@interface LGRCordovaViewController ()
@property (nonatomic, assign) BOOL toolbarHidden;
@property (nonatomic, strong) NSMutableArray *evalQueue;
@property (nonatomic, assign) BOOL acceptingJS;
@property (nonatomic, strong) NSDictionary *args;
@end

@implementation LGRCordovaViewController

- (id)initWithPage:(NSString*)page title:(NSString*)title args:(NSDictionary*)args options:(NSDictionary*)options
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
	}
	return self;
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
