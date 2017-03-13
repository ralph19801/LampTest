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
    [[RACSignal combineLatest:@[RACObserve(self.filterManager, sort),
                                RACObserve(self.filterManager, predicateString)]]
     subscribeNext:^(RACTuple *tuple) {
         
         LTTSort sort = [tuple.first integerValue];
         NSString *predicateString = tuple.second;
        
         RLMResults *lamps = nil;
         if (predicateString.length > 0) {
             lamps = [LTTLamp objectsWhere:predicateString];
         }
         else {
             lamps = [LTTLamp allObjects];
         }
         
         switch (sort) {
             case LTTSortUnknown:
                 break;
                 
             case LTTSortModel:
                 self.lamps = [lamps sortedResultsUsingDescriptors:@[[RLMSortDescriptor sortDescriptorWithProperty:@"model" ascending:YES]]];
                 break;
                 
             case LTTSortBrandModel:
                 self.lamps = [lamps sortedResultsUsingDescriptors:@[[RLMSortDescriptor sortDescriptorWithProperty:@"brand" ascending:YES],
                                                                     [RLMSortDescriptor sortDescriptorWithProperty:@"model" ascending:YES]]];
                 break;
                
             case LTTSortRating:
                 self.lamps = [lamps sortedResultsUsingDescriptors:@[[RLMSortDescriptor sortDescriptorWithProperty:@"rating" ascending:NO],
                                                                                    [RLMSortDescriptor sortDescriptorWithProperty:@"brand" ascending:YES],
                                                                                    [RLMSortDescriptor sortDescriptorWithProperty:@"model" ascending:YES]]];
                 break;
         }
     }];
}

@end
