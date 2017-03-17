//
//  NSString+LTTCapitalize.m
//  LampTest
//
//  Created by Garafutdinov Ravil on 18/03/2017.
//  Copyright © 2017 VMB. All rights reserved.
//

#import "NSString+LTTCapitalize.h"

@implementation NSString (LTTCapitalize)

- (NSString *)sentenceCapitalizedString
{
    if (![self length]) {
        return [NSString string];
    }
    NSString *uppercase = [[self substringToIndex:1] uppercaseString];
    NSString *rest = [self substringFromIndex:1];
    return [uppercase stringByAppendingString:rest];
}

@end
