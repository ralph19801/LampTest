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
    
    NSString *firstOption = nil;
    NSString *secondOption = nil;
    NSArray *options = nil;
    if (self.filter.isActive) {
        switch (self.filter.type) {
            case LTTFilterTypeUnknown:
            case LTTFilterTypeBool:
                break;
                
            case LTTFilterTypeString:
                self.valueLabel.text = [NSString stringWithFormat:@"%@", self.filter.stringValue];
                break;
                
            case LTTFilterTypeNumeric:
                if (paramType == LTTLampParameterTypeDouble) {
                    if (self.filter.minValue == self.filter.maxValue) {
                         self.valueLabel.text = [NSString stringWithFormat:@"%.1f", self.filter.minValue];
                    }
                    else {
                        self.valueLabel.text = [NSString stringWithFormat:@"от %.1f до %.1f", self.filter.minValue, self.filter.maxValue];
                    }
                }
                else {
                    if (self.filter.minValue == self.filter.maxValue) {
                        self.valueLabel.text = [NSString stringWithFormat:@"%li", (long)round(self.filter.minValue)];
                    }
                    else {
                        self.valueLabel.text = [NSString stringWithFormat:@"от %li до %li", (long)round(self.filter.minValue), (long)round(self.filter.maxValue)];
                    }
                }
                break;
                
            case LTTFilterTypeEnum:
                options = [self.filter.stringValue componentsSeparatedByString:@","];
                for (NSString *option in options) {
                    secondOption = [option stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"'"]];
                    if ( ! firstOption ) {
                        firstOption = secondOption;
                    }
                    else {
                        break;
                    }
                }

                if (options.count == 1) {
                    self.valueLabel.text = firstOption;
                }
                else if (options.count == 2) {
                    self.valueLabel.text = [NSString stringWithFormat:@"%@, %@", firstOption, secondOption];
                }
                else {
                    self.valueLabel.text = [NSString stringWithFormat:@"%@ + ещё %u", firstOption, options.count - 1];
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
