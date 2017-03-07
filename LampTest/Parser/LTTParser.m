//
//  LTTParser.m
//  LampTest
//
//  Created by Garafutdinov Ravil on 23/02/2017.
//  Copyright © 2017 VMB. All rights reserved.
//

#import "LTTParser.h"
#import <CHCSVParser/CHCSVParser.h>
#import "LTTLamp.h"
#import "LTTParameterNamesEnum.h"

@interface LTTParser () <CHCSVParserDelegate>

@property (nonatomic, assign) NSStringEncoding encoding;
@property (nonatomic, strong) NSDictionary *namesToProperties;

@property (nonatomic, assign) BOOL namesRow;
@property (nonatomic, strong) NSMutableDictionary *fieldNames;

@property (nonatomic, strong) NSMutableArray *lamps;
@property (nonatomic, strong) LTTLamp *currentLamp;

@property (nonatomic, copy) void (^completion)(NSArray *);

@end

@implementation LTTParser

- (instancetype)init
{
    if (self = [super init]) {
        _namesToProperties = @{
                               @"no" : @(LTTLampNumber),
                               @"brand" : @(LTTLampBrand),
                               @"model" : @(LTTLampModel),
                               @"power_l" : @(LTTLampNominalPower),
                               @"url" : @(LTTLampLink),
                               @"shop" : @(LTTLampShop),
                               @"rub" : @(LTTLampPriceRub),
                               @"usd" : @(LTTLampPriceUsd),
                               @"barcode" : @(LTTLampCode),
                               @"d" : @(LTTLampDiameter),
                               @"h" : @(LTTLampHeight),
                               @"u" : @(LTTLampVoltage), // составной, 220-240
                               @"base" : @(LTTLampBase),
                               @"shape" : @(LTTLampShape),
                               @"type" : @(LTTLampType),
                               @"type2" : @(LTTLampSubtype),
                               @"matt" : @(LTTLampMatte),
                               @"lm_l" : @(LTTLampNominalBrightness),
                               @"eq_l" : @(LTTLampNominalPowerEquivalent),
                               @"color_l" : @(LTTLampNominalColor),
                               @"ra_l" : @(LTTLampNominalCRI),
                               @"life" : @(LTTLampDurability),
                               @"war" : @(LTTLampWarranty),
                               @"prod" : @(LTTLampMade),
                               @"dim" : @(LTTLampDimmer),
                               @"switch" : @(LTTLampSwitch),
                               @"p" : @(LTTLampPower),
                               @"lm" : @(LTTLampBrightness),
                               @"eq" : @(LTTLampPowerEquivalent),
                               @"color" : @(LTTLampColor),
                               @"cri" : @(LTTLampCRI),
                               @"r9" : @(LTTLampR9),
                               @"angle" : @(LTTLampAngle),
                               @"flicker" : @(LTTLampPulsation),
                               @"pf" : @(LTTLampPF),
                               @"date" : @(LTTLampDate),
                               @"rating" : @(LTTLampRating),
                               @"act" : @(LTTLampActual),
                               @"u_min" : @(LTTLampVoltageMin),
                               @"___" : @(LTTLampEffectivity)  // нет в CSV, расчетный
                               };
    }
    return self;
}

- (void)parse:(void (^)(NSArray *results))completion;
{
    self.lamps = [NSMutableArray new];
    self.completion = completion;
    
    self.encoding = NSWindowsCP1251StringEncoding;
    NSURL *csvUrl = [[NSBundle mainBundle] URLForResource:@"led" withExtension:@"csv"];
    NSInputStream *stream = [[NSInputStream alloc] initWithURL:csvUrl];
    CHCSVParser *parser = [[CHCSVParser alloc] initWithInputStream:stream usedEncoding:&_encoding delimiter:';'];
    parser.delegate = self;
    
    [parser parse];
}

#pragma mark - CHCSVDelegate
- (void)parser:(CHCSVParser *)parser didBeginLine:(NSUInteger)recordNumber
{
    self.namesRow = (recordNumber == 1);
    
    if ( ! self.namesRow ) {
        self.currentLamp = [[LTTLamp alloc] init];
    }
}

- (void)parser:(CHCSVParser *)parser didEndLine:(NSUInteger)recordNumber
{
    if ( ! self.namesRow ) {
        self.currentLamp.effectivity = (self.currentLamp.power > 0) ? self.currentLamp.brightness / self.currentLamp.power : 0;
        [self.lamps addObject:self.currentLamp];
    }
}

- (void)parser:(CHCSVParser *)parser didReadField:(NSString *)field atIndex:(NSInteger)fieldIndex
{
    if (self.namesRow) {
        [self recordFieldName:field atIndex:fieldIndex];
    }
    else {
        NSString *fn = self.fieldNames[@(fieldIndex)];
        
        if (fn) {
            [self parseField:fn value:field];
        }
        else {
            NSLog(@"unknown row %i", fieldIndex);
        }
    }
}

- (void)parserDidEndDocument:(CHCSVParser *)parser
{
    if (self.completion) {
        self.completion(self.lamps);
    }
}

- (void)parser:(CHCSVParser *)parser didFailWithError:(NSError *)error
{
    
}

#pragma mark - Private

- (void)recordFieldName:(NSString *)fieldName atIndex:(NSInteger)index
{
    if ( ! self.fieldNames ) {
        self.fieldNames = [NSMutableDictionary new];
    }
    
    if (fieldName) {
        self.fieldNames[@(index)] = fieldName;
    }
    else {
        NSLog(@"trying to record fieldname %@ at %i", fieldName, index);
    }
}

- (LTTParserNamesToProperties)propertyForFieldName:(NSString *)fieldName
{
    if ( ! fieldName ) {
        return LTTLampUnknown;
    }
    
    NSNumber *propertyNumber = self.namesToProperties[fieldName];
    
    if (propertyNumber) {
        return [propertyNumber integerValue];
    }
   
    return LTTLampUnknown;
}

- (void)parseField:(NSString *)fieldName value:(NSString *)value
{
    LTTParserNamesToProperties property = [self propertyForFieldName:fieldName];
    
    if (property == LTTLampUnknown) {
        return;
    }
    
    NSRange minusRange;
    NSMutableString *mutableValue;
    NSDateFormatter *dateFormatter;
    
    switch (property) {
            
        case LTTLampUnknown:
            break;
            
        case LTTLampNumber:
            self.currentLamp.num = [value integerValue];
            break;
            
        case LTTLampBrand:
            self.currentLamp.brand = value;
            break;
            
        case LTTLampModel:
            self.currentLamp.model = value;
            break;
            
        case LTTLampNominalPower:
            self.currentLamp.nominalPower = [value doubleValue];
            break;
            
        case LTTLampLink:
            self.currentLamp.link = value;
            break;
            
        case LTTLampShop:
            self.currentLamp.shop = value;
            break;
            
        case LTTLampPriceRub:
            self.currentLamp.priceRub = [value integerValue];
            break;
            
        case LTTLampPriceUsd:
            self.currentLamp.priceUsd = [value doubleValue];
            break;
            
        case LTTLampCode:
            self.currentLamp.code = value;
            break;
            
        case LTTLampDiameter:
            self.currentLamp.diameter = [value integerValue];
            break;
            
        case LTTLampHeight:
            self.currentLamp.height = [value integerValue];
            break;
            
        case LTTLampVoltage:
            minusRange = [value rangeOfString:@"-"];
            if (minusRange.location != NSNotFound) { // составное значение через дефис
                NSString *firstPart = [value substringToIndex:minusRange.location];
                NSString *secondPath = [value substringFromIndex:minusRange.location + 1];
                self.currentLamp.voltageStart = [firstPart integerValue];
                self.currentLamp.voltageEnd = [secondPath integerValue];
            }
            else { // одно значение
                self.currentLamp.voltageStart = self.currentLamp.voltageEnd = [value integerValue];
            }
            break;
            
        case LTTLampBase:
            self.currentLamp.base = value; //TODO сохранить все варианты
            break;
            
        case LTTLampShape:
            self.currentLamp.shape = value; //TODO сохранить варианты
            break;
            
        case LTTLampType:
            self.currentLamp.type = value; // -||-
            break;
            
        case LTTLampSubtype:
            self.currentLamp.subtype = value; // -||-
            break;
            
        case LTTLampMatte:
            self.currentLamp.matte = [value integerValue];
            break;
            
        case LTTLampNominalBrightness:
            self.currentLamp.nominalBrightness = [value integerValue];
            break;
            
        case LTTLampNominalPowerEquivalent:
            self.currentLamp.nominalPowerEquivalent = [value integerValue];
            break;
            
        case LTTLampNominalColor:
            self.currentLamp.nominalColor = [value integerValue];
            break;
            
        case LTTLampNominalCRI:
            self.currentLamp.nominalCRI = [value doubleValue];
            break;
            
        case LTTLampDurability:
            self.currentLamp.durability = [value integerValue];
            break;
            
        case LTTLampWarranty:
            self.currentLamp.warranty = [value integerValue];
            break;
            
        case LTTLampMade: // 613 -> 06.13
            if ([value doubleValue] == 0) {
                self.currentLamp.made = @"";
            }
            else {
                mutableValue = [[NSMutableString stringWithFormat:@"%04.0f", [value doubleValue]] mutableCopy];
                [mutableValue insertString:@"." atIndex:2];
                self.currentLamp.made = [mutableValue copy];
            }
            break;
            
        case LTTLampDimmer:
            self.currentLamp.dimmerAllowed = [value boolValue];
            break;
            
        case LTTLampSwitch:
            self.currentLamp.switchAllowed = [value integerValue];
            break;
         
        case LTTLampPower:
            self.currentLamp.power = [value doubleValue];
            break;
    
        case LTTLampBrightness:
            self.currentLamp.brightness = [value integerValue];
            break;
       
        case LTTLampPowerEquivalent:
            self.currentLamp.powerEquivalent = [value integerValue];
            break;
       
        case LTTLampColor:
            self.currentLamp.color = [value integerValue];
            break;
        
        case LTTLampCRI:
            self.currentLamp.CRI = [value doubleValue];
            break;
        
        case LTTLampR9:
            self.currentLamp.R9 = [value integerValue];
            break;
        
        case LTTLampAngle:
            self.currentLamp.angle = [value integerValue];
            break;
        
        case LTTLampPulsation:
            self.currentLamp.pulsation = [value integerValue];
            break;
        
        case LTTLampPF:
            self.currentLamp.PF = [value doubleValue];
            break;
        
        case LTTLampDate:
            dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"dd.MM.yyyy"];
            self.currentLamp.date = [dateFormatter dateFromString:value];
            break;
        
        case LTTLampRating:
            self.currentLamp.rating = [value doubleValue];
            break;
            
        case LTTLampActual:
            self.currentLamp.actual = [value boolValue];
            break;
        
        case LTTLampVoltageMin:
            self.currentLamp.voltageMin = [value integerValue];
            break;
            
        case LTTLampEffectivity:
            // подсчитывается в конце
            break;
    }
}

@end
