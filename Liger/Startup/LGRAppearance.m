//
//  LGRAppearance.m
//  Liger
//
//  Created by John Gustafsson on 1/11/13.
//  Copyright (c) 2013-2014 ReachLocal Inc. All rights reserved.  https://github.com/reachlocal/liger-ios/blob/master/LICENSE
//

#import "LGRAppearance.h"
#import "LGRMenuCell1.h"
#import "LGRMenuCell2.h"

#import "LGRSlideViewController.h"
#import "LGRMenuViewController.h"
#import "LGRApp.h"

#import "UIColor+HTMLColors.h"

@interface UITableViewCell (LGRMenuViewCell)
@property (nonatomic, weak) UIColor *labelColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, weak) UIColor *selectedLabelColor UI_APPEARANCE_SELECTOR;
@end

@interface LGRApperanceStatusBar : NSObject
+ (instancetype)shared;
@property (nonatomic, assign) UIStatusBarStyle statusBar;
@property (nonatomic, assign) UIStatusBarStyle statusBarDialog;
@end

@implementation LGRApperanceStatusBar
+ (instancetype)shared
{
	static LGRApperanceStatusBar *statusBar = nil;
	
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		statusBar = [[LGRApperanceStatusBar alloc] init];
	});
	
	return statusBar;
}
@end

@implementation LGRAppearance

+ (void)setupApperance
{
	NSDictionary *appearance = [LGRApp appearance];

	NSArray *systemVersion = [[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."];
	if (systemVersion.count > 0 && [systemVersion[0] integerValue] >= 7) {
		[self iOS7:appearance[@"iOS7"]];
	} else {
		[self iOS:appearance[@"iOS"]];
	}
}

+ (UIStatusBarStyle)statusBar
{
	return LGRApperanceStatusBar.shared.statusBar;
}

+ (UIStatusBarStyle)statusBarDialog
{
	return LGRApperanceStatusBar.shared.statusBarDialog;
}

+ (void)iOS7:(NSDictionary*)app
{
	if (!app)
		return;

	// Status bar
	if ([app[@"statusBar"] isEqualToString:@"dark"])
		LGRApperanceStatusBar.shared.statusBar = UIStatusBarStyleDefault;

	if ([app[@"statusBar"] isEqualToString:@"light"])
		LGRApperanceStatusBar.shared.statusBar = UIStatusBarStyleLightContent;

	if ([app[@"statusBarDialog"] isEqualToString:@"dark"])
		LGRApperanceStatusBar.shared.statusBarDialog = UIStatusBarStyleDefault;
	
	if ([app[@"statusBarDialog"] isEqualToString:@"light"])
		LGRApperanceStatusBar.shared.statusBarDialog = UIStatusBarStyleLightContent;

	
	// Navigation bar
	NSString *barImageColor = app[@"barColor"];
	if (barImageColor.length) {
		[[UINavigationBar appearance] setBackgroundImage:[self barImage:[UIColor colorWithCSS:barImageColor] height:64] forBarMetrics:UIBarMetricsDefault];
	} else {
		[[UINavigationBar appearance] setBarTintColor:[UIColor colorWithCSS:app[@"barTint"]]];
	}

	UIColor *tint = [UIColor colorWithCSS:app[@"tint"]];
	[[UIWindow appearance] setTintColor:tint];
	[[UIView appearance] setTintColor:tint];
	[[UINavigationBar appearance] setTintColor:tint];
	[[UIToolbar appearance] setTintColor:tint];

	UIColor *barText = [UIColor colorWithCSS:app[@"barText"]];

	if (barText)
		[[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: barText}];

	// WebView (doesn't work properly so LGRWebViewController grabs this value
	[[UIWebView appearance] setBackgroundColor:[UIColor colorWithCSS:app[@"webBackground"]]];
	
	// Menu
	[[UITableView appearanceWhenContainedIn:LGRMenuViewController.class, nil] setSeparatorStyle:UITableViewCellSeparatorStyleNone];
	[[UITableView appearanceWhenContainedIn:LGRMenuViewController.class, nil] setBackgroundColor:[UIColor colorWithCSS:app[@"menuBackground"]]];

	// Menu1 cell colors
	[[LGRMenuCell1 appearanceWhenContainedIn:LGRMenuViewController.class, nil] setSelectionStyle:UITableViewCellSelectionStyleNone];
	[[LGRMenuCell1 appearanceWhenContainedIn:LGRMenuViewController.class, nil] setMenu1TextColor:[UIColor colorWithCSS:app[@"menu1Text"]]];
	[[LGRMenuCell1 appearanceWhenContainedIn:LGRMenuViewController.class, nil] setMenu1TextColorSelected:[UIColor colorWithCSS:app[@"menuSelected"]]];

	// Menu1 cell fonts
	[[LGRMenuCell1 appearanceWhenContainedIn:LGRMenuViewController.class, nil] setMenuNameFont:[UIFont boldSystemFontOfSize:22.0]];
	
	// Menu2 cell colors
	[[LGRMenuCell2 appearanceWhenContainedIn:LGRMenuViewController.class, nil] setSelectionStyle:UITableViewCellSelectionStyleNone];
	[[LGRMenuCell2 appearanceWhenContainedIn:LGRMenuViewController.class, nil] setMenu2TextColorSelected:[UIColor colorWithCSS:app[@"menuSelected"]]];
	[[LGRMenuCell2 appearanceWhenContainedIn:LGRMenuViewController.class, nil] setMenu2TextColor:[UIColor colorWithCSS:app[@"menu2Text"]]];
	
	// Menu2 cell fonts
	[[LGRMenuCell2 appearanceWhenContainedIn:LGRMenuViewController.class, nil] setMenuNameFont:[UIFont systemFontOfSize:22.0]];
	[[LGRMenuCell2 appearanceWhenContainedIn:LGRMenuViewController.class, nil] setMenuDetailFont:[UIFont systemFontOfSize:13.0]];
}

+ (void)iOS:(NSDictionary*)app
{
	// Navigation bar
	[[UINavigationBar appearance] setBackgroundImage:[self barImage:[UIColor colorWithCSS:app[@"barColor"]] height:44] forBarMetrics:UIBarMetricsDefault];
	UIColor *barText = [UIColor colorWithCSS:app[@"barText"]];
	if (barText)
		[[UINavigationBar appearance] setTitleTextAttributes:@{UITextAttributeTextColor: barText}];

	// Nav bar button
	UIImage *barButton = [self barImage:UIColor.clearColor height:32];
	[[UIBarButtonItem appearance] setBackgroundImage:barButton forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
	
	// Nav bar back button
	UIImage *backButton = [self barImage:UIColor.clearColor height:32];
	[[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButton forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];

	// WebView (doesn't work properly so LGRWebViewController grabs this value
	[[UIWebView appearance] setBackgroundColor:[UIColor colorWithCSS:app[@"webBackground"]]];
	
	// Menu
	[[UITableView appearanceWhenContainedIn:LGRMenuViewController.class, nil] setSeparatorStyle:UITableViewCellSeparatorStyleNone];
	[[UITableView appearanceWhenContainedIn:LGRMenuViewController.class, nil] setBackgroundColor:[UIColor colorWithCSS:app[@"menuBackground"]]];

	// Menu1 cell colors
	[[LGRMenuCell1 appearanceWhenContainedIn:LGRMenuViewController.class, nil] setSelectionStyle:UITableViewCellSelectionStyleNone];
	[[LGRMenuCell1 appearanceWhenContainedIn:LGRMenuViewController.class, nil] setMenu1TextColor:[UIColor colorWithCSS:app[@"menu1Text"]]];
	[[LGRMenuCell1 appearanceWhenContainedIn:LGRMenuViewController.class, nil] setMenu1TextColorSelected:[UIColor colorWithCSS:app[@"menuSelected"]]];
	
	// Menu1 cell fonts
	[[LGRMenuCell1 appearanceWhenContainedIn:LGRMenuViewController.class, nil] setMenuNameFont:[UIFont boldSystemFontOfSize:22.0]];
	
	// Menu2 cell colors
	[[LGRMenuCell2 appearanceWhenContainedIn:LGRMenuViewController.class, nil] setSelectionStyle:UITableViewCellSelectionStyleNone];
	[[LGRMenuCell2 appearanceWhenContainedIn:LGRMenuViewController.class, nil] setMenu2TextColorSelected:[UIColor colorWithCSS:app[@"menuSelected"]]];
	[[LGRMenuCell2 appearanceWhenContainedIn:LGRMenuViewController.class, nil] setMenu2TextColor:[UIColor colorWithCSS:app[@"menu2Text"]]];
	
	// Menu2 cell fonts
	[[LGRMenuCell2 appearanceWhenContainedIn:LGRMenuViewController.class, nil] setMenuNameFont:[UIFont systemFontOfSize:22.0]];
	[[LGRMenuCell2 appearanceWhenContainedIn:LGRMenuViewController.class, nil] setMenuDetailFont:[UIFont systemFontOfSize:13.0]];

	// Toolbar
	[[UIToolbar appearance] setBackgroundImage:[self gradientImageFrom:0xFFF4F4F4 to:0xFF9D9D9D]
							forToolbarPosition:UIToolbarPositionBottom
									barMetrics:UIBarMetricsDefault];
}

+ (UIImage*)gradientImageFrom:(NSUInteger)from to:(NSUInteger)to
{
	CGSize size = CGSizeMake(1, 44);
	
	UIGraphicsBeginImageContextWithOptions(size, YES, 0);
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	size_t num_locations = 2;
	CGFloat locations[2] = { 0.0, 1.0 };
	CGColorSpaceRef rgbColorspace = CGColorSpaceCreateDeviceRGB();
	CGGradientRef glossGradient;
	CGFloat components[8] = {
		((from>>16)&0xFF)/255.0, ((from>>8)&0xFF)/255.0, ((from>>0)&0xFF)/255.0, ((from>>24)&0xFF)/255.0,
		((to>>16)&0xFF)/255.0, ((to>>8)&0xFF)/255.0, ((to>>0)&0xFF)/255.0, ((to>>24)&0xFF)/255.0
	};
	glossGradient = CGGradientCreateWithColorComponents(rgbColorspace, components, locations, num_locations);
	
	CGPoint topCenter = CGPointMake(0, 0);
	CGPoint bottomCenter = CGPointMake(0, 44);
	CGContextDrawLinearGradient(context, glossGradient, topCenter, bottomCenter, 0);
	
	CGGradientRelease(glossGradient);
	CGColorSpaceRelease(rgbColorspace);
	
	UIImage *gradientImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return  gradientImage;
}

+ (UIImage*)barImage:(UIColor*)color height:(CGFloat)height
{
	CGSize size = CGSizeMake(1, height);
	
	UIGraphicsBeginImageContextWithOptions(size, NO, 0);
	CGContextRef context = UIGraphicsGetCurrentContext();

	[color setFill];
	CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));
	
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return  image;
}

@end
