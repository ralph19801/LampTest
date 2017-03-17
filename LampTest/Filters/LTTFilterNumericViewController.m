//
//  LTTFilterNumericViewController.m
//  LampTest
//
//  Created by Garafutdinov Ravil on 12/03/2017.
//  Copyright © 2017 VMB. All rights reserved.
//

#import "LTTFilterNumericViewController.h"
#import <TTRangeSlider/TTRangeSlider.h>
#import "UIColor+LTTColors.h"
#import "LTTLamp.h"
#import "LTTFilter.h"
#import "LTTFilterManager.h"
#import <Realm/Realm.h>
#import "UIViewController+LTTMultilineTitle.h"

@interface LTTFilterNumericViewController () <TTRangeSliderDelegate, UITextFieldDelegate>

@property (nonatomic, strong) NSNumberFormatter *formatter;
@property (nonatomic, strong) NSNumberFormatter *comparingFormatter;
@property (nonatomic, assign) float globalMinValue;
@property (nonatomic, assign) float globalMaxValue;

@property (nonatomic, strong) IBOutlet TTRangeSlider *slider;
@property (nonatomic, strong) IBOutlet UITextField *minField;
@property (nonatomic, strong) IBOutlet UITextField *maxField;

@end

@implementation LTTFilterNumericViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self ltt_setupTitle:[LTTLamp nameForParameter:self.filter.param]];
    
    NSString *propertyName = [LTTLamp propertyForParameter:self.filter.param];
    RLMResults *allObjects = [LTTLamp allObjects];
    self.globalMinValue = [[allObjects minOfProperty:propertyName] floatValue];
    self.globalMaxValue = [[allObjects maxOfProperty:propertyName] floatValue];
    
    self.minField.delegate = self;
    self.maxField.delegate = self;
    
    self.slider.delegate = self;
    self.slider.minValue = self.globalMinValue;
    self.slider.maxValue = self.globalMaxValue;
    
    self.slider.handleColor = [UIColor ltt_orangeColor];
    self.slider.tintColorBetweenHandles = [UIColor ltt_orangeColor];
    self.slider.tintColor = [UIColor ltt_secondRowColor];
    
    self.slider.maxLabelColour = self.slider.minLabelColour = [UIColor blackColor];
    
    self.comparingFormatter = [[NSNumberFormatter alloc] init];
    self.comparingFormatter.numberStyle = kCFNumberFormatterDecimalStyle;
    
    self.formatter = [self.comparingFormatter copy];
    self.formatter.maximumFractionDigits = 1;
    self.formatter.usesGroupingSeparator = NO;
    self.formatter.minimum = @(self.globalMinValue);
    self.formatter.maximum = @(self.globalMaxValue);
    
    self.slider.numberFormatterOverride = self.formatter;
    
    [self updateMinValue:(self.filter.minValue == LTTFilterNumericParamOff) ? self.globalMinValue : self.filter.minValue];
    [self updateMaxValue:(self.filter.maxValue == LTTFilterNumericParamOff) ? self.globalMaxValue : self.filter.maxValue];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (self.slider.selectedMinimum != self.slider.minValue || self.slider.selectedMaximum != self.slider.maxValue) {
        [self.filterManager activateFilter:self.filter minValue:self.slider.selectedMinimum maxValue:self.slider.selectedMaximum];
    }
}

#pragma mark - Updating min-max
- (void)updateMinValue:(float)newMinValue
{
    self.slider.selectedMinimum = newMinValue;
    self.minField.text = [self.formatter stringFromNumber:@(newMinValue)];
}

- (void)updateMaxValue:(float)newMaxValue
{
    self.slider.selectedMaximum= newMaxValue;
    self.maxField.text = [self.formatter stringFromNumber:@(newMaxValue)];
}

#pragma mark - TTRangeSliderDelegate
- (void)rangeSlider:(TTRangeSlider *)sender didChangeSelectedMinimumValue:(float)selectedMinimum andMaximumValue:(float)selectedMaximum
{
    self.minField.text = [self.formatter stringFromNumber:@(selectedMinimum)];
    self.maxField.text = [self.formatter stringFromNumber:@(selectedMaximum)];
}

#pragma mark - UITextFieldDelegate
- (IBAction)onEditingEnded:(UITextField *)sender
{
    float minValue = [[self.comparingFormatter numberFromString:self.minField.text] floatValue];
    float maxValue = [[self.comparingFormatter numberFromString:self.maxField.text] floatValue];
    
    if ([sender isEqual:self.minField]) {
        if (minValue < self.globalMinValue) {
            [self updateMinValue:self.globalMinValue];
        }
        else if (minValue > maxValue) {
            self.minField.text = self.maxField.text;
            [self updateMinValue:[[self.formatter numberFromString:self.maxField.text] floatValue]];
        }
    }
    else if ([sender isEqual:self.maxField]) {
        if (maxValue > self.globalMaxValue) {
            [self updateMaxValue:self.globalMaxValue];
        }
        else if (maxValue < minValue) {
            [self updateMaxValue:[[self.formatter numberFromString:self.minField.text] floatValue]];
        }
    }
}

- (IBAction)onCancelTouch:(id)sender
{
    self.slider.selectedMinimum = self.slider.minValue;
    self.slider.selectedMaximum = self.slider.maxValue;
    
    [self.filterManager dropFilter:self.filter];
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
