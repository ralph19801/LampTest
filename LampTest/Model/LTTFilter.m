//
//  LTTFilter.m
//  LampTest
//
//  Created by Garafutdinov Ravil on 11/03/2017.
//  Copyright © 2017 VMB. All rights reserved.
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
        
        if (property.length == 0) {
            return nil;
        }
        
        switch (self.type) {
            case LTTFilterTypeUnknown:
                return nil;
                
            case LTTFilterTypeString:
                return [NSString stringWithFormat:@"%@ LIKE '*%@*'", property, self.filterStringValue];
                
            case LTTFilterTypeEnum:
                return [NSString stringWithFormat:@"%@ IN '{%@}'", property, self.filterStringValue];
                
            case LTTFilterTypeBool:
                return [NSString stringWithFormat:@"%@ = true", property];
                
            case LTTFilterTypeNumeric:
                return [NSString stringWithFormat:@"%@ BETWEEN {%f, %f}", property, self.filterStartValue, self.filterEndValue];
        }
    }
}

@end
