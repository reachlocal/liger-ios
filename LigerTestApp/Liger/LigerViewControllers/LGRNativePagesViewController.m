//
//  LGRNativePagesViewController.m
//  LigerMobile
//
//  Created by John Gustafsson on 11/18/13.
//  Copyright (c) 2013-2014 ReachLocal Inc. All rights reserved.  https://github.com/reachlocal/liger-ios/blob/master/LICENSE
//

#import "LGRNativePagesViewController.h"

@interface LGRNativePagesViewController ()
@property (nonatomic, strong) IBOutlet UITableView *methods;
@property (nonatomic, strong) NSString *dialogArgs;
@end

@implementation LGRNativePagesViewController

- (id)initWithPage:(NSString*)page title:(NSString*)title args:(NSDictionary*)args options:(NSDictionary*)options
{
	self = [super initWithPage:page title:title args:args options:options nibName:@"LGRNativePagesViewController" bundle:nil];
	if (self) {
	}
	return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

	[self.methods registerClass:UITableViewCell.class forCellReuseIdentifier:@"method"];
	[self.methods registerClass:UITableViewCell.class forCellReuseIdentifier:@"args"];
}

+ (NSString*)nativePage
{
	return @"nativePages";
}

#pragma mark - Table

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 4;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	switch (section) {
		case 0: return @"Arguments";
		case 1: return @"Pages";
		case 2: return @"Parent";
		case 3: return @"Dialogs";
		default: return @"";
	}
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	switch (section) {
		case 0: return 1;
		case 1: return 3;
		case 2: return 2;
		case 3: return 5;
		default: return 0;
	}
}

- (CGFloat)argsHeight
{
	UITableViewCell *cell = [[UITableViewCell alloc] init];
	CGSize size = CGSizeMake(275, MAXFLOAT);// Width for iPhone
	CGRect rect = [self.args.debugDescription boundingRectWithSize:size
														   options:NSStringDrawingUsesLineFragmentOrigin
														attributes:@{NSFontAttributeName: cell.textLabel.font}
														   context:nil];
	CGFloat height = ceilf(rect.size.height+20);
	return MAX(height, self.methods.rowHeight);
}

- (CGFloat)dialogArgsHeight
{
	UITableViewCell *cell = [[UITableViewCell alloc] init];
	CGSize size = CGSizeMake(275, MAXFLOAT);// Width for iPhone
	CGRect rect = [self.dialogArgs boundingRectWithSize:size
												options:NSStringDrawingUsesLineFragmentOrigin
											 attributes:@{NSFontAttributeName: cell.textLabel.font}
												context:nil];
	CGFloat height = ceilf(rect.size.height+20);
	return MAX(height, self.methods.rowHeight);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	switch (indexPath.section) {
		case 0: return [self argsHeight];
		case 3:
			switch(indexPath.row) {
				case 0: return [self dialogArgsHeight];
				default: return self.methods.rowHeight;
			}
		default: return self.methods.rowHeight;
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	switch (indexPath.section) {
		case 0: {
			UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"args"];
			cell.textLabel.numberOfLines = 0;
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			cell.textLabel.text = self.args.debugDescription;
			return cell;
		}
		case 1: {
			UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"method"];
			cell.textLabel.textColor = cell.textLabel.tintColor;
			switch (indexPath.row) {
				case 0: cell.textLabel.text = @"Open Page"; break;
				case 1: cell.textLabel.text = @"Close Page"; break;
				case 2: cell.textLabel.text = @"Close To Page"; break;
				default: cell.textLabel.text = @""; break;
			}
			
			return cell;
		}
		case 2: {
			UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"method"];
			cell.textLabel.textColor = cell.textLabel.tintColor;
			switch (indexPath.row) {
				case 0: cell.textLabel.text = @"Update Parent"; break;
				case 1: cell.textLabel.text = @"Update Parent Page"; break;
				default: cell.textLabel.text = @""; break;
			}
			
			return cell;
		}
		case 3: {
			UITableViewCell *cell = nil;
			if (indexPath.row == 0) {
				cell = [tableView dequeueReusableCellWithIdentifier:@"args"];
				cell.textLabel.numberOfLines = 0;
				cell.selectionStyle = UITableViewCellSelectionStyleNone;
			} else {
				cell = [tableView dequeueReusableCellWithIdentifier:@"method"];
				cell.textLabel.textColor = cell.textLabel.tintColor;
			}
			switch (indexPath.row) {
				case 0: cell.textLabel.text = self.dialogArgs; break;
				case 1: cell.textLabel.text = @"Open Dialog"; break;
				case 2: cell.textLabel.text = @"Open Dialog with Title"; break;
				case 3: cell.textLabel.text = @"Close Dialog"; break;
				case 4: cell.textLabel.text = @"Close Dialog and reset app"; break;
				default: cell.textLabel.text = @""; break;
			}
			
			return cell;
		}
		default:
			return nil;
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[self.methods deselectRowAtIndexPath:indexPath animated:YES];
	switch (indexPath.section) {
		case 1:
			switch (indexPath.row) {
				case 0:
					[self openPage:@"nativePages" title:@"Native Page" args:@{@"Native": @"Page"} options:@{} parent:self success:^{} fail:^{}];
					break;
					
				case 1:
					[self closePage:nil success:^{} fail:^{}];
					break;
					
				case 2:
					[self closePage:@"nativePages" success:^{} fail:^{}];
					break;
			}
			break;
		case 2:
			switch (indexPath.row) {
				case 0:
					[self updateParent:nil args:@{@"child": @"data"} success:^{} fail:^{}];
					break;
					
				case 1:
					[self updateParent:@"nativePages" args:@{@"child": @"data"} success:^{} fail:^{}];
					break;
			}
			break;
		case 3:
			switch (indexPath.row) {
				case 1:
					[self openDialog:@"nativePages" title:nil args:@{@"open": @"dialog"} options:@{} parent:self success:^{} fail:^{}];
					break;
					
				case 2:
					[self openDialog:@"nativePages" title:@"Dialog" args:@{@"open": @"dialog"} options:@{} parent:self success:^{} fail:^{}];
					break;
					
				case 3:
					[self closeDialog:@{@"dialog": @"close", @"test": @5} success:^{} fail:^{}];
					break;

				case 4:
					[self closeDialog:@{@"resetApp": @YES} success:^{} fail:^{}];
					break;
			}
			break;
	}
}

#pragma mark - Liger

- (void)dialogClosed:(NSDictionary *)args
{
	self.dialogArgs = args.debugDescription;
	[self.methods beginUpdates];
	[self.methods reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:3]]
						withRowAnimation:UITableViewRowAnimationAutomatic];
	[self.methods endUpdates];
}

- (void)childUpdates:(NSDictionary *)args
{
	[super childUpdates:args];
	[self.methods beginUpdates];
	[self.methods reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]]
						withRowAnimation:UITableViewRowAnimationAutomatic];
	[self.methods endUpdates];
}

@end
