//
//  LGRCordovaViewControllerTest.m
//  Liger
//
//  Created by John Gustafsson on 4/18/14.
//  Copyright (c) 2014 ReachLocal Inc. All rights reserved.
//

@import XCTest;
#import "LGRCordovaViewController.h"


@interface LGRCordovaViewControllerTest : XCTestCase
@property (nonatomic, strong) LGRCordovaViewController* cordova;
@end

@implementation LGRCordovaViewControllerTest

- (void)setUp
{
    [super setUp];

	self.cordova = [[LGRCordovaViewController alloc] initWithPage:@"firstPage" title:@"title" args:@{}];
}

- (void)tearDown
{

    [super tearDown];
}

- (void)testRefreshPage
{
	
}

@end
