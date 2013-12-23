//
//  LGRApp.m
//  Liger
//
//  Created by John Gustafsson on 10/1/13.
//  Copyright (c) 2013 ReachLocal, Inc. All rights reserved.
//

#import "LGRApp.h"

#define VERSION @4

@interface LGRApp ()
@property (nonatomic, strong) NSDictionary *app;
@end

@implementation LGRApp

+ (LGRApp*)shared
{
	static LGRApp *shared = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		shared = [[LGRApp alloc] init];
	});
	return shared;
}

- (id)init
{
	self = [super init];
	if (self) {
		NSString *filePath = [[NSBundle mainBundle] pathForResource:@"app/app" ofType:@"json"];
		NSData *file = [NSData dataWithContentsOfFile:filePath];
		NSAssert(file, @"No app.json in the app folder.");
		
		NSError *error = nil;
		NSDictionary *json = [NSJSONSerialization JSONObjectWithData:file options:0 error:&error];
		NSAssert(!error, error.description);
		
		NSAssert([json[@"appFormatVersion"] isEqualToNumber:VERSION], @"Wrong app format version of app.json, please see documentation for updating to the latest format. Do not update appFormatVersion without updating the rest of the file.");
		NSAssert(json[@"appearance"], @"No appearance in app.json.");
		NSAssert(json[@"menu"], @"No menu in app.json.");
		NSAssert([json[@"menu"] count] > 0 && [json[@"menu"][0] count] > 0, @"You need a top menu in app.json");
		self.app = json;
	}
	return self;
}

+ (NSDictionary*)appearance
{
	return [self app][@"appearance"];
}

+ (NSArray*)menuItems
{
	return [self app][@"menu"];
}

+ (NSString*)menuPage
{
	// TODO Read appMenu from app.json
	return @"appMenu";
}

+ (NSArray*)toolbars
{
	return [self app][@"pagesWithToolbars"];
}

+ (NSDictionary*)app
{
	return [self shared].app;
}

@end
