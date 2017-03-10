//
//  LTTMainAssembly.m
//  LampTest
//
//  Created by Garafutdinov Ravil on 09/03/2017.
//  Copyright © 2017 VMB. All rights reserved.
//

#import "LTTMainAssembly.h"
#import "LTTFilterManager.h"

@implementation LTTMainAssembly

- (LTTFilterManager *)filterManager
{
    return [TyphoonDefinition withClass:[LTTFilterManager class]
                          configuration:^(TyphoonDefinition *definition) {
        definition.scope = TyphoonScopeLazySingleton;
    }];
}

@end
