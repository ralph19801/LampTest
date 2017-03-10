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

@interface LTTFiltersViewController ()

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
        
        self.tableViewController.filterManager = [[TyphoonComponentFactory defaultFactory] filterManager];
    }
}

@end
