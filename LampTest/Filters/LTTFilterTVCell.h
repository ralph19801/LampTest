//
//  LTTFilterTVCell.h
//  LampTest
//
//  Created by Garafutdinov Ravil on 08/03/2017.
//  Copyright © 2017 VMB. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LTTFilter;

@interface LTTFilterTVCell : UITableViewCell

@property (nonatomic, weak) LTTFilter *filter;
@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UILabel *valueLabel;

@end
