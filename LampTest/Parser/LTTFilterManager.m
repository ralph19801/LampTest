//
//  LTTFilterManager.m
//  LampTest
//
//  Created by Garafutdinov Ravil on 09/03/2017.
//  Copyright © 2017 LampTest. All rights reserved.
//

#import "LTTFilterManager.h"
#import "LTTFilter.h"
#import "LTTLamp.h"

CGFloat const LTTFilterNumericParamOff = -1;

@interface LTTFilterManager()

@property (nonatomic, strong, readwrite) NSString *predicateString;

@property (nonatomic, strong) NSArray *filterParams;
@property (nonatomic, strong) NSArray <LTTFilter *> *filters;

@property (nonatomic, strong, readwrite) NSArray <LTTFilter *> *activeFilters;
@property (nonatomic, strong, readwrite) NSArray <LTTFilter *> *filtersPool;

@end

@implementation LTTFilterManager

- (instancetype)init
{
    if (self = [super init]) {
        _sort = LTTSortRating;
        
        _filterParams = @[
                          @(LTTLampRating),
                          @(LTTLampBrand),
                          @(LTTLampModel),
                          @(LTTLampBase),
                          @(LTTLampShape),
                          @(LTTLampType),
                          @(LTTLampSubtype),
                          @(LTTLampNominalPower),
                          @(LTTLampPower),
                          @(LTTLampNominalPowerEquivalent),
                          @(LTTLampPowerEquivalent),
                          @(LTTLampNominalBrightness),
                          @(LTTLampBrightness),
                          @(LTTLampNominalColor),
                          @(LTTLampColor),
                          @(LTTLampNominalCRI),
                          @(LTTLampCRI),
                          @(LTTLampDurability),
                          @(LTTLampEffectivity),
                          @(LTTLampMatte),
                          @(LTTLampAngle),
                          @(LTTLampPulsation),
                          @(LTTLampSwitch),
                          @(LTTLampDimmer),
                          @(LTTLampDiameter),
                          @(LTTLampHeight),
                          @(LTTLampVoltage), //TODO
                          @(LTTLampVoltageMin),
                          @(LTTLampPriceRub),
                          @(LTTLampPriceUsd),
                          @(LTTLampActual),
        ];
        
        [self populateFilters];
        [self updatePools];
    }
    return self;
}

- (void)populateFilters
{
    NSMutableArray *filters = [NSMutableArray arrayWithCapacity:self.filterParams.count];
    
    for (NSInteger i=0; i < self.filterParams.count; i++) {
        LTTParserNamesToProperties param = [self.filterParams[i] integerValue];
        LTTLampParameterTypes paramType = [LTTLamp typeOfParameter:param];
        
        LTTFilter *filter = [LTTFilter new];
        filter.param = param;
        filter.active = NO;
        filter.sortOrder = i;
        filter.stringValue = @"";
        filter.minValue = LTTFilterNumericParamOff;
        filter.maxValue = LTTFilterNumericParamOff;
        
        switch (paramType) {
            case LTTLampParameterTypeUnknown:
                filter.type = LTTFilterTypeUnknown;
                break;
                
            case LTTLampParameterTypeString:
                if (param == LTTLampModel) {
                    filter.type = LTTFilterTypeString;
                }
                else if (param == LTTLampVoltage) {
                    filter.type = LTTFilterTypeNumeric;
                }
                else {
                    filter.type = LTTFilterTypeEnum;
                }
                break;
                
            case LTTLampParameterTypeDouble:
                filter.type = LTTFilterTypeNumeric;
                break;
                
            case LTTLampParameterTypeInteger:
                if (param == LTTLampSwitch || param == LTTLampMatte) {
                    filter.type = LTTFilterTypeEnum;
                }
                else {
                    filter.type = LTTFilterTypeNumeric;
                }
                break;
                
            case LTTLampParameterTypeBool:
                filter.type = LTTFilterTypeBool;
                break;
                
            case LTTLampParameterTypeDate:
                filter.type = LTTFilterTypeUnknown; //TODO: придумать
                break;
        }
        
        if (filter.type == LTTFilterTypeEnum) {
            filter.enumOptions = [self enumOptionsForFilter:filter];
        }
        
        [filters addObject:filter];
    }
    
    self.filters = filters;
}

- (NSSet *)enumOptionsForFilter:(LTTFilter *)filter
{
    NSMutableSet *set = [NSMutableSet new];
    
    RLMResults *rlts = [LTTLamp allObjects];
    for (LTTLamp *lamp in rlts) {
        [set addObject:[lamp valueOfParameter:filter.param]];
    }
    
    return set;
}

#pragma mark - Filter activation and deactivation
- (void)updatePools
{
    NSMutableArray *activeFilters = [NSMutableArray new];
    NSMutableArray *filtersPool = [NSMutableArray new];
    NSMutableString *predicateString = [NSMutableString new];
    
    for (LTTFilter *filter in self.filters) {
        if (filter.isActive) {
            [activeFilters addObject:filter];
            
            if (predicateString.length == 0) {
                [predicateString appendString:filter.predicateString];
            }
            else {
                [predicateString appendFormat:@" AND %@", filter.predicateString];
            }
        }
        else {
            [filtersPool addObject:filter];
        }
    }
    
    NSComparisonResult (^comparator)(LTTFilter *_Nonnull obj1, LTTFilter *_Nonnull obj2) = ^NSComparisonResult(LTTFilter *_Nonnull obj1, LTTFilter *_Nonnull obj2) {
        return (obj1.sortOrder > obj2.sortOrder) ? NSOrderedDescending : NSOrderedAscending;
    };
    
    [activeFilters sortUsingComparator:comparator];
    [filtersPool sortUsingComparator:comparator];
    
    self.activeFilters = [activeFilters copy];
    self.filtersPool = [filtersPool copy];
    self.predicateString = predicateString;
}

- (void)activateFilterBool:(LTTFilter *)filter
{
    if (filter.isActive) {
        return;
    }
    else {
        filter.active = YES;
        [self updatePools];
    }
}

- (void)activateFilter:(LTTFilter *)filter string:(NSString *)string;
{
    if (string.length > 0) {
        filter.active = YES;
        filter.stringValue = string;
        [self updatePools];
    }
}

- (void)activateFilter:(LTTFilter *)filter minValue:(float)minValue maxValue:(float)maxValue
{
    filter.active = YES;
    filter.minValue = minValue;
    filter.maxValue = maxValue;
    
    [self updatePools];
}
- (void)activateFilter:(LTTFilter *)filter enumString:(NSString *)enumString
{
    if (enumString.length > 0) {
        filter.active = YES;
        filter.stringValue = enumString;
        [self updatePools];
    }
}

- (void)dropFilter:(LTTFilter *)filter
{
    if (filter.isActive) {
        filter.active = NO;
        filter.stringValue = nil;
        filter.minValue = LTTFilterNumericParamOff;
        filter.maxValue = LTTFilterNumericParamOff;
        
        [self updatePools];
    }
}

@end
