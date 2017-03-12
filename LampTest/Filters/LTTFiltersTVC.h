//
//  LTTFiltersTVC.h
//  LampTest
//
//  Created by Garafutdinov Ravil on 08/03/2017.
//  Copyright © 2017 VMB. All rights reserved.
//

@class LTTFilterManager;
@class LTTFilter;

@interface LTTFiltersTVC : UITableViewController

@property (nonatomic, strong) LTTFilterManager *filterManager;

@property (nonatomic, copy) void (^onStringFilterSelected)(LTTFilter *filter);

@end
