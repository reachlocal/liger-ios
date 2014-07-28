//
//  LGRNavigatorViewController.m
//  Pods
//
//  Created by John Gustafsson on 7/22/14.
//  Copyright (c) 2014 ReachLocal Inc. All rights reserved.  https://github.com/reachlocal/liger-ios/blob/master/LICENSE
//

#import "LGRNavigatorViewController.h"
#import "LGRPageFactory.h"

@interface LGRNavigatorViewController ()
@property(nonatomic, strong) UINavigationController *navigator;
@property(nonatomic, strong) LGRViewController *rootPage;
@end

@implementation LGRNavigatorViewController

+ (NSString*)nativePage
{
	return @"navigator";
}

- (id)initWithPage:(NSString*)page title:(NSString*)title args:(NSDictionary*)args options:(NSDictionary*)options
{
	self = [self initWithPage:page
						title:title
						 args:args
					  options:options
					  nibName:@"LGRNavigatorViewController"
					   bundle:nil];

	self.rootPage = [LGRPageFactory controllerForPage:self.args[@"page"]
												title:self.args[@"title"]
												 args:self.args[@"args"]
											  options:self.args[@"options"]
											   parent:nil];
	// If we can't create a root page, consider the navigator uncreatable as well.
	if (!self.rootPage)
		return nil;

	self.rootPage.collectionPage = self;
	self.navigator = [[UINavigationController alloc] initWithRootViewController:self.rootPage];

	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];

	[self addChildViewController:self.navigator];
	[self.view addSubview:self.navigator.view];
}

- (void)openPage:(NSString*)page title:(NSString*)title args:(NSDictionary*)args options:(NSDictionary*)options parent:(LGRViewController*)parent success:(void (^)())success fail:(void (^)())fail
{
	// Internal error, we couldn't find the navigation controller or we aren't at the top of the navigation stack
	if (!self.navigator || self.navigator.topViewController != parent) {
		fail();
		return;
	}

	LGRViewController *new = [LGRPageFactory controllerForPage:page title:title args:args options:options parent:parent];

	// Couldn't create a new view controller
	if (!new) {
		fail();
		return;
	}

	new.collectionPage = self;

	[self.navigator pushViewController:new animated:YES];
	success();
}

- (void)closePage:(NSString*)rewindTo sourcePage:(LGRViewController*)sourcePage success:(void (^)())success fail:(void (^)())fail
{
	if (!self.navigator) {
		fail();
		return;
	}

	if (rewindTo) {
		LGRViewController *page = sourcePage.parentPage;

		while (page) {
			if ([page.page isEqualToString:rewindTo]) {
				if ([[self.navigator popToViewController:page animated:YES] count]) {
					success();
				} else {
					fail();
				}
				return;
			}
			page = page.parentPage;
		}
	} else if (self.navigator.topViewController == sourcePage) {
		if ([self.navigator popViewControllerAnimated:YES]) {
			success();
			return;
		}
	}

	fail();
}

- (void)openDialog:(NSString *)page title:(NSString*)title args:(NSDictionary*)args options:(NSDictionary*)options parent:(LGRViewController*)parent success:(void (^)())success fail:(void (^)())fail
{
	UIViewController *new = [LGRPageFactory controllerForDialogPage:page title:title args:args options:options parent:parent];

	// Couldn't create a new view controller, possibly a broken plugin
	if (!new) {
		fail();
		return;
	}

	[self presentViewController:new animated:YES completion:^{
		success();
	}];
}

- (void)dialogClosed:(NSDictionary*)args
{
	[self.parentPage dialogClosed:args];
}

- (LGRViewController*)topPage
{
	UIViewController *controller = self.navigator.topViewController;
	NSAssert([controller isKindOfClass:LGRViewController.class], @"Internal error");
	return (LGRViewController*)controller;
}

- (UINavigationBar*)navigationBar
{
	return self.navigator.navigationBar;
}
@end
