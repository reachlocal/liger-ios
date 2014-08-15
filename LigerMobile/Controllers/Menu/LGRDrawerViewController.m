//
//  LGRDrawerViewController.m
//  LigerMobile
//
//  Created by John Gustafsson on 2/20/13.
//  Copyright (c) 2013-2014 ReachLocal Inc. All rights reserved.  https://github.com/reachlocal/liger-ios/blob/master/LICENSE
//

#import "LGRDrawerViewController.h"
#import "LGRPageFactory.h"
#import "LGRViewController.h"

#import "LGRAppearance.h"
#import "LGRApp.h"

#import "LGRAppMenuViewController.h"

#define OPENWIDTH (320-57)
// If we have this velocity or more we open/close the menu regardless of how far it has moved
#define MINVELOCITY 50
// If we haven't travelled at least this far, don't open the menu
#define MINPOINTSTOOPEN 50
// If we haven't travelled at least this far, don't close the menu
#define MINPOINTSTOCLOSE 120

@interface LGRDrawerViewController ()
@property (nonatomic, strong) UIPanGestureRecognizer *navigationBarGesture;
@property (nonatomic, strong) UIScreenEdgePanGestureRecognizer *openGesture;
@property (nonatomic, strong) UIPanGestureRecognizer *closeGesture;
@property (nonatomic, strong) NSMutableDictionary *pages;
@property (nonatomic, strong) LGRViewController *menu;
@end

@implementation LGRDrawerViewController

- (id)initWithPage:(NSString *)page title:(NSString *)title args:(NSDictionary *)args options:(NSDictionary*)options
{
	self = [super initWithPage:page title:title args:args options:options];
	if (self) {
        //if (NSClassFromString(@"UIScreenEdgePanGestureRecognizer"))
		self.navigationBarGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(menuOpen:)];
		self.openGesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(menuOpen:)];
		self.closeGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(menuClose:)];
		self.pages = [NSMutableDictionary dictionary];
        
        self.openGesture.edges = UIRectEdgeLeft;
	}
	return self;
}

+ (NSString*)nativePage
{
	return @"drawer";
}

- (void)addPage:(LGRViewController*)controller
{
	if ([controller conformsToProtocol:@protocol(LGRDrawerViewControllerDelegate)]) {
        UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:@"Menu"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(displayMenu:)];
        id<LGRDrawerViewControllerDelegate> page = (id<LGRDrawerViewControllerDelegate>) controller;
		[page setMenuButton:button
       navigationBarGesture:self.navigationBarGesture
				openGesture:self.openGesture
			   closeGesture:self.closeGesture];
		[page useGestures];
	}

	[self addChildViewController:controller];
	[self.view addSubview:controller.view];
}

- (void)addMenuController
{
	self.menu = [LGRPageFactory controllerForPage:self.args[@"page"] title:self.args[@"title"] args:self.args[@"args"] options:self.args[@"options"] parent:nil];
	self.menu.collectionPage = self;

	[self addChildViewController:self.menu];
	[self.view addSubview:self.menu.view];
	[self.view sendSubviewToBack:self.menu.view];

	self.menu.view.frame = self.view.bounds;
}

- (void)viewDidLoad
{
	[super viewDidLoad];

	[self addMenuController];
}

- (void)resetApp
{
	[self.pages removeAllObjects];

	for (UIViewController* controller in self.childViewControllers) {
		[controller removeFromParentViewController];
		[[controller view] removeFromSuperview];
	}

	[self addMenuController];
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
	if (![self pageController]) {
		[self addPage:controller];
		controller.view.frame = self.view.bounds;
		return;
	}

	if (controller == [self pageController]) {
		[self toggleMenu];
		return;
	}

	[self addPage:controller];
	controller.view.frame = CGRectOffset(self.view.bounds, self.view.bounds.size.width, 0);

	[self fromRight:controller old:[self pageController]];
};

- (void)openDialog:(NSString *)page title:(NSString*)title args:(NSDictionary*)args options:(NSDictionary*)options parent:(LGRViewController*)parent success:(void (^)())success fail:(void (^)())fail
{
	UIViewController *new = [LGRPageFactory controllerForDialogPage:page title:title args:args options:options parent:parent];

	// Couldn't create a new view controller, possibly a broken plugin
	if (!new) {
		fail();
		return;
	}

	__weak LGRDrawerViewController *me = self;
	[self presentViewController:new animated:YES completion:^{
		success();
		[me toggleMenu];
	}];
}

#pragma mark - menu

- (void)toggleMenu
{
	[self toggle:[self pageController]];
}

- (void)displayMenu:(id)sender
{
	[self toggleMenu];
}

- (void)toggle:(UIViewController*)controller
{
	CGRect frame = controller.view.frame;

	if (frame.origin.x == 0)
		[self.menu viewWillAppear:YES];

	[self userInteractionEnabled:NO controller:controller];
	[UIView animateWithDuration:0.2f
						  delay:0.0f
						options:UIViewAnimationOptionCurveEaseInOut
					 animations:^{
						 if (frame.origin.x == 0) {
							 controller.view.frame = CGRectOffset(frame, OPENWIDTH, 0);
						 } else {
							 CGRect newFrame = frame;
							 newFrame.origin.x = 0;
							 controller.view.frame = newFrame;
						 }
					 }
					 completion:^(BOOL finished) {
						 if (controller.view.frame.origin.x == 0)
							 [self userInteractionEnabled:YES controller:controller];
					 }];
}

- (void)fromRight:(UIViewController*)new
{
	CGRect frame = self.view.bounds;

	[self userInteractionEnabled:NO controller:new];
	new.view.frame = CGRectOffset(frame, frame.size.width, 0);
	[UIView animateWithDuration:0.2f
						  delay:0.0f
						options:UIViewAnimationOptionCurveEaseInOut
					 animations:^{
						 new.view.frame = frame;
					 }
					 completion:^(BOOL finished) {
						 [self userInteractionEnabled:YES controller:new];
					 }];
}

- (void)fromRight:(UIViewController*)new old:(UIViewController*)old
{
	CGRect frame = self.view.bounds;

	[self userInteractionEnabled:NO controller:old];
	[UIView animateWithDuration:0.05f
						  delay:0.0f
						options:UIViewAnimationOptionCurveEaseInOut
					 animations:^{
						 old.view.frame = CGRectOffset(frame, frame.size.width-1, 0);
					 }
					 completion:^(BOOL finished) {
						 [old.view removeFromSuperview];
						 [old removeFromParentViewController];
						 [self fromRight:new];
					 }];
}

- (void)menuOpen:(UIPanGestureRecognizer*)recogniser
{
	if (recogniser.state == UIGestureRecognizerStateBegan)
		[self.menu viewWillAppear:NO];

	CGPoint p = [recogniser translationInView:self.view];

	if (p.x < 0)
		p.x = 0;

	if (recogniser.state == UIGestureRecognizerStateEnded) {
		CGPoint v = [recogniser velocityInView:self.view];

		UIViewController *controller = [self pageController];
		if (v.x > MINVELOCITY || p.x > MINPOINTSTOOPEN) {
			CGRect frame = controller.view.frame;
			[self userInteractionEnabled:NO controller:controller];
			[UIView animateWithDuration:(OPENWIDTH - frame.origin.x)/v.x
								  delay:0.0f
								options:UIViewAnimationOptionCurveEaseInOut
							 animations:^{
								 CGRect f = frame;
								 f.origin.x = OPENWIDTH;
								 controller.view.frame = f;
							 }
							 completion:^(BOOL finished) {
								 [self userInteractionEnabled:NO controller:controller];
							 }];
		} else {
			CGRect frame = controller.view.frame;
			[self userInteractionEnabled:NO controller:controller];
			[UIView animateWithDuration:0.05f
								  delay:0.0f
								options:UIViewAnimationOptionCurveEaseInOut
							 animations:^{
								 CGRect f = frame;
								 f.origin.x = 0;
								 controller.view.frame = f;
							 }
							 completion:^(BOOL finished) {
								 [self userInteractionEnabled:YES controller:controller];
							 }];
		}
	} else {
		UIView *view = [[self pageController] view];
		CGRect frame = view.frame;
		frame.origin.x = p.x;
		view.frame = frame;
	}
}

- (void)menuClose:(UIPanGestureRecognizer*)recogniser
{
	CGPoint p = [recogniser translationInView:self.view];
	p.x += OPENWIDTH;

	if (p.x < 0)
		p.x = 0;

	if (recogniser.state == UIGestureRecognizerStateEnded) {
		CGPoint v = [recogniser velocityInView:self.view];

		UIViewController *controller = [self pageController];
		if (v.x > MINVELOCITY || p.x > (recogniser.view.frame.size.width - MINPOINTSTOCLOSE)) {
			CGRect frame = controller.view.frame;
			[self userInteractionEnabled:NO controller:controller];
			[UIView animateWithDuration:(OPENWIDTH - frame.origin.x)/v.x
								  delay:0.0f
								options:UIViewAnimationOptionCurveEaseInOut
							 animations:^{
								 CGRect f = frame;
								 f.origin.x = OPENWIDTH;
								 controller.view.frame = f;
							 }
							 completion:^(BOOL finished) {
								 [self userInteractionEnabled:NO controller:controller];
							 }];
		} else {
			CGRect frame = controller.view.frame;
			[self userInteractionEnabled:NO controller:controller];
			[UIView animateWithDuration:0.05f
								  delay:0.0f
								options:UIViewAnimationOptionCurveEaseInOut
							 animations:^{
								 CGRect f = frame;
								 f.origin.x = 0;
								 controller.view.frame = f;
							 }
							 completion:^(BOOL finished) {
								 [self userInteractionEnabled:YES controller:controller];
							 }];
		}
	} else {
		UIView *view = recogniser.view;
		CGRect frame = view.frame;
		frame.origin.x = p.x;
		view.frame = frame;
	}
}

- (void)userInteractionEnabled:(BOOL)enabled controller:(UIViewController*)controller
{
	if ([controller conformsToProtocol:@protocol(LGRDrawerViewControllerDelegate)]) {
        id<LGRDrawerViewControllerDelegate> page = (id<LGRDrawerViewControllerDelegate>) controller;
		[page userInteractionEnabled:enabled];
	} else {
		return;
	}
}

- (LGRViewController*)pageController
{
	if(self.childViewControllers.count < 2)
		return nil;
	
	return self.childViewControllers[1];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
	return [LGRAppearance statusBar];
}

- (void)pushNotificationTokenUpdated:(NSString *)token error:(NSError *)error
{
	[self.menu pushNotificationTokenUpdated:token error:error];
}

- (void)notificationArrived:(NSDictionary *)userInfo background:(BOOL)background
{
	[self.menu notificationArrived:userInfo background:background];
}

- (void)handleAppOpenURL:(NSURL*)url
{
	[self.menu handleAppOpenURL:url];
}

@end
