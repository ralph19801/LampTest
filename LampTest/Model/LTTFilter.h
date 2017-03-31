//
//  LTTFilter.h
//  LampTest
//
//  Created by Garafutdinov Ravil on 11/03/2017.
//  Copyright © 2017 LampTest. All rights reserved.
//

#import "LTTParameterNamesEnum.h"
#import "LTTFilterTypesEnum.h"

@interface LTTFilter : NSObject

@property (nonatomic, assign) LTTParserNamesToProperties param;
@property (nonatomic, assign) LTTFilterType type;
@property (nonatomic, assign, getter = isActive) BOOL active;
@property (nonatomic, assign) NSInteger sortOrder;
@property (nonatomic, copy) NSSet *enumOptions;

@property (nonatomic, copy) NSString *stringValue;
@property (nonatomic, assign) double minValue;
@property (nonatomic, assign) double maxValue;

@property (nonatomic, copy, readonly) NSString *predicateString;

@end
