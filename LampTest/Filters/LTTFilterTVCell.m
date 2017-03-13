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
            
        case LTTSortModel:
            self.nameLabel.text = @"По модели";
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
    LTTLampParameterTypes paramType = [LTTLamp typeOfParameter:self.filter.param];
    
    if (self.filter.isActive) {
        switch (self.filter.type) {
            case LTTFilterTypeUnknown:
            case LTTFilterTypeBool:
                break;
                
            case LTTFilterTypeString:
                self.valueLabel.text = [NSString stringWithFormat:@"*%@*", self.filter.stringValue];
                break;
                
            case LTTFilterTypeNumeric:
                if (paramType == LTTLampParameterTypeInteger) {
                    self.valueLabel.text = [NSString stringWithFormat:@"от %i до %i", (NSInteger)self.filter.minValue, (NSInteger)self.filter.maxValue];
                }
                else {
                    self.valueLabel.text = [NSString stringWithFormat:@"от %.1f до %.1f", self.filter.minValue, self.filter.maxValue];
                }
                break;
        }
    }
}

- (IBAction)onDropFilterTouch:(id)sender
{
    SAFE_RUN(self.onDropFilter, self.filter);
}

@end
