//
//  LTTFilterTVCell.m
//  LampTest
//
//  Created by Garafutdinov Ravil on 08/03/2017.
//  Copyright © 2017 VMB. All rights reserved.
//

#import "LTTFilterTVCell.h"
#import "LTTFilter.h"
#import "LTTLamp.h"

@interface LTTFilterTVCell ()

//@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
//@property (nonatomic, strong) IBOutlet UILabel *valueLabel;

@end

@implementation LTTFilterTVCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setSort:(LTTSort)sort
{
    _sort = sort;
    
    switch (sort) {
        case LTTSortUnknown:
            break;
            
        case LTTSortBrandModel:
            self.nameLabel.text = @"По бренду, потом по модели";
            break;
            
        case LTTSortRating:
            self.nameLabel.text = @"По рейтингу";
            break;
    }
}

- (void)setFilter:(LTTFilter *)filter
{
    _filter = filter;
    
    self.nameLabel.text = [LTTLamp nameForParameter:self.filter.param];
    
    if (self.filter.isActive && self.filter.type == LTTFilterTypeString) {
        self.valueLabel.text = [NSString stringWithFormat:@"\"*%@*\"", self.filter.filterStringValue];
    }
}

@end
