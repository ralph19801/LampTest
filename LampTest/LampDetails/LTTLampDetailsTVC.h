//
//  LTTLampDetailsTVC.h
//  LampTest
//
//  Created by Garafutdinov Ravil on 05/03/2017.
//  Copyright © 2017 LampTest. All rights reserved.
//

@class LTTLamp;

@interface LTTLampDetailsTVC : UITableViewController

@property (nonatomic, weak) LTTLamp *lamp;
@property (nonatomic, copy) void (^onImageSelected)(NSString *imagePath);

@end
