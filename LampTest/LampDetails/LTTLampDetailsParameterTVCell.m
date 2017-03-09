//
//  LTTLampDetailsParameterTVCell.m
//  LampTest
//
//  Created by Garafutdinov Ravil on 05/03/2017.
//  Copyright © 2017 VMB. All rights reserved.
//

#import "LTTLampDetailsParameterTVCell.h"

@interface LTTLampDetailsParameterTVCell()

@property (nonatomic, strong) IBOutlet UILabel *parameterLabel;
@property (nonatomic, strong) IBOutlet UILabel *valueLabel;

@end

@implementation LTTLampDetailsParameterTVCell

- (void)setParameterName:(NSString *)parameterName
{
    _parameterName = parameterName;
    
    self.parameterLabel.text = _parameterName;
}

- (void)setParameterValue:(id)value type:(LTTLampParameterTypes)type color:(UIColor *)color
{
    NSDateFormatter *dateFormatter;
    switch (type) {
        case LTTLampParameterTypeUnknown:
            break;
            
        case LTTLampParameterTypeString:
            self.valueLabel.text = value;
            break;
            
        case LTTLampParameterTypeDouble:
            self.valueLabel.text = [NSString stringWithFormat:@"%.1f", [((NSNumber *)value) doubleValue]];
            break;
            
        case LTTLampParameterTypeInteger:
            self.valueLabel.text = [NSString stringWithFormat:@"%i", [((NSNumber *)value) integerValue]];
            break;
            
        case LTTLampParameterTypeBool:
            self.valueLabel.text = ([((NSNumber *)value) boolValue]) ? @"Да" : @"Нет";
            break;
            
        case LTTLampParameterTypeDate:
            dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"dd.MM.yyyy"];
            self.valueLabel.text = [dateFormatter stringFromDate:value];
            break;
    }
    
    self.valueLabel.textColor = color;
}

@end
