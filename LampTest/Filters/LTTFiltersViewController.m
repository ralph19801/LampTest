//
//  LTTFiltersViewController.m
//  LampTest
//
//  Created by Garafutdinov Ravil on 08/03/2017.
//  Copyright © 2017 LampTest. All rights reserved.
//

#import "LTTFiltersViewController.h"
#import "LTTMainAssembly.h"
#import "LTTFilter.h"

#import "LTTFiltersTVC.h"
#import "LTTFilterStringViewController.h"
#import "LTTFilterNumericViewController.h"
#import "LTTFilterEnumViewController.h"

@interface LTTFiltersViewController ()

@property (nonatomic, strong) LTTFilter *currentFilter;
@property (nonatomic, strong) LTTFilterManager *filterManager;
@property (nonatomic, strong) LTTFiltersTVC *tableViewController;

@end

@implementation LTTFiltersViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"FilterListEmbedTVC"]) {
        self.tableViewController = segue.destinationViewController;
        
        self.filterManager = [[TyphoonComponentFactory defaultFactory] filterManager];
        self.tableViewController.filterManager = self.filterManager;
        
        @weakify(self);
        self.tableViewController.onStringFilterSelected = ^(LTTFilter *filter) {
            @strongify(self);
            self.currentFilter = filter;
            [self performSegueWithIdentifier:@"FilterListToStringFilter" sender:self];
        };
        
        self.tableViewController.onNumericFilterSelected = ^(LTTFilter *filter) {
            @strongify(self);
            self.currentFilter = filter;
            [self performSegueWithIdentifier:@"FilterListToNumericFilter" sender:self];
        };
        
        self.tableViewController.onEnumFilterSelected = ^(LTTFilter *filter) {
            @strongify(self);
            self.currentFilter = filter;
            [self performSegueWithIdentifier:@"FilterListToEnumFilter" sender:self];
        };
    }
    else if ([segue.identifier isEqualToString:@"FilterListToStringFilter"]) {
        LTTFilterStringViewController *filterString = segue.destinationViewController;
        filterString.filter = self.currentFilter;
        filterString.filterManager = self.filterManager;
    }
    else if ([segue.identifier isEqualToString:@"FilterListToNumericFilter"]) {
        LTTFilterNumericViewController *filterNumeric = segue.destinationViewController;
        filterNumeric.filter = self.currentFilter;
        filterNumeric.filterManager = self.filterManager;
    }
    else if ([segue.identifier isEqualToString:@"FilterListToEnumFilter"]) {
        LTTFilterEnumViewController *filterEnum = segue.destinationViewController;
        filterEnum.filter = self.currentFilter;
        filterEnum.filterManager = self.filterManager;
    }
}

@end
