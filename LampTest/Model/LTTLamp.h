//
//  LTTLamp.h
//  LampTest
//
//  Created by Garafutdinov Ravil on 02/01/2017.
//  Copyright © 2017 VMB. All rights reserved.
//

@interface LTTLamp : RLMObject

@property (nonatomic, assign) NSInteger num;
@property (nonatomic, assign) NSInteger angle;
@property (nonatomic, assign) bool actual;
@property (nonatomic, strong) NSString *brand;
@property (nonatomic, assign) NSInteger brightness;
@property (nonatomic, strong) NSString *capType;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, assign) NSInteger color;
@property (nonatomic, assign) double CRI;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, assign) NSInteger diameter;
@property (nonatomic, assign) bool dimmerAllowed;
@property (nonatomic, assign) NSInteger durability;
@property (nonatomic, assign) NSInteger height;
@property (nonatomic, strong) NSString *link;
@property (nonatomic, strong) NSString *link2;
@property (nonatomic, strong) NSString *made;
@property (nonatomic, assign) NSInteger matte;
@property (nonatomic, strong) NSString *model;
@property (nonatomic, assign) NSInteger nominalBrightness;
@property (nonatomic, assign) NSInteger nominalColor;
@property (nonatomic, assign) double nominalCRI;
@property (nonatomic, assign) double nominalPower;
@property (nonatomic, assign) NSInteger nominalPowerEquivalent;
@property (nonatomic, assign) NSInteger priceRub;
@property (nonatomic, assign) double priceUsd;
@property (nonatomic, strong) NSString *p40;
@property (nonatomic, strong) NSString *p60;
@property (nonatomic, assign) double PF;
@property (nonatomic, assign) double power;
@property (nonatomic, assign) NSInteger powerEquivalent;
@property (nonatomic, assign) NSInteger pulsation;
@property (nonatomic, assign) double rating;
@property (nonatomic, assign) NSInteger R9;
@property (nonatomic, strong) NSString *subtype;
@property (nonatomic, assign) NSInteger switchAllowed;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *view;
@property (nonatomic, assign) NSInteger voltageStart;
@property (nonatomic, assign) NSInteger voltageEnd;
@property (nonatomic, assign) NSInteger warranty;

@end
