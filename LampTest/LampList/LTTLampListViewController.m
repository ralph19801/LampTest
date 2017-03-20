//
//  LTTLampListViewController.m
//  LampTest
//
//  Created by Garafutdinov Ravil on 24/02/2017.
//  Copyright © 2017 VMB. All rights reserved.
//

#import "LTTLampListViewController.h"
#import "LTTLampListTVC.h"
#import "LTTLampListViewModel.h"
#import "LTTLampDetailsViewController.h"
#import "LTTFilterManager.h"
#import "LTTMainAssembly.h"
#import "UIBarButtonItem+Badge.h"

@interface LTTLampListViewController ()

@property (nonatomic, strong) LTTLampListTVC *tableViewController;
@property (nonatomic, strong) LTTLampListViewModel *viewModel;
@property (nonatomic, strong) LTTLamp *selectedLamp;
@property (nonatomic, strong) LTTFilterManager *filterManager;

@end

@implementation LTTLampListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem.shouldAnimateBadge = YES;
    
    [RACObserve(self.viewModel, lamps) subscribeNext:^(id x) {
        self.navigationItem.title = [NSString stringWithFormat:@"%lu лампы", (unsigned long)[x count]];
    }];

    [RACObserve(self.filterManager, activeFilters) subscribeNext:^(NSArray *x) {
        self.navigationItem.rightBarButtonItem.badgeValue = [NSString stringWithFormat:@"%lu", (unsigned long)x.count];
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"LampListEmbedTVC"])
    {
        self.filterManager = [[TyphoonComponentFactory defaultFactory] filterManager];
        self.viewModel = [[LTTLampListViewModel alloc] initWithFilterManager:self.filterManager];

        self.tableViewController = segue.destinationViewController;
        self.tableViewController.viewModel = self.viewModel;
        
        @weakify(self);
        self.tableViewController.onRowSelected = ^(NSInteger rowIndex) {
            @strongify(self);
            if (rowIndex >= 0 && rowIndex < self.viewModel.lamps.count) {
                self.selectedLamp = self.viewModel.lamps[rowIndex];
                [self performSegueWithIdentifier:@"ListToItemSegue" sender:self];
            }
        };
    }
    else if ([segue.identifier isEqualToString:@"ListToItemSegue"]) {
        LTTLampDetailsViewController *detailsViewController = segue.destinationViewController;
        detailsViewController.lamp = self.selectedLamp;
    }
}

@end
