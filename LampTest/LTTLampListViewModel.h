//
//  LTTLampListViewModel.h
//  LampTest
//
//  Created by Garafutdinov Ravil on 24/02/2017.
//  Copyright © 2017 VMB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LTTLamp.h"

@interface LTTLampListViewModel : NSObject

@property (nonatomic, strong) RLMResults <LTTLamp *> *lamps;

@end
