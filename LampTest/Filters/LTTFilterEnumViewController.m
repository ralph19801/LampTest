//
//  LTTFilterEnumViewController.m
//  LampTest
//
//  Created by Garafutdinov Ravil on 14/03/2017.
//  Copyright © 2017 VMB. All rights reserved.
//

#import "LTTFilterEnumViewController.h"
#import "LTTFilterEnumTVC.h"

#import "LTTFilterManager.h"
#import "LTTLamp.h"
#import "LTTFilter.h"
#import "UIViewController+LTTMultilineTitle.h"
#import "NSString+LTTCapitalize.h"

@interface LTTFilterEnumViewController ()

@property (nonatomic, strong) LTTFilterEnumTVC *tableViewController;

@end

@implementation LTTFilterEnumViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self ltt_setupTitle:[[LTTLamp nameForParameter:self.filter.param] sentenceCapitalizedString]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (self.tableViewController.selectedOptions.count > 0) {
        NSMutableArray *boxedOptions = [NSMutableArray new];
        for (NSString *option in self.tableViewController.selectedOptions.allObjects) {
            [boxedOptions addObject:[NSString stringWithFormat:@"'%@'", option]];
        }
        NSString *enumString = [boxedOptions componentsJoinedByString:@","];
        [self.filterManager activateFilter:self.filter enumString:enumString];
    }
    else {
        [self.filterManager dropFilter:self.filter];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"FilterEnumEmbedTVC"]) {
        self.tableViewController = segue.destinationViewController;
        
        self.tableViewController.filter = self.filter;
    }
}

- (IBAction)onCancelTouch:(id)sender
{
    [self.filterManager dropFilter:self.filter];
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
