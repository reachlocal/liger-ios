//
//  LGRCordovaViewController.h
//  LigerMobile
//
//  Created by John Gustafsson on 2/21/13.
//  Copyright (c) 2013-2014 ReachLocal Inc. All rights reserved.  https://github.com/reachlocal/liger-ios/blob/master/LICENSE
//

#import "CDVViewController.h"

@interface LGRCordovaViewController : CDVViewController
@property (nonatomic, assign) BOOL userCanRefresh;
@property (nonatomic, strong) NSDictionary *args;

- (id)initWithPage:(NSString*)page title:(NSString*)title args:(NSDictionary*)args options:(NSDictionary*)options;

- (void)dialogClosed:(NSDictionary*)args;
- (void)childUpdates:(NSDictionary*)args;
- (void)refreshPage:(BOOL)wasInitiatedByUser;

- (void)pageWillAppear;
- (void)pushNotificationTokenUpdated:(NSString *)token error:(NSError *)error;
- (void)notificationArrived:(NSDictionary *)userInfo background:(BOOL)background;
- (void)handleAppOpenURL:(NSURL*)url;
- (void)buttonTapped:(NSDictionary*)button;

@end
