//
//  LTTFilterManager.h
//  LampTest
//
//  Created by Garafutdinov Ravil on 09/03/2017.
//  Copyright © 2017 VMB. All rights reserved.
//

#import "LTTSortEnum.h"
#import "LTTParameterNamesEnum.h"

@class LTTFilter;

@interface LTTFilterManager : NSObject

@property (nonatomic, assign) LTTSort sort;
@property (nonatomic, strong, readonly) NSString *predicateString;

@property (nonatomic, strong, readonly) NSArray <LTTFilter *> *activeFilters;
@property (nonatomic, strong, readonly) NSArray <LTTFilter *> *filtersPool;

- (void)activateFilterBool:(LTTParserNamesToProperties)param;
- (void)activateFilter:(LTTFilter *)filter string:(NSString *)string;

- (void)dropFilter:(LTTFilter *)filter;
- (void)dropFilterParam:(LTTParserNamesToProperties)param;

@end
