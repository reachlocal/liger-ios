//
//  LGRTabBarViewController.m
//  Pods
//
//  Created by Gary Moon on 8/6/14.
//  Copyright (c) 2014 ReachLocal Inc. All rights reserved.  https://github.com/reachlocal/liger-ios/blob/master/LICENSE
//

#import "LGRTabBarViewController.h"
#import "LGRPageFactory.h"

@interface LGRTabBarViewController ()
@property(nonatomic, strong) UITabBarController *tab;
@property(nonatomic, strong) UIPanGestureRecognizer *menuBarGesture;
@property(nonatomic, strong) UIPanGestureRecognizer *openGesture;
@property(nonatomic, strong) UIPanGestureRecognizer *closeGesture;
@end

@implementation LGRTabBarViewController

+ (NSString*)nativePage
{
    return @"tab";
}

- (id)initWithPage:(NSString*)page title:(NSString*)title args:(NSDictionary*)args options:(NSDictionary*)options
{
    self = [super initWithPage:page
                         title:title
                          args:args
                       options:options];
    
    if (self) {
        NSMutableArray *pages = [NSMutableArray array];
        
        NSArray *pageArray = self.args[@"pages"];
        
        for (NSDictionary *page in pageArray) {
            LGRViewController *controller = [LGRPageFactory controllerForPage:page[@"page"]
                                                                        title:page[@"title"]
                                                                         args:page[@"args"]
                                                                      options:page[@"options"]
                                                                       parent:nil];
            
            controller.collectionPage = self;
            NSString *icon = [@"app" stringByAppendingPathComponent:page[@"options"][@"icon"]];
            controller.tabBarItem = [[UITabBarItem alloc] initWithTitle:controller.title
                                                                  image:[[UIImage imageNamed:icon] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                                    tag:3];
            
            [pages addObject:controller];
        }
        
        // If we can't create any pages, consider the tab uncreatable as well.
        if (pages.count == 0)
            return nil;
        
        self.tab = [[UITabBarController alloc] init];
        self.tab.delegate = self;
        [self.tab setViewControllers:pages animated:NO];
        
        [self addChildViewController:self.tab];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIView *tabView = self.tab.view;
    tabView.frame = self.view.bounds;
    [self.view addSubview:tabView];
}

- (LGRViewController *)rootPage
{
    UIViewController *controller = self.tab.viewControllers.firstObject;
    NSAssert([controller isKindOfClass:LGRViewController.class], @"Internal error");
    return (LGRViewController*)controller;
}

- (void)pushNotificationTokenUpdated:(NSString *)token error:(NSError *)error
{
    [self.rootPage pushNotificationTokenUpdated:token error:error];
}

- (void)notificationArrived:(NSDictionary *)userInfo background:(BOOL)background
{
    [self.rootPage notificationArrived:userInfo background:background];
}

- (void)handleAppOpenURL:(NSURL *)url
{
    [self.rootPage handleAppOpenURL:url];
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    LGRViewController<LGRDrawerViewControllerDelegate> *page = (LGRViewController<LGRDrawerViewControllerDelegate> *)viewController;
    
    if ([page conformsToProtocol:@protocol(LGRDrawerViewControllerDelegate)]) {
        [page useGestures];
    }
}

// The following functions are required to comply with the LGRDrawerViewControllerDelegate protocol.
- (void)setMenuButton:(UIBarButtonItem *)button
       menuBarGesture:(UIPanGestureRecognizer *)menuBarGesture
          OpenGesture:(UIPanGestureRecognizer *)openGesture
         closeGesture:(UIPanGestureRecognizer *)closeGesture
{
    self.menuBarGesture = menuBarGesture;
    self.openGesture = openGesture;
    self.closeGesture = closeGesture;
    
    NSArray *controllerArray = self.tab.viewControllers;
    
    for (LGRViewController *controller in controllerArray) {
        LGRViewController<LGRDrawerViewControllerDelegate> *page = (LGRViewController<LGRDrawerViewControllerDelegate> *)controller;
        
        if ([page conformsToProtocol:@protocol(LGRDrawerViewControllerDelegate)]) {
            [page setMenuButton:button
                 menuBarGesture:menuBarGesture
                    OpenGesture:openGesture
                   closeGesture:nil];
        }
    }
}

- (void)useGestures
{
    LGRViewController<LGRDrawerViewControllerDelegate> *page = (LGRViewController<LGRDrawerViewControllerDelegate> *)self.tab.selectedViewController;
    
    if ([page conformsToProtocol:@protocol(LGRDrawerViewControllerDelegate)]) {
        [page useGestures];
    }
}

- (void)userInteractionEnabled:(BOOL)enabled
{
    self.tab.tabBar.userInteractionEnabled = enabled;
    
    LGRViewController<LGRDrawerViewControllerDelegate> *page = (LGRViewController<LGRDrawerViewControllerDelegate> *)self.tab.selectedViewController;
    
    if ([page conformsToProtocol:@protocol(LGRDrawerViewControllerDelegate)]) {
        [page userInteractionEnabled:enabled];
    }
    
    if (self.closeGesture) {
        if (enabled) {
            [self.view removeGestureRecognizer:self.closeGesture];
        } else {
            [self.view addGestureRecognizer:self.closeGesture];
        }
    }
}
@end
