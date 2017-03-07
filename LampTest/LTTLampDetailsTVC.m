//
//  LTTLampDetailsTVC.m
//  LampTest
//
//  Created by Garafutdinov Ravil on 05/03/2017.
//  Copyright © 2017 VMB. All rights reserved.
//

#import "LTTLampDetailsTVC.h"
#import "LTTParameterNamesEnum.h"
#import "LTTLampDetailsParameterTVCell.h"
#import "LTTLamp.h"

static NSString *const LTTLampDetailsTVCOneStringParameterCell = @"OneStringParameter";
static NSString *const LTTLampDetailsTVCLongStringParameterCell = @"LongStringParameter";
static NSString *const LTTLampDetailsTVCImagesParameterCell = @"ImagesParameter";

static NSInteger const LTTLampImagesCell = -1;

@interface LTTLampDetailsTVC ()

@property (nonatomic, strong) NSArray *rows;
@property (nonatomic, strong) NSDictionary *rowNames;

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
                  @(LTTLampEffectivity), // нет в CSV
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
    
    
    self.rowNames = @{
                  @(LTTLampBrand) : @"изготовитель",
                  @(LTTLampModel) : @"модель или артикул",
                  @(LTTLampCode) : @"штрихкод",
                  @(LTTLampBase) : @"тип цоколя",
                  @(LTTLampShape) : @"вид",
                  @(LTTLampType) : @"тип",
                  @(LTTLampSubtype) : @"подтип",
                  @(LTTLampMatte) : @"матовость",
                  @(LTTLampNominalPower) : @"заявленная мощность, Вт",
                  @(LTTLampNominalBrightness) : @"заявленный световой поток, Лм",
                  @(LTTLampNominalPowerEquivalent) : @"заявленный эквивалент, Вт",
                  @(LTTLampNominalColor) : @"заявленная цветовая температура, К",
                  @(LTTLampDurability) : @"заявленный срок службы, час",
                  @(LTTLampPower) : @"измеренная мощность, Вт",
                  @(LTTLampBrightness) : @"измеренный световой поток, Лм",
                  @(LTTLampEffectivity) : @"эффективность (количество люмен на ватт)", // нет в CSV
                  @(LTTLampPowerEquivalent) : @"измеренный эквивалент мощности, Вт",
                  @(LTTLampColor) : @"измеренная цветовая температура, К",
                  @(LTTLampNominalCRI) : @"заявленный CRI, не менее",
                  @(LTTLampCRI) : @"измеренный индекс цветопередачи (CRI)",
                  @(LTTLampAngle) : @"измеренный угол освещения, град.",
                  @(LTTLampPulsation) : @"измеренный коэффициент пульсации, %",
                  @(LTTLampSwitch) : @"работа с выключателем, имеющим индикатор",
                  @(LTTLampDimmer) : @"диммирование",
                  @(LTTLampDiameter) : @"диаметр лампы, мм",
                  @(LTTLampHeight) : @"высота лампы, мм",
                  @(LTTLampVoltage) : @"заявленное рабочее напряжение, В",
                  @(LTTLampVoltageMin) : @"измеренное минимальное напряжение, В",
                  @(LTTLampPriceRub) : @"цена в рублях",
                  @(LTTLampPriceUsd) : @"цена в долларах",
                  @(LTTLampMade) : @"дата изготовления лампы",
                  @(LTTLampDate) : @"дата тестирования",
                  @(LTTLampActual) : @"актуальность лампы",
                  @(LTTLampRating) : @"общая оценка параметров лампы",
/*
                  @(LTTLampWarranty) : @"",
                  @(LTTLampR9) : @"",
                  @(LTTLampPF) : @"",*/
    };
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
        cell.contentView.backgroundColor = [UIColor colorWithWhite:240.f/255.f alpha:1.f];
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
    NSString *paramName = self.rowNames[@(param)];
    LTTLampParameterTypes paramType = [self.lamp typeOfParameter:param];
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
    
    if (param == LTTLampMatte) {
        // развернуть enum
    }
    else if (param == LTTLampSwitch) {
        // развернуть enum
    }
    
    UIColor *valueColor = [UIColor blackColor];
    if (paramType == LTTLampParameterTypeString && [paramValue isKindOfClass:[NSString class]]) {
        if ([paramValue length] == 0) {
            paramValue = @"Н/д";
            valueColor = [UIColor grayColor];
        }
    }
    else if ((paramType == LTTLampParameterTypeDouble || paramType == LTTLampParameterTypeInteger) && [paramValue isKindOfClass:[NSNumber class]]) {
        if ([paramValue isEqual:@0]) {
            paramType = LTTLampParameterTypeString;
            paramValue = @"Н/д";
            valueColor = [UIColor grayColor];
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

- (NSString *)baseModel  // "GE Classic C35/40W-F-SES-284251" -> "ge-classic-c35-40w-f-ses-284251"
{
    return [[[[NSString stringWithFormat:@"%@-%@", self.lamp.brand, self.lamp.model]
            componentsSeparatedByCharactersInSet:[[NSCharacterSet alphanumericCharacterSet] invertedSet]]
            componentsJoinedByString:@"-"]
            lowercaseString];
}

@end
