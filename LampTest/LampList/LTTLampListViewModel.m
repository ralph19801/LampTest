//
//  LTTLampListViewModel.m
//  LampTest
//
//  Created by Garafutdinov Ravil on 24/02/2017.
//  Copyright © 2017 VMB. All rights reserved.
//

#import "LTTLampListViewModel.h"

@implementation LTTLampListViewModel

- (instancetype)init
{
    if (self = [super init])
    {
        _lamps = [[LTTLamp allObjects] sortedResultsUsingDescriptors:@[[RLMSortDescriptor sortDescriptorWithProperty:@"brand" ascending:YES],
                                                                       [RLMSortDescriptor sortDescriptorWithProperty:@"model" ascending:YES]]];
    }
    return self;
}

@end
