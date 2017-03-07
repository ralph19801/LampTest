//
//  LTTLamp.m
//  LampTest
//
//  Created by Garafutdinov Ravil on 02/01/2017.
//  Copyright © 2017 VMB. All rights reserved.
//

#import "LTTLamp.h"

@implementation LTTLamp

- (LTTLampParameterTypes)typeOfParameter:(LTTParserNamesToProperties)param
{
    switch (param) {
        case LTTLampUnknown:
            return LTTLampParameterTypeUnknown;
            break;
            
        case LTTLampNumber:
        case LTTLampNominalColor:
        case LTTLampColor:
        case LTTLampDiameter:
        case LTTLampHeight:
        case LTTLampDurability:
        case LTTLampWarranty:
        case LTTLampNominalPowerEquivalent:
        case LTTLampPowerEquivalent:
        case LTTLampMatte:
        case LTTLampVoltageMin:
        case LTTLampPriceRub:
        case LTTLampNominalBrightness:
        case LTTLampBrightness:
        case LTTLampPulsation:
        case LTTLampAngle:
        case LTTLampSwitch:
        case LTTLampR9:
            return LTTLampParameterTypeInteger;
            break;
            
        case LTTLampBrand:
        case LTTLampModel:
        case LTTLampLink:
        case LTTLampShop:
        case LTTLampCode:
        case LTTLampBase:
        case LTTLampShape:
        case LTTLampType:
        case LTTLampSubtype:
        case LTTLampMade:
        case LTTLampVoltage:
            return LTTLampParameterTypeString;
            break;
            
        case LTTLampNominalPower:
        case LTTLampPower:
        case LTTLampPriceUsd:
        case LTTLampNominalCRI:
        case LTTLampCRI:
        case LTTLampRating:
        case LTTLampPF:
        case LTTLampEffectivity:
            return LTTLampParameterTypeDouble;
            break;
            
        case LTTLampDimmer:
        case LTTLampActual:
            return LTTLampParameterTypeBool;
            break;
            
        case LTTLampDate:
            return LTTLampParameterTypeDate;
            break;
    }
}

- (id)valueOfParameter:(LTTParserNamesToProperties)param
{
    switch (param) {
        case LTTLampUnknown:
            return nil;
            
        case LTTLampNumber:
            return @(self.num);
            
        case LTTLampNominalColor:
            return @(self.nominalColor);
            
        case LTTLampColor:
            return @(self.color);
            
        case LTTLampDiameter:
            return @(self.diameter);
            
        case LTTLampHeight:
            return @(self.height);
            
        case LTTLampDurability:
            return @(self.durability);
            
        case LTTLampWarranty:
            return @(self.warranty);
            
        case LTTLampNominalPowerEquivalent:
            return @(self.nominalPowerEquivalent);
            
        case LTTLampPowerEquivalent:
            return @(self.powerEquivalent);
            
        case LTTLampMatte:
            return @(self.matte);
            
        case LTTLampVoltage:
            if (self.voltageStart == self.voltageEnd) {
                return [NSString stringWithFormat:@"%i", self.voltageStart];
            }
            return [NSString stringWithFormat:@"%i-%i", self.voltageStart, self.voltageEnd];
            
        case LTTLampVoltageMin:
            return @(self.voltageMin);
            
        case LTTLampPriceRub:
            return @(self.priceRub);
            
        case LTTLampNominalBrightness:
            return @(self.nominalBrightness);
            
        case LTTLampBrightness:
            return @(self.brightness);
            
        case LTTLampPulsation:
            return @(self.pulsation);
            
        case LTTLampAngle:
            return @(self.angle);
            
        case LTTLampSwitch:
            return @(self.switchAllowed);
            
        case LTTLampR9:
            return @(self.R9);
            
        case LTTLampBrand:
            return self.brand;
            
        case LTTLampModel:
            return self.model;
            
        case LTTLampLink:
            return self.link;
            
        case LTTLampShop:
            return self.shop;
            
        case LTTLampCode:
            return self.code;
            
        case LTTLampBase:
            return self.base;
            
        case LTTLampShape:
            return self.shape;
            
        case LTTLampType:
            return self.type;
            
        case LTTLampSubtype:
            return self.subtype;
            
        case LTTLampMade:
            return self.made;
            
        case LTTLampNominalPower:
            return @(self.nominalPower);
            
        case LTTLampPower:
            return @(self.power);
            
        case LTTLampPriceUsd:
            return @(self.priceUsd);
            
        case LTTLampNominalCRI:
            return @(self.nominalCRI);
            
        case LTTLampCRI:
            return @(self.CRI);
            
        case LTTLampRating:
            return @(self.rating);
            
        case LTTLampPF:
            return @(self.PF);
            
        case LTTLampEffectivity:
            return @(self.effectivity);
            
        case LTTLampDimmer:
            return @(self.dimmerAllowed);
            
        case LTTLampActual:
            return @(self.actual);
            
        case LTTLampDate:
            return self.date;
    }
}

@end
