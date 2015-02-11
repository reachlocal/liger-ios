//
//  LGRTabContainerController.m
//  LigerMobile
//
//  Created by John Gustafsson on 1/07/15.
//  Copyright (c) 2013-2015 ReachLocal Inc. All rights reserved.  https://github.com/reachlocal/liger-ios/blob/master/LICENSE
//

#import "LGRTabContainerController.h"
#import "LGRPageFactory.h"
#import "LGRViewController.h"

#import "LGRApp.h"

@interface LGRTabContainerView : UIView
@property (nonatomic, strong) UIView *page;
@property (nonatomic, strong) UIView *tab;
@property (assign) CGFloat tabHeight;
@end

@implementation LGRTabContainerView

- (void)setTab:(UIView *)tab
{
	_tab = tab;
	[self addSubview:tab];
}

- (void)setPage:(UIView *)page
{
	_page = page;
	[self addSubview:page];
}

- (void)layoutSubviews
{
	CGRect pageRect = self.bounds;
	pageRect.size.height -= self.tabHeight;
	self.page.frame = pageRect;

	CGRect tabRect = self.bounds;
	tabRect.origin.y = tabRect.size.height - self.tabHeight;
	tabRect.size.height = self.tabHeight;
	self.tab.frame = tabRect;
}

@end


@interface LGRTabContainerController ()
@property (nonatomic, strong) NSMutableDictionary *pages;
@property (nonatomic, strong) LGRViewController *tab;
@end

@implementation LGRTabContainerController

- (id)initWithPage:(NSString *)page title:(NSString *)title args:(NSDictionary *)args options:(NSDictionary*)options
{
	self = [super initWithPage:page title:title args:args options:options];
	if (self) {
		self.pages = [NSMutableDictionary dictionary];
		CGFloat tabHeight = [options[@"tabHeight"] doubleValue] ?: 44;
		[[self tabContainerView] setTabHeight:tabHeight];
	}
	return self;
}

+ (NSString*)nativePage
{
	return @"tabcontainer";
}

- (void)addPage:(LGRViewController*)controller
{
	[self addChildViewController:controller];
	[self tabContainerView].page = controller.view;

	// iOS 7 but not iOS 8 (8 doesn't need it so don't fire the event needlessly)
	if (![self respondsToSelector:@selector(extensionContext)] && [self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
		[self setNeedsStatusBarAppearanceUpdate];
	}
}

- (void)addTabController
{
	NSMutableDictionary *args = [self.args[@"args"] mutableCopy];
	if (self.args[@"notification"]) {
		args[@"notification"] = self.args[@"notification"];
	}

	self.tab = [LGRPageFactory controllerForPage:self.args[@"page"] title:self.args[@"title"] args:args options:self.args[@"options"] parent:nil];
	self.tab.collectionPage = self;

	[self addChildViewController:self.tab];
	[self tabContainerView].tab = self.tab.view;
}

- (void)viewDidLoad
{
	[super viewDidLoad];

	[self addTabController];
}

- (void)loadView
{
	self.view = [[LGRTabContainerView alloc] init];
}

- (void)resetApp
{
	[self.pages removeAllObjects];

	for (UIViewController* controller in self.childViewControllers) {
		[controller removeFromParentViewController];
		[[controller view] removeFromSuperview];
	}

	self.tab = nil;

	[self addTabController];
}

#pragma mark - LGRViewController

- (void)openPage:(NSString*)page title:(NSString*)title args:(NSDictionary*)args options:(NSDictionary*)options parent:(LGRViewController*)parent success:(void (^)())success fail:(void (^)())fail
{
	id cached = options[@"cached"];
	BOOL useCache = [cached isKindOfClass:NSNumber.class] ? [cached boolValue] : YES;
	NSString *reuseIdentifier = options[@"reuseIdentifier"];

	LGRViewController *controller = useCache ? self.pages[reuseIdentifier] : nil;
	if (!controller) {
		controller = [LGRPageFactory controllerForPage:page title:title args:args options:options parent:parent];
		if (controller)
			self.pages[reuseIdentifier] = controller;
	}

	// Couldn't create a new view controller
	if (!controller) {
		fail();
		return;
	}

	[self displayController:controller];
	success();
}

- (void)displayController:(LGRViewController*)controller {
	if (controller == [self pageController]) {
		return;
	}

	if (![self pageController]) {
		[self addPage:controller];
		controller.view.frame = self.view.bounds;
		return;
	}

	UIViewController *old = [self pageController];
	[old.view removeFromSuperview];
	[old removeFromParentViewController];
	[self addPage:controller];
};

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

#pragma mark - helpers

- (LGRViewController*)pageController
{
	if(self.childViewControllers.count < 2)
		return nil;
	
	return self.childViewControllers[1];
}

- (void)pushNotificationTokenUpdated:(NSString *)token error:(NSError *)error
{
	[self.tab pushNotificationTokenUpdated:token error:error];
}

- (void)notificationArrived:(NSDictionary*)userInfo state:(UIApplicationState)state
{
	[self.tab notificationArrived:userInfo state:state];
}

- (void)handleAppOpenURL:(NSURL*)url
{
	[self.tab handleAppOpenURL:url];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
	return [[self pageController] preferredStatusBarStyle];
}

- (LGRTabContainerView*)tabContainerView
{
	return (LGRTabContainerView*)self.view;
}

@end
