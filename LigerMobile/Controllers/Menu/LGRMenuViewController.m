//
//  LGRMenuViewController.m
//  Liger
//
//  Created by John Gustafsson on 11/25/13.
//  Copyright (c) 2013-2014 ReachLocal Inc. All rights reserved.  https://github.com/reachlocal/liger-ios/blob/master/LICENSE
//

#import "LGRMenuViewController.h"
#import "LGRPageFactory.h"

@implementation LGRMenuViewController

- (id)initWithPage:(NSString *)page title:(NSString *)title args:(NSDictionary *)args
{
	return [self initWithPage:page title:title args:args nibName:nil bundle:nil];
}

- (id)initWithPage:(NSString *)page title:(NSString *)title args:(NSDictionary *)args nibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	self = [super initWithPage:page title:title args:args nibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
	}
	return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	NSAssert(NO, @"Use initWithPage");
	return nil;
}

- (void)dealloc
{
	
}

- (void)viewDidLoad
{
	[super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
}

#pragma mark - API

- (void)openPage:(NSString*)page title:(NSString*)title args:(NSDictionary*)args success:(void (^)())success fail:(void (^)())fail
{
	UIViewController *controller = [self.pages objectForKey:page];
	if (!controller) {
		controller = [[UINavigationController alloc] initWithRootViewController:[LGRPageFactory controllerForPage:page
																											title:title
																											 args:args
																										   parent:self]];
		[self.pages setObject:controller forKey:page];
	}
	
	// Couldn't create a new view controller
	if (!controller) {
		fail();
		return;
	}
	
	// TODO Call delegate
	if (self.displayController)
		self.displayController(controller);

	success();
}

- (void)closePage:(NSString*)rewindTo success:(void (^)())success fail:(void (^)())fail
{
	NSAssert(NO, @"%s isn't supported in menu pages", __PRETTY_FUNCTION__);
}

- (void)updateParent:(NSString*)destination args:(NSDictionary*)args success:(void (^)())success fail:(void (^)())fail
{
	NSAssert(NO, @"%s isn't supported in menu pages", __PRETTY_FUNCTION__);
}

- (void)openDialog:(NSString *)page title:(NSString*)title args:(NSDictionary*)args success:(void (^)())success fail:(void (^)())fail
{
	[super openDialog:page title:title args:args success:^{
		success();
		self.displayDialog();
	} fail:^{
		fail();
	}];
}

- (void)closeDialog:(NSDictionary*)args success:(void (^)())success fail:(void (^)())fail
{
	NSAssert(NO, @"%s isn't supported in menu pages", __PRETTY_FUNCTION__);
}

- (void)pageWillAppear
{
	[super pageWillAppear];
}

@end
