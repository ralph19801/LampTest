//
//  LTTFilterEnumTVC.h
//  LampTest
//
//  Created by Garafutdinov Ravil on 14/03/2017.
//  Copyright © 2017 LampTest. All rights reserved.
//

@class LTTFilter;

@interface LTTFilterEnumTVC : UITableViewController

@property (nonatomic, strong) LTTFilter *filter;
@property (nonatomic, strong, readonly) NSMutableSet *selectedOptions;

@end
