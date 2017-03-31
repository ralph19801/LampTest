//
//  LTTLampDetailsTVC.m
//  LampTest
//
//  Created by Garafutdinov Ravil on 05/03/2017.
//  Copyright © 2017 LampTest. All rights reserved.
//

#import "LTTLampDetailsTVC.h"
#import "LTTParameterNamesEnum.h"
#import "LTTLampDetailsParameterTVCell.h"
#import "LTTLamp.h"
#import "UIColor+LTTColors.h"

static NSString *const LTTLampDetailsTVCOneStringParameterCell = @"OneStringParameter";
static NSString *const LTTLampDetailsTVCLongStringParameterCell = @"LongStringParameter";
static NSString *const LTTLampDetailsTVCImagesParameterCell = @"ImagesParameter";

static NSInteger const LTTLampImagesCell = -1;

@interface LTTLampDetailsTVC ()

@property (nonatomic, strong) NSArray *rows;

@end

@implementation LTTLampDetailsTVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.rows = @[
                  @(LTTLampImagesCell),
                  @(LTTLampBrand),
                  @(LTTLampModel),
                  @(LTTLampCode),
                  @(LTTLampBase),
                  @(LTTLampShape),
                  @(LTTLampType),
                  @(LTTLampSubtype),
                  @(LTTLampMatte),
                  @(LTTLampNominalPower),
                  @(LTTLampNominalBrightness),
                  @(LTTLampNominalPowerEquivalent),
                  @(LTTLampNominalColor),
                  @(LTTLampDurability),
                  @(LTTLampPower),
                  @(LTTLampBrightness),
                  @(LTTLampEffectivity),
                  @(LTTLampPowerEquivalent),
                  @(LTTLampColor),
                  @(LTTLampNominalCRI),
                  @(LTTLampCRI),
                  @(LTTLampAngle),
                  @(LTTLampPulsation),
                  @(LTTLampSwitch),
                  @(LTTLampDimmer),
                  @(LTTLampDiameter),
                  @(LTTLampHeight),
                  @(LTTLampVoltage),
                  @(LTTLampVoltageMin),
                  @(LTTLampPriceRub),
                  @(LTTLampPriceUsd),
                  @(LTTLampMade),
                  @(LTTLampDate),
                  @(LTTLampActual),
                  @(LTTLampRating),
/*
                  @(LTTLampWarranty),
                  @(LTTLampR9),
                  @(LTTLampPF),*/
                  ];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.rows count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LTTParserNamesToProperties param = [self.rows[indexPath.row] integerValue];
    
    LTTLampDetailsParameterTVCell *cell = nil;
    if (param == LTTLampImagesCell) {
        cell = [self imageCellWithParam:param tableView:tableView indexPath:indexPath];
    }
    else {
        cell = [self parameterCellWithParam:param tableView:tableView indexPath:indexPath];
    }

    // зёбра
    if (indexPath.row % 2) {
        cell.contentView.backgroundColor = [UIColor ltt_secondRowColor];
    }
    else {
        cell.contentView.backgroundColor = [UIColor whiteColor];
    }
    
    return cell;
}

- (LTTLampDetailsParameterTVCell *)imageCellWithParam:(LTTParserNamesToProperties)param tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    LTTLampDetailsParameterTVCell *cell = (LTTLampDetailsParameterTVCell *)[tableView dequeueReusableCellWithIdentifier:LTTLampDetailsTVCImagesParameterCell forIndexPath:indexPath];
    
    @weakify(self);
    cell.photoButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        SAFE_RUN(self.onImageSelected, [self pathToPhotos]);
        return [RACSignal empty];
    }];
    
    cell.graphButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        SAFE_RUN(self.onImageSelected, [self pathToGraph]);
        return [RACSignal empty];
    }];
    
    cell.colorButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        SAFE_RUN(self.onImageSelected, [self pathToColor]);
        return [RACSignal empty];
    }];

    return cell;
}

- (LTTLampDetailsParameterTVCell *)parameterCellWithParam:(LTTParserNamesToProperties)param tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    NSString *paramName = [LTTLamp nameForParameter:param];
    LTTLampParameterTypes paramType = [LTTLamp typeOfParameter:param];
    id paramValue = [self.lamp valueOfParameter:param];
    
    NSString *identifier = nil;
    if (param == LTTLampModel) {
        identifier = LTTLampDetailsTVCLongStringParameterCell;
    }
    else {
        identifier = LTTLampDetailsTVCOneStringParameterCell;
    }
    LTTLampDetailsParameterTVCell *cell = (LTTLampDetailsParameterTVCell *)[tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    [cell setParameterName:paramName];
    
    // пустые параметры
    UIColor *valueColor = [UIColor blackColor];
    if (paramType == LTTLampParameterTypeString && [paramValue isKindOfClass:[NSString class]]) {
        if ([paramValue length] == 0) {
            paramValue = @"н/д";
            valueColor = [UIColor grayColor];
        }
    }
    else if ((paramType == LTTLampParameterTypeDouble || paramType == LTTLampParameterTypeInteger) && [paramValue isKindOfClass:[NSNumber class]]) {
        if (param != LTTLampRating) {
            if ([paramValue isEqual:@0]) {
                paramType = LTTLampParameterTypeString;
                paramValue = @"н/д";
                valueColor = [UIColor grayColor];
            }
        }
    }
    [cell setParameterValue:paramValue type:paramType color:valueColor];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LTTParserNamesToProperties param = [self.rows[indexPath.row] integerValue];
    return (param == LTTLampModel || param == LTTLampImagesCell) ? 64.f : 52.f;
}

#pragma mark - Images
- (NSString *)pathToPhotos
{
    return [NSString stringWithFormat:@"http://lamptest.ru/images/photo/%@.jpg", [self baseModel]];
}

- (NSString *)pathToGraph
{
    return [NSString stringWithFormat:@"http://lamptest.ru/images/graph/%@.png", [self baseModel]];
}

- (NSString *)pathToColor
{
    return [NSString stringWithFormat:@"http://lamptest.ru/images/color-index/%@.png", [self baseModel]];
}

- (NSString *)baseModel  // "GE Classic (C35)/40.W-F-S.E.S-284251" -> "ge-classic-c35-40w-f-ses-284251"
{ // вт -> vt
    NSString *rawBrandModel = [NSString stringWithFormat:@"%@-%@", self.lamp.brand, self.lamp.model];
    NSString *strippedOfPunctuation = [[rawBrandModel componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@".,:;'()"]] componentsJoinedByString:@""];
    NSString *replacedWithHyphen = [[[strippedOfPunctuation componentsSeparatedByCharactersInSet:[[NSCharacterSet alphanumericCharacterSet] invertedSet]] componentsJoinedByString:@"-"]
               lowercaseString];
    
    // транслитерация
    NSMutableString *buffer = [replacedWithHyphen mutableCopy];
    CFMutableStringRef bufferRef = (__bridge CFMutableStringRef)buffer;
    CFStringTransform(bufferRef, NULL, kCFStringTransformToLatin, false);
    CFStringTransform(bufferRef, NULL, kCFStringTransformStripDiacritics, false);
    
    return buffer;
}

@end
