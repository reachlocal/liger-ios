//
//  LGRMenuViewController.m
//  Liger
//
//  Created by John Gustafsson on 2/20/13.
//  Copyright (c) 2013-2014 ReachLocal Inc. All rights reserved.  https://github.com/reachlocal/liger-ios/blob/master/LICENSE
//

#import "LGRSlideViewController.h"
#import "LGRPageFactory.h"
#import "LGRViewController.h"

#import "LGRMenuCell1.h"
#import "LGRMenuCell2.h"

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

@interface LGRSlideViewController ()
@property (nonatomic, strong) UIPanGestureRecognizer *openGesture;
@property (nonatomic, strong) UIPanGestureRecognizer *closeGesture;
@property (nonatomic, strong) NSMutableDictionary *pages;
@property (nonatomic, strong) LGRMenuViewController *menu;
@end

@implementation LGRSlideViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		self.openGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(menuOpen:)];
		self.closeGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(menuClose:)];
		self.pages = [NSMutableDictionary dictionary];
	}
	return self;
}

- (void)addPage:(UIViewController *)controller
{
	UIViewController *page = ((UINavigationController*)controller).viewControllers[0];
	page.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu"
																			 style:UIBarButtonItemStylePlain
																			target:self
																			action:@selector(displayMenu:)];
	[self addChildViewController:controller];
	[self.view addSubview:controller.view];
	[((UINavigationController*)controller).navigationBar addGestureRecognizer:self.openGesture];
}

- (void)addMenuController
{
	self.menu = [LGRPageFactory controllerForMenuPage:LGRApp.menuPage title:nil args:@{@"menu": LGRApp.menuItems}];
	self.menu.pages = self.pages;

	__weak LGRSlideViewController *me = self;

	self.menu.displayController = ^(UIViewController *controller) {
		if (![me pageController]) {
			[me addPage:controller];
			controller.view.frame = me.view.bounds;
			return;
		}
		
		if (controller == [me pageController]) {
			[me toggleMenu];
			return;
		}
		
		[me addPage:controller];
		controller.view.frame = CGRectOffset(me.view.bounds, me.view.bounds.size.width, 0);
		
		id top = ((UINavigationController*)controller).topViewController;
		[top refreshPage:NO];
		
		[me fromRight:controller old:[me pageController]];
	};
	
	self.menu.displayDialog = ^{
		[me toggleMenu];
	};
	
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
	if (![controller isKindOfClass:UINavigationController.class])
		return;
	
	UINavigationController *nav = (UINavigationController*)controller;
	
	UIViewController *viewController = nav.topViewController;
	viewController.view.userInteractionEnabled = enabled;
	
	if (enabled) {
		[nav.navigationBar addGestureRecognizer:self.openGesture];
		[nav.view removeGestureRecognizer:self.closeGesture];
	} else {
		[nav.navigationBar removeGestureRecognizer:self.openGesture];
		[nav.view addGestureRecognizer:self.closeGesture];
	}
}

- (UINavigationController*)pageController
{
	if(self.childViewControllers.count < 2)
		return nil;

	return self.childViewControllers[1];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return [LGRAppearance statusBar];
}

@end
