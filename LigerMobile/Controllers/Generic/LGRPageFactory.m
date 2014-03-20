//
//  LGRPageFactory.m
//  Liger
//
//  Created by John Gustafsson on 11/13/13.
//  Copyright (c) 2013-2014 ReachLocal Inc. All rights reserved.  https://github.com/reachlocal/liger-ios/blob/master/LICENSE
//

#import "LGRPageFactory.h"
#import "LGRViewController.h"
#import "LGRHTMLViewController.h"
#import "LGRMenuViewController.h"
#import "LGRHTMLMenuViewController.h"

#import "LGRImportedViewController.h"

@import ObjectiveC;

BOOL classDescendsFromClass(Class classA, Class classB)
{
	do {
        if(classA == classB)
			return YES;
	} while ((classA = class_getSuperclass(classA)));
	
    return NO;
}

BOOL imported(NSMutableDictionary* imported, Class class)
{
	if (!class_conformsToProtocol(class, @protocol(LGRImportedViewController)))
		return NO;
	
	NSString *importedPage = [class importedPage];
	if (!importedPage)
		return NO;
	
	imported[importedPage] = class;
	return YES;
}

BOOL menu(NSMutableDictionary* menues, Class class)
{
	if (!classDescendsFromClass(class, LGRMenuViewController.class))
		return NO;

	NSString *nativePage = [class nativePage];
	if (!nativePage)
		return NO;
	
	menues[nativePage] = class;
	return YES;
}

BOOL native(NSMutableDictionary* pages, Class class)
{
	if (!classDescendsFromClass(class, LGRViewController.class))
		return NO;
	
	NSString *nativePage = [class nativePage];
	if (!nativePage)
		return NO;
	
	pages[nativePage] = class;
	return YES;
}


@interface LGRPageFactory ()
@property (nonatomic, strong) NSDictionary *importedPages;
@property (nonatomic, strong) NSDictionary *menuPages;
@property (nonatomic, strong) NSDictionary *nativePages;
@end

@implementation LGRPageFactory

+ (LGRPageFactory*)shared
{
	static LGRPageFactory *shared = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		shared = [[self alloc] init];
	});

	return shared;
}

- (id)init
{
	self = [super init];
	if (self) {
		int numClasses = objc_getClassList(NULL, 0);
		
		if (numClasses > 0) {
			NSMutableDictionary *importedPages = [NSMutableDictionary dictionary];
			NSMutableDictionary *pages = [NSMutableDictionary dictionary];
			NSMutableDictionary *menuPages = [NSMutableDictionary dictionary];

			Class *classes = (__unsafe_unretained Class *)malloc(sizeof(Class) * numClasses);
			numClasses = objc_getClassList(classes, numClasses);

			for (int i = 0; i < numClasses; i++) {
				if (imported(importedPages, classes[i]))
					continue;

				if (menu(menuPages, classes[i]))
					continue;

				if (native(pages, classes[i]))
					continue;
			}
			free(classes);
			
			self.importedPages = importedPages;
			self.nativePages = pages;
			self.menuPages = menuPages;
		}
	}
	return self;
}

+ (LGRMenuViewController*)controllerForMenuPage:(NSString*)page title:(NSString*)title args:(NSDictionary*)args
{
	return [self standardControllerForMenuPage:page title:title args:args];
}

+ (UIViewController*)controllerForPage:(NSString*)page title:(NSString*)title args:(NSDictionary*)args parent:(LGRViewController*)parent
{
	return [self standardControllerForPage:page title:title args:args parent:parent];
}

+ (UIViewController*)controllerForDialogPage:(NSString*)page title:(NSString*)title args:(NSDictionary*)args parent:(LGRViewController*)parent
{
	// Imported (into Liger) pages
	Class importedClass = [self shared].importedPages[page];
	if (importedClass) {
		return [importedClass controllerForImportedPage:page title:title args:args parent:parent];
	}

	if (title) {
		return [[UINavigationController alloc] initWithRootViewController:[self standardControllerForPage:page
																									title:title
																									 args:args
																								   parent:parent]];
	} else {
		return [self standardControllerForPage:page title:@"" args:args parent:parent];
	}
}

+ (UIViewController*)standardControllerForPage:(NSString*)page title:(NSString*)title args:(NSDictionary*)args parent:(LGRViewController*)parent
{
	// Do we have a native class that inherits from LGRViewController that implements this page?
	Class class = [self shared].nativePages[page];
	if (class) {
		LGRViewController *new = [[class alloc] initWithPage:page title:title args:args];
		new.ligerParent = parent;
		return new;
	}

	// Create an html page if we have one in the bundle of it it's an http address
	if ([self hasHTMLPage:page]) {
		LGRViewController *new = [[LGRHTMLViewController alloc] initWithPage:page title:title args:args];
		new.ligerParent = parent;
		return new;
	}
	return nil;
}

+ (LGRMenuViewController*)standardControllerForMenuPage:(NSString*)page title:(NSString*)title args:(NSDictionary*)args
{
	Class class = [self shared].menuPages[page];
	
	// Do we have a native class that inherits from LGRMenuViewController that implements this page?
	if (class)
		return [[class alloc] initWithPage:page title:title args:args];
	
	// Create an html page if we have one in the bundle of it it's an http address
	if ([self hasHTMLPage:page])
		return [[LGRHTMLMenuViewController alloc] initWithPage:page title:title args:args];
	
	return nil;
}

+ (BOOL)hasHTMLPage:(NSString*)page
{
	// TODO Replace with regex to make sure we open any protocol?
	if ([page hasPrefix:@"http"])
		return YES;

	if([[NSBundle mainBundle] pathForResource:page ofType:@"html" inDirectory:@"app"])
		return YES;
	
	return NO;
}
@end
