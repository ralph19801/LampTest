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

@interface LTTLampListViewController ()

@property (nonatomic, strong) LTTLampListTVC *tableViewController;
@property (nonatomic, strong) LTTLampListViewModel *viewModel;

@end

@implementation LTTLampListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"LampListEmbedTVC"])
    {
        self.viewModel = [[LTTLampListViewModel alloc] init];

        self.tableViewController = segue.destinationViewController;
        self.tableViewController.viewModel = self.viewModel;
    }
}

@end
