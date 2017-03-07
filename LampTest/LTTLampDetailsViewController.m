//
//  LTTLampDetailsViewController.m
//  LampTest
//
//  Created by Garafutdinov Ravil on 05/03/2017.
//  Copyright © 2017 VMB. All rights reserved.
//

#import "LTTLamp.h"
#import "LTTLampDetailsViewController.h"
#import "LTTLampDetailsTVC.h"
#import "LTTImageViewController.h"

@interface LTTLampDetailsViewController ()

@property (nonatomic, strong) LTTLampDetailsTVC *tableViewController;

@property (nonatomic, strong) NSString *currentImagePath;

@end

@implementation LTTLampDetailsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = self.lamp.model;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"LampDetailsEmbedTVC"]) {
        self.tableViewController = segue.destinationViewController;
        self.tableViewController.lamp = self.lamp;
        
        @weakify(self);
        self.tableViewController.onImageSelected = ^(NSString *imagePath) {
            @strongify(self);
            self.currentImagePath = imagePath;
            [self performSegueWithIdentifier:@"DetailsToImageSegue" sender:self];
        };
    }
    else if ([segue.identifier isEqualToString:@"DetailsToImageSegue"]) {
        LTTImageViewController *imageViewController = segue.destinationViewController;
        imageViewController.imagePath = self.currentImagePath;
    }
}

@end
