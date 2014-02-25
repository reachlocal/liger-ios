//
//  LGRAppMenuViewController.m
//  Liger
//
//  Created by John Gustafsson on 11/25/13.
//  Copyright (c) 2013-2014 ReachLocal Inc. All rights reserved.  https://github.com/reachlocal/liger-ios/blob/master/LICENSE
//

#import "LGRAppMenuViewController.h"
#import "LGRMenuCell1.h"
#import "LGRMenuCell2.h"
#import "LGRApp.h"

@interface LGRAppMenuViewController ()
@property (nonatomic, strong) IBOutlet UITableView *menu;
@property (nonatomic, strong) NSArray *menuItems;
@end

@implementation LGRAppMenuViewController

- (id)initWithPage:(NSString *)page title:(NSString *)title args:(NSDictionary *)args
{
	self = [super initWithPage:page title:title args:args nibName:@"LGRAppMenuViewController" bundle:nil];
	if (self) {
		self.menuItems = args[@"menu"];
	}
	return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

	// Move the menu down 20 pixels (status bar height) and give it the same color as the status bar of a navigation controller.
	// The color can't be queried by any known API at this point, so it has to be manually updated if LGRAppearance.m is updated.
	// This is just a quick hack to get it to work on iOS 7. Expect a redesign for Liger.
	if ([self is7OrHigher]) {
		self.menu.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
	}
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];

	if (!self.menu.indexPathForSelectedRow) {
		[self openPage:self.menuItems[0][0][@"page"] title:self.menuItems[0][0][@"name"] args:@{} success:^{} fail:^{}];
		[self.menu selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return self.menuItems.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.menuItems[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	switch (indexPath.section) {
		case 0: {
			LGRMenuCell1 *cell = [tableView dequeueReusableCellWithIdentifier:@"large"];
			if (!cell) {
				cell = [[LGRMenuCell1 alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"large"];
			}

			cell.menuName.text = self.menuItems[indexPath.section][indexPath.row][@"name"];
			cell.accessibilityLabel = self.menuItems[indexPath.section][indexPath.row][@"accessibilityLabel"];
			return cell;
		}
		case 1: {
			LGRMenuCell2 *cell = [tableView dequeueReusableCellWithIdentifier:@"small"];
			if (!cell) {
				cell = [[LGRMenuCell2 alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"small"];
			}
			cell.menuName.text = self.menuItems[indexPath.section][indexPath.row][@"name"];
			cell.menuDetail.text = self.menuItems[indexPath.section][indexPath.row][@"detail"];
			cell.accessibilityLabel = self.menuItems[indexPath.section][indexPath.row][@"accessibilityLabel"];
			return cell;
		}
		default:
			NSAssert(NO, @"Internal error, menu contains too many sections.");
			return nil;
	}
}

- (void)addShadowToView:(UIViewController*)viewController
{
	if ([self is7OrHigher])
		return;
	
	viewController.view.layer.shadowOpacity = 0.5;
	viewController.view.layer.shadowColor = UIColor.blackColor.CGColor;
	viewController.view.layer.shadowRadius = 4;
	
	CGMutablePathRef path = CGPathCreateMutable();
	CGPathMoveToPoint(path, NULL, -3, -3);
	CGPathAddLineToPoint(path, NULL, -3, viewController.view.bounds.size.height + 3);
	CGPathAddLineToPoint(path, NULL, 3, viewController.view.bounds.size.height + 3);
	CGPathAddLineToPoint(path, NULL, 3, - 3);
	CGPathCloseSubpath(path);
	
	viewController.view.layer.shadowPath = path;
	CGPathRelease(path);
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSDictionary *menuItem = self.menuItems[indexPath.section][indexPath.row];
	BOOL dialog = [menuItem[@"dialog"] boolValue];

	if (dialog) {
		NSIndexPath *previousIndexPath = tableView.indexPathForSelectedRow;
		dispatch_async(dispatch_get_main_queue(), ^{
			[self.menu selectRowAtIndexPath:previousIndexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
		});
	}
	return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSDictionary *menuItem = self.menuItems[indexPath.section][indexPath.row];
	BOOL dialog = [menuItem[@"dialog"] boolValue];
	NSDictionary *args = menuItem[@"args"];
	if (!args)
		args = @{};

	if (dialog) {
		[self openDialog:menuItem[@"page"] title:menuItem[@"title"] args:args success:^{} fail:^{}];
	} else {
		[self openPage:menuItem[@"page"] title:menuItem[@"title"] args:args success:^{} fail:^{}];
	}
	return;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	switch (indexPath.section) {
		case 0:
			return 36;
		case 1:
			return 55;
		default:
			return tableView.rowHeight;
	}
}

#pragma mark - Utility

// Don't use this.
- (BOOL)is7OrHigher
{
	NSArray *systemVersion = [[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."];
	if (systemVersion.count > 0 && [systemVersion[0] integerValue] >= 7)
		return YES;
	
	return NO;
}

#pragma mark - LGRViewController

+ (NSString*)nativePage
{
	return @"appMenu";
}

@end
