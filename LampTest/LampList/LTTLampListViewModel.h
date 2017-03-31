//
//  LTTLampListViewModel.h
//  LampTest
//
//  Created by Garafutdinov Ravil on 24/02/2017.
//  Copyright © 2017 LampTest. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LTTLamp.h"

@class LTTFilterManager;

@interface LTTLampListViewModel : NSObject

@property (nonatomic, strong, readonly) RLMResults <LTTLamp *> *lamps;

- (instancetype)initWithFilterManager:(LTTFilterManager *)filterManager;

@end
