//
//  LTTLampListTVC.h
//  LampTest
//
//  Created by Garafutdinov Ravil on 24/02/2017.
//  Copyright © 2017 LampTest. All rights reserved.
//

#import "LTTLampListViewModel.h"

@interface LTTLampListTVC : UITableViewController

@property (nonatomic, weak) LTTLampListViewModel *viewModel;
    
@property (nonatomic, copy) void (^onRowSelected)(NSInteger rowIndex);

@end
