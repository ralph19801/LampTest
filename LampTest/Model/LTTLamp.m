//
//  LTTLamp.m
//  LampTest
//
//  Created by Garafutdinov Ravil on 02/01/2017.
//  Copyright © 2017 VMB. All rights reserved.
//

#import "LTTLamp.h"

@implementation LTTLamp

+ (LTTLampParameterTypes)typeOfParameter:(LTTParserNamesToProperties)param
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
        case LTTLampVoltageMin:
        case LTTLampPriceRub:
        case LTTLampNominalBrightness:
        case LTTLampBrightness:
        case LTTLampPulsation:
        case LTTLampAngle:
        case LTTLampR9:
        case LTTLampVoltageStart:
        case LTTLampVoltageEnd:
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
        case LTTLampSwitch:
        case LTTLampMatte:
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
            return self.matte;
            
        case LTTLampVoltage:
            if (self.voltageStart == self.voltageEnd) {
                return [NSString stringWithFormat:@"%li", (long)self.voltageStart];
            }
            return [NSString stringWithFormat:@"%li-%li", (long)self.voltageStart, (long)self.voltageEnd];
            
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
            return self.switchAllowed;
            
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
            
        case LTTLampVoltageStart:
            return @(self.voltageStart);
            
        case LTTLampVoltageEnd:
            return @(self.voltageEnd);
    }
}

+ (NSString *)nameForParameter:(LTTParserNamesToProperties)param
{
    static NSDictionary *rowNames;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        rowNames = @{
                  @(LTTLampBrand) : @"изготовитель",
                  @(LTTLampModel) : @"модель или артикул",
                  @(LTTLampCode) : @"штрихкод",
                  @(LTTLampBase) : @"тип цоколя",
                  @(LTTLampShape) : @"вид",
                  @(LTTLampType) : @"тип",
                  @(LTTLampSubtype) : @"подтип",
                  @(LTTLampMatte) : @"матовость",
                  @(LTTLampNominalPower) : @"заявленная мощность, Вт",
                  @(LTTLampNominalBrightness) : @"заявленный световой поток, Лм",
                  @(LTTLampNominalPowerEquivalent) : @"заявленный эквивалент, Вт",
                  @(LTTLampNominalColor) : @"заявленная цветовая температура, К",
                  @(LTTLampDurability) : @"заявленный срок службы, час",
                  @(LTTLampPower) : @"измеренная мощность, Вт",
                  @(LTTLampBrightness) : @"измеренный световой поток, Лм",
                  @(LTTLampEffectivity) : @"эффективность (люмен/ватт)",
                  @(LTTLampPowerEquivalent) : @"измеренный эквивалент, Вт",
                  @(LTTLampColor) : @"измеренная цветовая температура, К",
                  @(LTTLampNominalCRI) : @"заявленный CRI, не менее",
                  @(LTTLampCRI) : @"измеренный CRI",
                  @(LTTLampAngle) : @"измеренный угол освещения, град.",
                  @(LTTLampPulsation) : @"измеренный коэффициент пульсации, %",
                  @(LTTLampSwitch) : @"работа с выключателем, имеющим индикатор",
                  @(LTTLampDimmer) : @"диммирование",
                  @(LTTLampDiameter) : @"диаметр лампы, мм",
                  @(LTTLampHeight) : @"высота лампы, мм",
                  @(LTTLampVoltage) : @"заявленное рабочее напряжение, В",
                  @(LTTLampVoltageMin) : @"измеренное минимальное напряжение, В",
                  @(LTTLampPriceRub) : @"цена в рублях",
                  @(LTTLampPriceUsd) : @"цена в долларах",
                  @(LTTLampMade) : @"дата изготовления лампы",
                  @(LTTLampDate) : @"дата тестирования",
                  @(LTTLampActual) : @"актуальность лампы",
                  @(LTTLampRating) : @"рейтинг лампы",
                  
                  @(LTTLampWarranty) : @"гарантия",
                  @(LTTLampR9) : @"R9",
                  @(LTTLampPF) : @"PF",
            };
    });
    
    NSString *rowName = rowNames[@(param)];
    if (rowName) {
        return rowName;
    }
    
    return @"";
}

+ (NSString *)propertyForParameter:(LTTParserNamesToProperties)param
{
    static NSDictionary *rowNames;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        rowNames = @{
                     @(LTTLampBrand) : @"brand",
                     @(LTTLampModel) : @"model",
                     @(LTTLampCode) : @"code",
                     @(LTTLampBase) : @"base",
                     @(LTTLampShape) : @"shape",
                     @(LTTLampType) : @"type",
                     @(LTTLampSubtype) : @"subtype",
                     @(LTTLampMatte) : @"matte",
                     @(LTTLampNominalPower) : @"nominalPower",
                     @(LTTLampNominalBrightness) : @"nominalBrightness",
                     @(LTTLampNominalPowerEquivalent) : @"nominalPowerEquivalent",
                     @(LTTLampNominalColor) : @"nominalColor",
                     @(LTTLampDurability) : @"durability",
                     @(LTTLampPower) : @"power",
                     @(LTTLampBrightness) : @"brightness",
                     @(LTTLampEffectivity) : @"effectivity",
                     @(LTTLampPowerEquivalent) : @"powerEquivalent",
                     @(LTTLampColor) : @"color",
                     @(LTTLampNominalCRI) : @"nominalCRI",
                     @(LTTLampCRI) : @"CRI",
                     @(LTTLampAngle) : @"angle",
                     @(LTTLampPulsation) : @"pulsation",
                     @(LTTLampSwitch) : @"switchAllowed",
                     @(LTTLampDimmer) : @"dimmerAllowed",
                     @(LTTLampDiameter) : @"diameter",
                     @(LTTLampHeight) : @"height",
                     @(LTTLampVoltageStart) : @"voltageStart",
                     @(LTTLampVoltageEnd) : @"voltageEnd",
                     @(LTTLampVoltageMin) : @"voltageMin",
                     @(LTTLampPriceRub) : @"priceRub",
                     @(LTTLampPriceUsd) : @"priceUsd",
                     @(LTTLampMade) : @"made",
                     @(LTTLampDate) : @"date",
                     @(LTTLampActual) : @"actual",
                     @(LTTLampRating) : @"rating",
                     
                     @(LTTLampWarranty) : @"warranty",
                     @(LTTLampR9) : @"R9",
                     @(LTTLampPF) : @"PF",
                     @(LTTLampVoltage) : @"" // нет в списке, см. LTTLampVoltageStart и LTTLampVoltageEnd
                     };
    });
    
    NSString *rowName = rowNames[@(param)];
    if (rowName) {
        return rowName;
    }
    
    return @"";
}

@end
