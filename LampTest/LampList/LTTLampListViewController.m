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

@interface LTTLampListViewController ()

@property (nonatomic, strong) LTTLampListTVC *tableViewController;
@property (nonatomic, strong) LTTLampListViewModel *viewModel;
@property (nonatomic, weak) LTTLamp *selectedLamp;

@end

@implementation LTTLampListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [RACObserve(self.viewModel, lamps) subscribeNext:^(id x) {
        self.navigationItem.title = [NSString stringWithFormat:@"%i лампы", [x count]];
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"LampListEmbedTVC"])
    {
        self.viewModel = [[LTTLampListViewModel alloc] initWithFilterManager:
                          [[TyphoonComponentFactory defaultFactory] filterManager]];

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
