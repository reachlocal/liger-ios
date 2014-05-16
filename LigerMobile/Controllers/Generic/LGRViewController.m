//
//  LGRViewController.m
//  Liger
//
//  Created by John Gustafsson on 2/20/13.
//  Copyright (c) 2013-2014 ReachLocal Inc. All rights reserved.  https://github.com/reachlocal/liger-ios/blob/master/LICENSE
//

#import "LGRViewController.h"
#import "LGRPageFactory.h"
#import "LGRDrawerViewController.h"
#import "LGRAppDelegate.h"

@interface LGRViewController ()
@property (nonatomic, strong) NSString *page;
@property (nonatomic, strong) NSDictionary *args;
@property (nonatomic, strong) NSDictionary *options;
@end

@implementation LGRViewController

+ (NSString*)nativePage
{
	return nil;
}

- (id)initWithPage:(NSString*)page title:(NSString*)title args:(NSDictionary*)args options:(NSDictionary*)options
{
	return [self initWithPage:page title:title args:args options:options nibName:nil bundle:nil];
}

- (id)initWithPage:(NSString*)page title:(NSString*)title args:(NSDictionary*)args options:(NSDictionary*)options nibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		self.page = page;
		self.args = args;
		self.title = title;
		self.options = options;
		
		[self addButtons];
	}
	return self;
}

- (void)addButtons
{
	if([self.options objectForKey:@"left"]) {
		UIBarButtonItem *leftButton = [self buttonFromDictionary:[self.options objectForKey:@"left"]];
		self.navigationItem.leftBarButtonItem = leftButton;
	}
	
	if([self.options objectForKey:@"right"]) {
		UIBarButtonItem *rightButton =  [self buttonFromDictionary:[self.options objectForKey:@"right"]];
		self.navigationItem.rightBarButtonItem = rightButton;
	}
}

- (UIBarButtonItem*)buttonFromDictionary:(NSDictionary*)buttonInfo
{
	NSString* buttonType = [buttonInfo objectForKey:@"button"];
	UIBarButtonSystemItem buttonSystemItem = UIBarButtonSystemItemDone;
	
	if([buttonType isEqualToString:@"done"]) {
		buttonSystemItem = UIBarButtonSystemItemDone;
	} else if ([buttonType isEqualToString:@"cancel"]) {
		buttonSystemItem = UIBarButtonSystemItemCancel;
	} else if ([buttonType isEqualToString:@"save"]) {
		buttonSystemItem = UIBarButtonSystemItemSave;
	} else if ([buttonType isEqualToString:@"search"]) {
		buttonSystemItem = UIBarButtonSystemItemSearch;
	}
	
	return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:buttonSystemItem target:self action:@selector(addedButtonAction:)];
}

- (void)addedButtonAction:(id)sender
{
	NSLog(@"this worked");
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self pageWillAppear];

	LGRAppDelegate *appDelegate = (LGRAppDelegate*)[[UIApplication sharedApplication] delegate];
	NSAssert([appDelegate isKindOfClass:LGRAppDelegate.class], @"Your app delegate needs to inherit from LGRAppDelegate");
	appDelegate.topPage = self;
}

#pragma mark - API

- (void)openPage:(NSString*)page title:(NSString*)title args:(NSDictionary*)args options:(NSDictionary*)options success:(void (^)())success fail:(void (^)())fail
{
	// Internal error, we couldn't find the navigation controller or we aren't at the top of the navigation stack
	if (!self.navigationController || self.navigationController.topViewController != self) {
		fail();
		return;
	}
	
	UIViewController *new = [LGRPageFactory controllerForPage:page title:title args:args options:options parent:self];
	
	// Couldn't create a new view controller
	if (!new) {
		fail();
		return;
	}
	
	[self.navigationController pushViewController:new animated:YES];
	success();
}

- (void)updateParent:(NSString*)destination args:(NSDictionary*)args success:(void (^)())success fail:(void (^)())fail
{
	if ([destination isKindOfClass:NSString.class]) {
		LGRViewController *page = self.ligerParent;
		
		while (page) {
			if ([page.page isEqualToString:destination]) {
				[page childUpdates:args];
				success();
				return;
			}
			page = page.ligerParent;
		}
	} else {
		[self.ligerParent childUpdates:args];
		success();
		return;
	}
	
	fail();
}

- (void)closePage:(NSString*)rewindTo success:(void (^)())success fail:(void (^)())fail
{
	if (!self.navigationController) {
		fail();
		return;
	}
	
	if (rewindTo) {
		LGRViewController *page = self.ligerParent;
		
		while (page) {
			if ([page.page isEqualToString:rewindTo]) {
				[self.navigationController popToViewController:page animated:YES];
				success();
				return;
			}
			page = page.ligerParent;
		}
	} else {
		[self.navigationController popViewControllerAnimated:YES];
		success();
		return;
	}
	
	fail();
}

- (void)openDialog:(NSString *)page title:(NSString*)title args:(NSDictionary*)args options:(NSDictionary*)options success:(void (^)())success fail:(void (^)())fail
{
	UIViewController *new = [LGRPageFactory controllerForDialogPage:page title:title args:args options:options parent:self];
	
	// Couldn't create a new view controller, possibly a broken plugin
	if (!new) {
		fail();
		return;
	}
	
	[self presentViewController:new animated:YES completion:^{
		success();
	}];
}

- (void)closeDialog:(NSDictionary*)args success:(void (^)())success fail:(void (^)())fail
{
	// Internal error, we couldn't find the navigation controller
	if (!self.presentingViewController) {
		fail();
		return;
	}
	
	[self.presentingViewController dismissViewControllerAnimated:YES completion:^{
		// TODO is there a cleaner and more generic way to do this?
		if ([args[@"resetApp"] boolValue]) {
			UIApplication* app = [UIApplication sharedApplication];
			UIViewController *root = [app.windows[0] rootViewController];
			LGRDrawerViewController *menu = (LGRDrawerViewController*)root;
			[menu resetApp];
		} else {
			NSAssert(self.ligerParent, @"Internal close dialog error");
			[self.ligerParent dialogClosed:args];
		}
		success();
	}];
}

#pragma mark - Callbacks

- (void)dialogClosed:(NSDictionary*)args
{
}

- (void)childUpdates:(NSDictionary*)args
{
	self.args = args;
}

- (void)refreshPage:(BOOL)wasInitiatedByUser
{
	
}

- (void)pageWillAppear
{
	
}

- (void)pushNotificationTokenUpdated:(NSString*)token error:(NSError*)error
{
	
}

- (void)notificationArrived:(NSDictionary*)userInfo background:(BOOL)background
{

}

- (void)handleAppOpenURL:(NSURL*)url
{

}

@end

