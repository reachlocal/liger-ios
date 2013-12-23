//
//  LGRMenuCell.h
//  Liger
//
//  Created by John Gustafsson on 4/30/13.
//  Copyright (c) 2013 ReachLocal, Inc. All rights reserved.
//

@interface LGRMenuCell2 : UITableViewCell
@property(nonatomic, readonly, retain) UILabel *menuName;
@property(nonatomic, readonly, retain) UILabel *menuDetail;

@property(nonatomic, retain) UIColor *menu2TextColor UI_APPEARANCE_SELECTOR;
@property(nonatomic, retain) UIColor *menu2TextColorSelected UI_APPEARANCE_SELECTOR;

@property(nonatomic, retain) UIFont *menuNameFont UI_APPEARANCE_SELECTOR;
@property(nonatomic, retain) UIFont *menuDetailFont UI_APPEARANCE_SELECTOR;
@end
