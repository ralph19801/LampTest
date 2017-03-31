//
//  LTTParser.h
//  LampTest
//
//  Created by Garafutdinov Ravil on 23/02/2017.
//  Copyright © 2017 LampTest. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LTTParser : NSObject

- (void)parse:(void (^)(NSArray *results))completion;

@end
