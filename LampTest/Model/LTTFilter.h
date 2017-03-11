//
//  LTTFilter.h
//  LampTest
//
//  Created by Garafutdinov Ravil on 11/03/2017.
//  Copyright © 2017 VMB. All rights reserved.
//

#import "LTTParameterNamesEnum.h"
#import "LTTFilterTypesEnum.h"

@interface LTTFilter : NSObject

@property (nonatomic, assign) LTTParserNamesToProperties param;
@property (nonatomic, assign) LTTFilterType type;
@property (nonatomic, assign, getter = isActive) BOOL active;
@property (nonatomic, assign) NSInteger sortOrder;

@property (nonatomic, copy) NSString *filterStringValue;
@property (nonatomic, assign) double filterStartValue;
@property (nonatomic, assign) double filterEndValue;

@property (nonatomic, copy, readonly) NSString *predicateString;

@end
