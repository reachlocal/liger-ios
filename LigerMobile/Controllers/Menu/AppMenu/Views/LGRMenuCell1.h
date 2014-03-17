//
//  LGRMenuCell.h
//  Liger
//
//  Created by John Gustafsson on 4/30/13.
//  Copyright (c) 2013-2014 ReachLocal Inc. All rights reserved.  https://github.com/reachlocal/liger-ios/blob/master/LICENSE
//

@interface LGRMenuCell1 : UITableViewCell
@property(nonatomic, readonly, retain) UILabel *menuName;

@property(nonatomic, retain) UIColor *menu1TextColor UI_APPEARANCE_SELECTOR;
@property(nonatomic, retain) UIColor *menu1TextColorSelected UI_APPEARANCE_SELECTOR;

@property(nonatomic, retain) UIFont *menuNameFont UI_APPEARANCE_SELECTOR;
@end
