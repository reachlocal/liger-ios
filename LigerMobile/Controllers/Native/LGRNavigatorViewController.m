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
@end

@implementation LGRNavigatorViewController

+ (NSString*)nativePage
{
	return @"Navigator";
}

- (id)initWithPage:(NSString*)page title:(NSString*)title args:(NSDictionary*)args options:(NSDictionary*)options
{
	return [self initWithPage:page
						title:title
						 args:args
					  options:options
					  nibName:@"LGRNavigatorViewController"
					   bundle:nil];
}

- (void)viewDidLoad
{
	[super viewDidLoad];

	UIViewController *rootPage = [LGRPageFactory controllerForPage:self.args[@"page"]
															 title:self.args[@"title"]
															  args:self.args[@"args"]
														   options:self.args[@"options"]
															parent:nil];

	self.navigator = [[UINavigationController alloc] initWithRootViewController:rootPage];

	[self addChildViewController:self.navigator];
	[self.view addSubview:self.navigator.view];
}

@end
