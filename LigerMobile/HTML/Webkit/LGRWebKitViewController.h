//
//  LGRWebKitViewController.h
//  Pods
//
//  Created by John Gustafsson on 8/25/14.
//
//

#import "LGRHTMLEngine.h"

@interface LGRWebKitViewController : UIViewController<LGRHTMLEngine>
- (id)initWithPage:(NSString*)page title:(NSString*)title args:(NSDictionary*)args options:(NSDictionary*)options;
@end
