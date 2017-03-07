//
//  LTTImageViewController.m
//  LampTest
//
//  Created by Garafutdinov Ravil on 07/03/2017.
//  Copyright © 2017 VMB. All rights reserved.
//

#import "LTTImageViewController.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface LTTImageViewController ()

@property (nonatomic, strong) IBOutlet UIImageView *imageView;

@end

@implementation LTTImageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.imageView setImageWithURL:[NSURL URLWithString:self.imagePath]];
}

- (IBAction)onCloseTouch:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
