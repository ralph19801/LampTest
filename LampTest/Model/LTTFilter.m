//
//  LTTFilter.m
//  LampTest
//
//  Created by Garafutdinov Ravil on 11/03/2017.
//  Copyright © 2017 LampTest. All rights reserved.
//

#import "LTTFilter.h"
#import "LTTLamp.h"

@implementation LTTFilter

- (NSString *)predicateString
{
    if ( ! self.isActive ) {
        return nil;
    }
    else {
        NSString *property = [LTTLamp propertyForParameter:self.param];
        
        if ( ! property ) {
            return nil;
        }
        
        LTTLampParameterTypes paramType = [LTTLamp typeOfParameter:self.param];
        switch (self.type) {
            case LTTFilterTypeUnknown:
                return nil;
                
            case LTTFilterTypeString:
                return [NSString stringWithFormat:@"%@ LIKE '*%@*'", property, self.stringValue];
                
            case LTTFilterTypeEnum:
                return [NSString stringWithFormat:@"%@ IN {%@}", property, self.stringValue];
                
            case LTTFilterTypeBool:
                return [NSString stringWithFormat:@"%@ = true", property];
                
            case LTTFilterTypeNumeric:
                if (self.param == LTTLampVoltage) {
                    NSString *startProperty = [LTTLamp propertyForParameter:LTTLampVoltageStart];
                    NSString *endProperty = [LTTLamp propertyForParameter:LTTLampVoltageEnd];
                    return [NSString stringWithFormat:@"%@ <= %li AND %@ >= %li",
                            startProperty, (long)self.maxValue, endProperty, (long)self.minValue];
                }
                else {
                    if (paramType == LTTLampParameterTypeInteger) {
                        return [NSString stringWithFormat:@"%@ >= %li AND %@ <= %li", property, (long)self.minValue, property, (long)self.maxValue];
                    }
                    else {
                        return [NSString stringWithFormat:@"%@ >= %.1f AND %@ <= %.1f", property, self.minValue, property, self.maxValue];
                    }
                }
        }
    }
}

@end
