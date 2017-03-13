//
//  LTTFiltersViewController.m
//  LampTest
//
//  Created by Garafutdinov Ravil on 08/03/2017.
//  Copyright © 2017 VMB. All rights reserved.
//

#import "LTTFiltersViewController.h"
#import "LTTFiltersTVC.h"
#import "LTTMainAssembly.h"
#import "LTTFilterStringViewController.h"
#import "LTTFilterNumericViewController.h"

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
    }
    else if ([segue.identifier isEqualToString:@"FilterListToStringFilter"]) {
        LTTFilterStringViewController *filterStringViewController = segue.destinationViewController;
        filterStringViewController.filter = self.currentFilter;
        filterStringViewController.filterManager = self.filterManager;
    }
    else if ([segue.identifier isEqualToString:@"FilterListToNumericFilter"]) {
        LTTFilterNumericViewController *filterNumeric = segue.destinationViewController;
        filterNumeric.filter = self.currentFilter;
        filterNumeric.filterManager = self.filterManager;
    }
}

@end
