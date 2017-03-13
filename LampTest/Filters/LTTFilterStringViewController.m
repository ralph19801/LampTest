//
//  LTTFilterStringViewController.m
//  LampTest
//
//  Created by Garafutdinov Ravil on 12/03/2017.
//  Copyright © 2017 VMB. All rights reserved.
//

#import "LTTFilterStringViewController.h"
#import "LTTFilter.h"
#import "LTTLamp.h"
#import "LTTFilterManager.h"
#import "LTTMainAssembly.h"

@interface LTTFilterStringViewController ()

@property (nonatomic, strong) IBOutlet UILabel *filterNameLabel;
@property (nonatomic, strong) IBOutlet UITextField *searchTextField;

@end

@implementation LTTFilterStringViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.searchTextField becomeFirstResponder];
    
    self.filterNameLabel.text = [LTTLamp nameForParameter:self.filter.param];
    self.searchTextField.text = self.filter.stringValue;
}

- (IBAction)onTextChanged:(id)sender
{
    if ([sender isEqual:self.searchTextField]) {
        if (self.searchTextField.text.length > 0) {
            [self.filterManager activateFilter:self.filter string:self.searchTextField.text];
        }
        else {
            [self.filterManager dropFilter:self.filter];
        }
    }
}

- (IBAction)onCancelTouch:(id)sender
{
    [self.filterManager dropFilter:self.filter];
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
