//
//  LTTFilterManager.m
//  LampTest
//
//  Created by Garafutdinov Ravil on 09/03/2017.
//  Copyright © 2017 VMB. All rights reserved.
//

#import "LTTFilterManager.h"
#import "LTTFilter.h"
#import "LTTLamp.h"

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
              @(LTTLampBrand),
              @(LTTLampModel),
              @(LTTLampBase),
              @(LTTLampShape),
              @(LTTLampType),
              @(LTTLampSubtype),
              @(LTTLampMatte),
              @(LTTLampNominalPower),
              @(LTTLampNominalBrightness),
              @(LTTLampNominalPowerEquivalent),
              @(LTTLampNominalColor),
              @(LTTLampDurability),
              @(LTTLampPower),
              @(LTTLampBrightness),
              @(LTTLampEffectivity),
              @(LTTLampPowerEquivalent),
              @(LTTLampColor),
              @(LTTLampNominalCRI),
              @(LTTLampCRI),
              @(LTTLampAngle),
              @(LTTLampPulsation),
              @(LTTLampSwitch),
              @(LTTLampDimmer),
              @(LTTLampDiameter),
              @(LTTLampHeight),
              @(LTTLampVoltage),
              @(LTTLampVoltageMin),
              @(LTTLampPriceRub),
              @(LTTLampPriceUsd),
              @(LTTLampActual),
              @(LTTLampRating)
        ];
        
        _filters = [self populateFilters];
        [self updatePools];
    }
    return self;
}

- (NSArray *)populateFilters
{
    NSMutableArray *filters = [NSMutableArray arrayWithCapacity:self.filterParams.count];
    
    for (NSInteger i=0; i < self.filterParams.count; i++) {
        LTTParserNamesToProperties param = [self.filterParams[i] integerValue];
        LTTLampParameterTypes paramType = [LTTLamp typeOfParameter:param];
        
        LTTFilter *filter = [LTTFilter new];
        filter.param = param;
        filter.active = NO;
        filter.sortOrder = i;
        
        switch (paramType) {
            case LTTLampParameterTypeUnknown:
                filter.type = LTTFilterTypeUnknown;
                break;
                
            case LTTLampParameterTypeString:
                if (param == LTTLampModel) {
                    filter.type = LTTFilterTypeString;
                }
                else {
                    filter.type =LTTFilterTypeEnum;
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
        
        [filters addObject:filter];
    }
    
    return filters;
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
        return (obj1.sortOrder > obj2.sortOrder) ? NSOrderedAscending : NSOrderedDescending;
    };
    
    [activeFilters sortUsingComparator:comparator];
    [filtersPool sortUsingComparator:comparator];
    
    self.activeFilters = [activeFilters copy];
    self.filtersPool = [filtersPool copy];
    self.predicateString = predicateString;
}

- (void)activateFilterBool:(LTTParserNamesToProperties)param
{
    BOOL found = NO;
    
    for (LTTFilter *filter in self.filters) {
        if (filter.param == param) {
            if (filter.isActive) {
                return;
            }
            else {
                filter.active = YES;
                found = YES;
                break;
            }
        }
    }
    
    if (found) {
        [self updatePools];
    }
}

- (void)dropFilter:(LTTParserNamesToProperties)param
{
    BOOL found = NO;
    
    for (LTTFilter *filter in self.filters) {
        if (filter.param == param) {
            if (filter.isActive) {
                filter.active = NO;
                filter.filterStringValue = nil;
                filter.filterStartValue = -1;
                filter.filterEndValue = -1;
                found = YES;
                break;
            }
            else {
                return;
            }
        }
    }
    
    if (found) {
        [self updatePools];
    }
}

@end
