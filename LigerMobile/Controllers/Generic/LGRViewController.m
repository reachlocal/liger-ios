//
//  LGRViewController.m
//  LigerMobile
//
//  Created by John Gustafsson on 2/20/13.
//  Copyright (c) 2013-2014 ReachLocal Inc. All rights reserved.  https://github.com/reachlocal/liger-ios/blob/master/LICENSE
//

#import "LGRViewController.h"
#import "LGRPageFactory.h"
#import "LGRDrawerViewController.h"
#import "LGRAppDelegate.h"
#import "LGRAppearance.h"

@interface LGRViewController ()
@property (nonatomic, strong) NSString *page;
@property (nonatomic, strong) NSDictionary *args;
@property (nonatomic, strong) NSDictionary *options;

@property (nonatomic, strong) NSMutableDictionary *buttons;
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
		NSAssert([self.class nativePage] == nil || [[self.class nativePage] isEqualToString:page], @"Native page name isn't the same as page argument.");
		self.page = page;
		self.args = args;
		self.title = title;
		self.options = options;
		
		self.buttons = [NSMutableDictionary dictionaryWithCapacity:2];
		[self addButtons];
	}
	return self;
}

- (void)addButtons
{
	if ([self.options objectForKey:@"left"]) {
		NSDictionary *left = [self.options objectForKey:@"left"];
		UIBarButtonItem *leftButton = [self buttonFromDictionary:left];
		self.navigationItem.leftBarButtonItem = leftButton;
		self.buttons[[NSValue valueWithNonretainedObject:leftButton]] = left;
	}
	
	if ([self.options objectForKey:@"right"]) {
		NSDictionary *right = [self.options objectForKey:@"right"];
		UIBarButtonItem *rightButton =  [self buttonFromDictionary:right];
		self.navigationItem.rightBarButtonItem = rightButton;
		self.buttons[[NSValue valueWithNonretainedObject:rightButton]] = right;
	}
}

- (UIBarButtonItem*)buttonFromDictionary:(NSDictionary*)buttonInfo
{
	NSAssert([buttonInfo isKindOfClass:[NSDictionary class]], @"options should look as follows {'right':{'button':'done'}}");
	
	NSDictionary *lookup = @{@"done": @(UIBarButtonSystemItemDone),
				 @"cancel": @(UIBarButtonSystemItemCancel),
				 @"edit": @(UIBarButtonSystemItemEdit),
				 @"save": @(UIBarButtonSystemItemSave),
				 @"add": @(UIBarButtonSystemItemAdd),
				 @"compose": @(UIBarButtonSystemItemCompose),
				 @"reply": @(UIBarButtonSystemItemReply),
				 @"action": @(UIBarButtonSystemItemAction),
				 @"organize": @(UIBarButtonSystemItemOrganize),
				 @"bookmarks": @(UIBarButtonSystemItemBookmarks),
				 @"search": @(UIBarButtonSystemItemSearch),
				 @"refresh": @(UIBarButtonSystemItemRefresh),
				 @"stop": @(UIBarButtonSystemItemStop),
				 @"camera": @(UIBarButtonSystemItemCamera),
				 @"trash": @(UIBarButtonSystemItemTrash),
				 @"play": @(UIBarButtonSystemItemPlay),
				 @"pause": @(UIBarButtonSystemItemPause),
				 @"rewind": @(UIBarButtonSystemItemRewind),
				 @"forward": @(UIBarButtonSystemItemFastForward),
				 @"undo": @(UIBarButtonSystemItemUndo),
				 @"redo": @(UIBarButtonSystemItemRedo)
				 };
	
	NSNumber *buttonValue = lookup[[buttonInfo[@"button"] lowercaseString]];
	if (buttonValue) {
		UIBarButtonSystemItem buttonSystemItem = buttonValue.integerValue;
		
		return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:buttonSystemItem
								     target:self
								     action:@selector(buttonAction:)];
	} else {
		return [[UIBarButtonItem alloc] initWithTitle:buttonInfo[@"button"]
							style:UIBarButtonItemStylePlain
						       target:self
						       action:@selector(buttonAction:)];
	}
}

- (void)buttonAction:(id)sender
{
	NSDictionary *button = self.buttons[[NSValue valueWithNonretainedObject:sender]];
	[self buttonTapped:button];
}

- (void)buttonTapped:(NSDictionary*)button
{

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

- (void)openPage:(NSString*)page title:(NSString*)title args:(NSDictionary*)args options:(NSDictionary*)options parent:(LGRViewController*)parent success:(void (^)())success fail:(void (^)())fail
{
	[self.collectionPage openPage:page title:title args:args options:options parent:parent success:success fail:fail];
}

- (void)updateParent:(NSString*)destination args:(NSDictionary*)args success:(void (^)())success fail:(void (^)())fail
{
	if ([destination isKindOfClass:NSString.class]) {
		LGRViewController *page = self.parentPage;
		
		while (page) {
			if ([page.page isEqualToString:destination]) {
				[page childUpdates:args];
				success();
				return;
			}
			page = page.parentPage;
		}
	} else {
		[self.parentPage childUpdates:args];
		success();
		return;
	}
	
	fail();
}

- (void)closePage:(NSString*)rewindTo success:(void (^)())success fail:(void (^)())fail
{
	[self.collectionPage closePage:rewindTo sourcePage:self success:success fail:fail];
}

- (void)closePage:(NSString*)rewindTo sourcePage:(LGRViewController*)sourcePage success:(void (^)())success fail:(void (^)())fail
{

}

- (void)openDialog:(NSString *)page title:(NSString*)title args:(NSDictionary*)args options:(NSDictionary*)options parent:(LGRViewController*)parent success:(void (^)())success fail:(void (^)())fail
{
	if (self.collectionPage) {
		[self.collectionPage openDialog:page
								  title:title
								   args:args
								options:options
								 parent:parent
								success:success
								   fail:fail];
	} else {
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
			LGRViewController *rootPage = [((LGRAppDelegate*)[[UIApplication sharedApplication] delegate]) rootPage];
			if ([rootPage isKindOfClass:LGRDrawerViewController.class]) {
				LGRDrawerViewController *drawer = (LGRDrawerViewController*)rootPage;
				[drawer resetApp];
			}
		} else {
			LGRViewController *page = self.collectionPage ?: self.parentPage;
			NSAssert(page, @"Internal close dialog error");
			[page dialogClosed:args];
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

- (UIStatusBarStyle)preferredStatusBarStyle
{
	if (self.presentingViewController) {
		NSString *style = [self.options[@"statusBarDialog"] lowercaseString];
		if ([style isEqualToString:@"dark"])
			return UIStatusBarStyleDefault;

		if ([style isEqualToString:@"light"])
			return UIStatusBarStyleLightContent;

		return [LGRAppearance statusBarDialog];
	} else {
		NSString *style = [self.options[@"statusBar"] lowercaseString];
		if ([style isEqualToString:@"dark"])
			return UIStatusBarStyleDefault;

		if ([style isEqualToString:@"light"])
			return UIStatusBarStyleLightContent;

		return [LGRAppearance statusBar];
	}
}

@end
