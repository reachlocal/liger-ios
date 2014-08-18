//
//  LGRNavigatorViewController.m
//  LigerMobile
//
//  Created by John Gustafsson on 7/22/14.
//  Copyright (c) 2014 ReachLocal Inc. All rights reserved.  https://github.com/reachlocal/liger-ios/blob/master/LICENSE
//

#import "LGRNavigatorViewController.h"
#import "LGRPageFactory.h"
#import "LGRDrawerViewController.h"

@interface LGRNavigatorViewController () <LGRDrawerViewControllerDelegate>
@property(nonatomic, strong) UINavigationController *navigator;
@property(nonatomic, strong) UIPanGestureRecognizer *navigationBarGesture;
@property(nonatomic, strong) UIScreenEdgePanGestureRecognizer *openGesture;
@property(nonatomic, strong) UIPanGestureRecognizer *closeGesture;
@end

@implementation LGRNavigatorViewController

+ (NSString*)nativePage
{
	return @"navigator";
}

- (id)initWithPage:(NSString*)page title:(NSString*)title args:(NSDictionary*)args options:(NSDictionary*)options
{
	self = [super initWithPage:page
						 title:title
						  args:args
					   options:options];

	if (self) {
		NSMutableArray *pages = [NSMutableArray array];

		NSArray *pageArray = self.args[@"pages"] ?: @[self.args];

		LGRViewController *controller = nil;
		for (NSDictionary *page in pageArray) {
			controller = [LGRPageFactory controllerForPage:page[@"page"]
													 title:page[@"title"]
													  args:page[@"args"]
												   options:page[@"options"]
													parent:controller];

			controller.collectionPage = self;
			if (controller)
				[pages addObject:controller];
		}

		// If we can't create any pages, consider the navigator uncreatable as well.
		if (pages.count == 0)
			return nil;

		self.navigator = [[UINavigationController alloc] init];
		[self.navigator setViewControllers:pages animated:NO];

		[self addChildViewController:self.navigator];
	}
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];

	UIView *navigatorView = self.navigator.view;
	navigatorView.frame = self.view.bounds;
	[self.view addSubview:navigatorView];
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

- (LGRViewController*)rootPage
{
	UIViewController *controller = self.navigator.viewControllers.firstObject;
	NSAssert([controller isKindOfClass:LGRViewController.class], @"Internal error");
	return (LGRViewController*)controller;
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

- (void)pushNotificationTokenUpdated:(NSString *)token error:(NSError *)error
{
	[self.rootPage pushNotificationTokenUpdated:token error:error];
}

- (void)notificationArrived:(NSDictionary *)userInfo background:(BOOL)background
{
	[self.rootPage notificationArrived:userInfo background:background];
}

- (void)handleAppOpenURL:(NSURL*)url
{
	[self.rootPage handleAppOpenURL:url];
}

#pragma mark - The following functions are required to comply with the LGRDrawerViewControllerDelegate protocol.
- (void)setMenuButton:(UIBarButtonItem *)button
 navigationBarGesture:(UIPanGestureRecognizer *)navigationBarGesture
		  openGesture:(UIScreenEdgePanGestureRecognizer *)openGesture
		 closeGesture:(UIPanGestureRecognizer *)closeGesture
{
	self.rootPage.navigationItem.leftBarButtonItem = button;
	self.navigationBarGesture = navigationBarGesture;
	self.openGesture = openGesture;
	self.closeGesture = closeGesture;
}

- (void)useGestures
{
	if (self.navigationBarGesture && ![[self.navigationBar gestureRecognizers] containsObject:self.navigationBarGesture]) {
		[self.navigationBar addGestureRecognizer:self.navigationBarGesture];
	}

	if (self.openGesture && ![[self.rootPage.view gestureRecognizers] containsObject:self.openGesture]) {
		[self.rootPage.view addGestureRecognizer:self.openGesture];
	}
}

- (void)userInteractionEnabled:(BOOL)enabled
{
	self.topPage.view.userInteractionEnabled = enabled;
    
    if (self.rootPage == self.topPage) {
        self.navigationBar.userInteractionEnabled = true;
    } else {
        self.navigationBar.userInteractionEnabled = enabled;
    }

	if (enabled) {
		if (self.openGesture)
			[self.rootPage.view addGestureRecognizer:self.openGesture];
		
		if (self.closeGesture)
			[self.view removeGestureRecognizer:self.closeGesture];
        
        if (self.navigationBarGesture)
            [self.navigationBar addGestureRecognizer:self.navigationBarGesture];
	} else {
		if (self.openGesture)
			[self.rootPage.view removeGestureRecognizer:self.openGesture];
		
		if (self.closeGesture)
			[self.view addGestureRecognizer:self.closeGesture];
        
        if (self.navigationBarGesture)
            [self.navigationBar removeGestureRecognizer:self.navigationBarGesture];
	}
}
@end
