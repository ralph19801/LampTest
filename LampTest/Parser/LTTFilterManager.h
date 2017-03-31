//
//  LTTFilterManager.h
//  LampTest
//
//  Created by Garafutdinov Ravil on 09/03/2017.
//  Copyright © 2017 LampTest. All rights reserved.
//

#import "LTTSortEnum.h"
#import "LTTParameterNamesEnum.h"

@class LTTFilter;

extern CGFloat const LTTFilterNumericParamOff;

@interface LTTFilterManager : NSObject

@property (nonatomic, assign) LTTSort sort;
@property (nonatomic, strong, readonly) NSString *predicateString;

@property (nonatomic, strong, readonly) NSArray <LTTFilter *> *activeFilters;
@property (nonatomic, strong, readonly) NSArray <LTTFilter *> *filtersPool;

- (void)populateFilters;

- (void)activateFilterBool:(LTTFilter *)filter;
- (void)activateFilter:(LTTFilter *)filter string:(NSString *)string;
- (void)activateFilter:(LTTFilter *)filter minValue:(float)minValue maxValue:(float)maxValue;
- (void)activateFilter:(LTTFilter *)filter enumString:(NSString *)enumString;

- (void)dropFilter:(LTTFilter *)filter;

@end
