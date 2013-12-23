//
//  LGRLiger.h
//  Liger
//
//  Created by John Gustafsson on 2/25/13.
//  Copyright (c) 2013 ReachLocal, Inc. All rights reserved.
//

#import "CDVPlugin.h"

@interface LGRLiger : CDVPlugin

// Cordova
- (void)openPage:(CDVInvokedUrlCommand*)command;
- (void)openDialog:(CDVInvokedUrlCommand*)command;
- (void)openDialogWithTitle:(CDVInvokedUrlCommand*)command;
- (void)closeDialog:(CDVInvokedUrlCommand*)command;
- (void)toolbar:(CDVInvokedUrlCommand*)command;
- (void)getPageArgs:(CDVInvokedUrlCommand*)command;
- (void)userCanRefresh:(CDVInvokedUrlCommand*)command;

@end
