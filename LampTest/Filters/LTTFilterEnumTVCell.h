//
//  LTTFilterEnumTVCell.h
//  LampTest
//
//  Created by Garafutdinov Ravil on 14/03/2017.
//  Copyright © 2017 VMB. All rights reserved.
//

@class LTTFilter;

@interface LTTFilterEnumTVCell : UITableViewCell

@property (nonatomic, strong) LTTFilter *filter;
@property (nonatomic, strong) id option;
@property (nonatomic, assign) BOOL checked;

@end
