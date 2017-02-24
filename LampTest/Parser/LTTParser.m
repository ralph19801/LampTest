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

typedef NS_ENUM(NSUInteger, LTTParserNamesToProperties) {
    LTTLampUnknown = 0,
    LTTLampNumber,
    LTTLampBrand,
    LTTLampModel,
    LTTLampNominalPower,
    LTTLampLink,
    LTTLampLink2,
    LTTLampPriceRub,
    LTTLampPriceUsd,
    LTTLampCode,
    LTTLampDiameter,
    LTTLampHeight,
    LTTLampVoltage,
    LTTLampCapType,
    LTTLampView,
    LTTLampType,
    LTTLampSubtype,
    LTTLampMatte,
    LTTLampNominalBrightness,
    LTTLampNominalPowerEquivalent,
    LTTLampNominalColor,
    LTTLampNominalCRI,
    LTTLampDurability,
    LTTLampWarranty,
    LTTLampMade,
    LTTLampDimmer,
    LTTLampSwitch,
    LTTLampPower,
    LTTLampBrightness,
    LTTLampPowerEquivalent,
    LTTLampColor,
    LTTLampCRI,
    LTTLampR9,
    LTTLampAngle,
    LTTLampPulsation,
    LTTLampPF,
    LTTLampDate,
    LTTLampRating,
    LTTLamp60,
    LTTLamp40,
    LTTLampActual
};

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
                               @"№" : @(LTTLampNumber),
                               @"Бренд" : @(LTTLampBrand),
                               @"Модель" : @(LTTLampModel),
                               @"P'" : @(LTTLampNominalPower),
                               @"Ссылка" : @(LTTLampLink),
                               @"" : @(LTTLampLink2),           // заголовок пустая строка
                               @"руб." : @(LTTLampPriceRub),
                               @"$" : @(LTTLampPriceUsd),
                               @"Штрихкод" : @(LTTLampCode),
                               @"Диаметр" : @(LTTLampDiameter),
                               @"Высота" : @(LTTLampHeight),
                               @"Напряжение" : @(LTTLampVoltage), // составной, 220-240
                               @"Цок." : @(LTTLampCapType),
                               @"Вид" : @(LTTLampView),
                               @"Тип" : @(LTTLampType),
                               @"Подтип" : @(LTTLampSubtype),
                               @"Мат" : @(LTTLampMatte),
                               @"Лм'" : @(LTTLampNominalBrightness),
                               @"Экв'" : @(LTTLampNominalPowerEquivalent),
                               @"Цвет'" : @(LTTLampNominalColor),
                               @"Ra" : @(LTTLampNominalCRI),
                               @"Срок" : @(LTTLampDurability),
                               @"Гар" : @(LTTLampWarranty),
                               @"Изг" : @(LTTLampMade),
                               @"Дим" : @(LTTLampDimmer),
                               @"Вык" : @(LTTLampSwitch),
                               @"P" : @(LTTLampPower),
                               @"Лм" : @(LTTLampBrightness),
                               @"Экв" : @(LTTLampPowerEquivalent),
                               @"Цвет" : @(LTTLampColor),
                               @"CRI" : @(LTTLampCRI),
                               @"R9" : @(LTTLampR9),
                               @"Угол" : @(LTTLampAngle),
                               @"Пульс" : @(LTTLampPulsation),
                               @"PF" : @(LTTLampPF),
                               @"Дата" : @(LTTLampDate),
                               @"Итог" : @(LTTLampRating),
                               @"60" : @(LTTLamp60),
                               @"40" : @(LTTLamp40),
                               @"Актуальна" : @(LTTLampActual)
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
            
        case LTTLampLink2:
            self.currentLamp.link2 = value;
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
            
        case LTTLampCapType:
            self.currentLamp.capType = value; //TODO сохранить все варианты
            break;
            
        case LTTLampView:
            self.currentLamp.view = value; //TODO сохранить варианты
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
            
        case LTTLampMade:
            //TODO string -> str.ing
            self.currentLamp.made = value;
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
//            self.currentLamp.date =
            //todo
            break;
        
        case LTTLampRating:
            self.currentLamp.rating = [value doubleValue];
            break;
        
        case LTTLamp60:
            self.currentLamp.p60 = value;
            break;
            
        case LTTLamp40:
            self.currentLamp.p40 = value;
            break;
            
        case LTTLampActual:
            self.currentLamp.actual = [value boolValue];
            break;
    }
}

@end
