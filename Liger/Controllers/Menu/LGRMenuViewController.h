//
//  LGRMenuViewController.h
//  Liger
//
//  Created by John Gustafsson on 11/25/13.
//  Copyright (c) 2013-2014 ReachLocal Inc. All rights reserved.  https://github.com/reachlocal/liger-ios/blob/master/LICENSE
//

#import "LGRViewController.h"

typedef void (^DisplayController)(UIViewController* controller);
typedef void (^DisplayDialog)();

@interface LGRMenuViewController : LGRViewController
@property (nonatomic, strong) DisplayController displayController;
@property (nonatomic, strong) DisplayDialog displayDialog;
@property (nonatomic, weak) NSMutableDictionary *pages;
@end
