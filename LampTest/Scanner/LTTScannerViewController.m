//
//  LTTScannerViewController.m
//  LampTest
//
//  Created by Garafutdinov Ravil on 24/02/2017.
//  Copyright © 2017 LampTest. All rights reserved.
//

#import "LTTScannerViewController.h"
#import <MTBBarcodeScanner/MTBBarcodeScanner.h>
#import "LTTLamp.h"
#import "LTTLampDetailsViewController.h"

@interface LTTScannerViewController ()

@property (nonatomic, strong) IBOutlet UIView *forbiddenView;
@property (nonatomic, strong) IBOutlet UIView *codeNotFoundView;
@property (nonatomic, strong) IBOutlet UILabel *codeNotFoundLabel;

@property (nonatomic, strong) IBOutlet UIView *scannerView;
@property (nonatomic, strong) MTBBarcodeScanner *scanner;

@property (nonatomic, strong) LTTLamp *currentLamp;

@end

@implementation LTTScannerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.scanner = [[MTBBarcodeScanner alloc] initWithPreviewView:self.scannerView];
    
    if ( ! [MTBBarcodeScanner cameraIsPresent] || [MTBBarcodeScanner scanningIsProhibited]) {
        self.codeNotFoundView.hidden = YES;
        self.forbiddenView.hidden = NO;
    }
    else {
        [self onScanTouch:nil];
    }
}

- (IBAction)onSettingsTouch:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
}

- (IBAction)onScanTouch:(id)sender
{
    self.codeNotFoundView.hidden = YES;
    self.forbiddenView.hidden = YES;
 
    @weakify(self);
    [MTBBarcodeScanner requestCameraPermissionWithSuccess:^(BOOL success) {
        if (success) {
            NSError *error = nil;
            [self.scanner startScanningWithResultBlock:^(NSArray *codes) {
                @strongify(self);
                AVMetadataMachineReadableCodeObject *code = [codes firstObject];
                NSLog(@"Found code: %@", code.stringValue);
                
                [self.scanner stopScanning];
                
                RLMResults *lampArray = [LTTLamp objectsWhere:[NSString stringWithFormat:@"code = '%@'", code.stringValue]];
                if (lampArray.count > 0) {
                    self.currentLamp = lampArray.firstObject;
                    [self performSegueWithIdentifier:@"ScannerToLampDetails" sender:self];
                }
                else {
                    self.codeNotFoundLabel.text = [NSString stringWithFormat:@"Код\n%@\nне найден в базе.", code.stringValue];
                    self.codeNotFoundView.hidden = NO;
                    self.forbiddenView.hidden = YES;
                }
                
            } error:&error];
        }
        else {
            // The user denied access to the camera
            @strongify(self);
            self.forbiddenView.hidden = NO;
        }
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ScannerToLampDetails"]) {
        LTTLampDetailsViewController *lampDetails = segue.destinationViewController;
        lampDetails.lamp = self.currentLamp;
    }
}

@end
