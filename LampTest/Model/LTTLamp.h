//
//  LTTLamp.h
//  LampTest
//
//  Created by Garafutdinov Ravil on 02/01/2017.
//  Copyright © 2017 VMB. All rights reserved.
//

#import "LTTParameterNamesEnum.h"

typedef NS_ENUM(NSUInteger, LTTLampParameterTypes) {
    LTTLampParameterTypeUnknown = 0,
    LTTLampParameterTypeString,
    LTTLampParameterTypeDouble,
    LTTLampParameterTypeInteger,
    LTTLampParameterTypeBool,
    LTTLampParameterTypeDate
};

@interface LTTLamp : RLMObject

@property (nonatomic, assign) NSInteger num;    // номер лампы, уникально
@property (nonatomic, assign) NSInteger angle;  // угол освещения, градусы
@property (nonatomic, assign) bool actual;      // есть ли в продаже
@property (nonatomic, strong) NSString *base;   // цоколь, ENUM
@property (nonatomic, strong) NSString *brand;  // бренд, ENUM
@property (nonatomic, assign) NSInteger brightness; // яркость, Лм
@property (nonatomic, strong) NSString *code;   // штрихкод
@property (nonatomic, assign) NSInteger color;  // цвет, K
@property (nonatomic, assign) double CRI;       // CRI
@property (nonatomic, strong) NSDate *date;     // дата тестирования
@property (nonatomic, assign) NSInteger diameter;   // диаметр лампы, мм
@property (nonatomic, assign) bool dimmerAllowed;   // поддержка диммера
@property (nonatomic, assign) NSInteger durability; // срок службы, час
@property (nonatomic, assign) NSInteger height;     // высота, мм
@property (nonatomic, assign) double effectivity;   // эффективность, Лм*Вт
@property (nonatomic, strong) NSString *link;       // ссылка
@property (nonatomic, strong) NSString *shop;       // ссылка на магазин
@property (nonatomic, strong) NSString *made;       // изготовлена
@property (nonatomic, strong) NSString *matte;      // матовая
@property (nonatomic, strong) NSString *model;      // модель
@property (nonatomic, assign) NSInteger nominalBrightness;  // заявленная яркость, Лм
@property (nonatomic, assign) NSInteger nominalColor;   // заявленный цвет, К
@property (nonatomic, assign) double nominalCRI;    // заявленный CRI
@property (nonatomic, assign) double nominalPower;  // заявленная потребляемая мощность, Вт
@property (nonatomic, assign) NSInteger nominalPowerEquivalent; // заявленный световой эквивалент, К
@property (nonatomic, assign) NSInteger priceRub;   // цена в рублях - или
@property (nonatomic, assign) double priceUsd;      // цена в долларах - или
@property (nonatomic, assign) double PF;            // ???
@property (nonatomic, assign) double power;         // потребляемая мощность, Вт
@property (nonatomic, assign) NSInteger powerEquivalent;    // световой эквивалент, Вт
@property (nonatomic, assign) NSInteger pulsation;  // пульсация, %
@property (nonatomic, assign) double rating;        // рейтинг, [0-5]
@property (nonatomic, assign) NSInteger R9;         // ???
@property (nonatomic, strong) NSString *shape;      // форма лампы, ENUM
@property (nonatomic, strong) NSString *subtype;    // подтип, ENUM
@property (nonatomic, strong) NSString *switchAllowed;  // поддержка выключателя с индикатором, 0-2
@property (nonatomic, strong) NSString *type;       // тип, ENUM
@property (nonatomic, assign) NSInteger voltageStart;   // указанное минимальное напряжение, В
@property (nonatomic, assign) NSInteger voltageEnd; // указанное максимальное напряжение, В
@property (nonatomic, assign) NSInteger voltageMin; // измеренное минимальное напряжение, В
@property (nonatomic, assign) NSInteger warranty;   // гарантия, мес

+ (LTTLampParameterTypes)typeOfParameter:(LTTParserNamesToProperties)param;
- (id)valueOfParameter:(LTTParserNamesToProperties)param;
+ (NSString *)nameForParameter:(LTTParserNamesToProperties)param;
+ (NSString *)propertyForParameter:(LTTParserNamesToProperties)param;

@end
