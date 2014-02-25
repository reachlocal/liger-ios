//
//  LGRBrowserViewController.m
//  Liger
//
//  Created by John Gustafsson on 11/13/13.
//  Copyright (c) 2013-2014 ReachLocal Inc. All rights reserved.  https://github.com/reachlocal/liger-ios/blob/master/LICENSE
//

#import "LGRBrowserViewController.h"

@interface LGRBrowserViewController ()
@property (nonatomic, strong) IBOutlet UIWebView* webView;
@end

@implementation LGRBrowserViewController

- (id)initWithPage:(NSString*)page title:(NSString*)title args:(NSDictionary*)args
{
	self = [super initWithPage:page title:title args:args nibName:@"LGRBrowserViewController" bundle:nil];
	if (self) {
		self.toolbarItems = @[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:self action:@selector(goBack:)],
							  [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward target:self action:@selector(goForward:)],
							  [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
							  [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reload:)]];
		
		[self.toolbarItems[0] setEnabled:NO];
		[self.toolbarItems[1] setEnabled:NO];
		[self.toolbarItems[3] setEnabled:NO];
	}
	return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	NSAssert(NO, @"Use initWithPage");
	return nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.args[@"link"]]];
	[self.webView loadRequest:request];
    
    self.webView.scalesPageToFit = [self.args[@"allowZoom"] boolValue];
    
}

- (void)viewWillAppear:(BOOL)animated
{
	[self.navigationController setToolbarHidden:NO animated:animated];
}

- (void)dealloc
{
	// TODO Shared ref counter needed?
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
	return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
	// TODO Shared ref counter needed?
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	[self.toolbarItems[3] setEnabled:NO];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	// TODO Shared ref counter needed?
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

	[self.toolbarItems[0] setEnabled:self.webView.canGoBack];
	[self.toolbarItems[1] setEnabled:self.webView.canGoForward];
	[self.toolbarItems[3] setEnabled:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
	// TODO Shared ref counter needed?
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	[self.toolbarItems[3] setEnabled:YES];
}

- (void)goBack:(id)sender
{
	[self.webView goBack];
}

- (void)goForward:(id)sender
{
	[self.webView goForward];
}

- (void)reload:(id)sender
{
	[self.webView reload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

+ (NSString*)nativePage
{
	return @"browser";
}
@end
