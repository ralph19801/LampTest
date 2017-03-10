//
//  LTTLampListViewModel.m
//  LampTest
//
//  Created by Garafutdinov Ravil on 24/02/2017.
//  Copyright © 2017 VMB. All rights reserved.
//

#import "LTTLampListViewModel.h"
#import "LTTFilterManager.h"

@interface LTTLampListViewModel()

@property (nonatomic, strong, readwrite) RLMResults <LTTLamp *> *lamps;
@property (nonatomic, strong) LTTFilterManager *filterManager;

@end

@implementation LTTLampListViewModel

- (instancetype)initWithFilterManager:(LTTFilterManager *)filterManager
{
    if (self = [super init])
    {
        _lamps = [[LTTLamp allObjects] sortedResultsUsingDescriptors:@[[RLMSortDescriptor sortDescriptorWithProperty:@"brand" ascending:YES],
                                                                       [RLMSortDescriptor sortDescriptorWithProperty:@"model" ascending:YES]]];
        
        _filterManager = filterManager;
        
        [self setupDependencies];
    }
    return self;
}

- (void)setupDependencies
{
    [RACObserve(self.filterManager, sort) subscribeNext:^(id x) {
        LTTSort sort = [x integerValue];
        
        switch (sort) {
            case LTTSortUnknown:
                break;
                
            case LTTSortBrandModel:
                self.lamps = [[LTTLamp allObjects] sortedResultsUsingDescriptors:@[[RLMSortDescriptor sortDescriptorWithProperty:@"brand" ascending:YES],
                                                                               [RLMSortDescriptor sortDescriptorWithProperty:@"model" ascending:YES]]];
                break;
                
            case LTTSortRating:
                self.lamps = [[LTTLamp allObjects] sortedResultsUsingDescriptors:@[[RLMSortDescriptor sortDescriptorWithProperty:@"rating" ascending:NO],
                                                                               [RLMSortDescriptor sortDescriptorWithProperty:@"brand" ascending:YES],
                                                                               [RLMSortDescriptor sortDescriptorWithProperty:@"model" ascending:YES]]];
                break;
        }
    }];
}

@end
