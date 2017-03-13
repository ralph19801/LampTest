//
//  LTTFiltersTVC.m
//  LampTest
//
//  Created by Garafutdinov Ravil on 08/03/2017.
//  Copyright © 2017 VMB. All rights reserved.
//

#import "LTTFiltersTVC.h"
#import "LTTFilterManager.h"
#import "LTTFilter.h"

#import "LTTFilterTVCell.h"
#import "LTTSortEnum.h"
#import "LTTLampDetailsParameterTVCell.h"

static NSString *const LTTFiltersUnsupportedCell = @"LTTFilterUnsupported";
static NSString *const LTTFiltersSortOnCell = @"LTTSortOn";
static NSString *const LTTFiltersSortOffCell = @"LTTSortOff";
static NSString *const LTTFiltersBoolOnCell = @"LTTFilterBoolOn";
static NSString *const LTTFiltersBoolOffCell = @"LTTFilterBoolOff";
static NSString *const LTTFiltersSNEOnCell = @"LTTFilterSNEOn"; // String, Numeric, Enum
static NSString *const LTTFiltersSNEOffCell = @"LTTFilterSNEOff";

typedef NS_ENUM(NSUInteger, LTTFiltersSection) {
    LTTFiltersSectionUnknown = -1,
    LTTFiltersSectionSort = 0,
    LTTFiltersSectionActive = 1,
    LTTFiltersSectionPool
};

@interface LTTFiltersTVC ()

@property (nonatomic, strong) NSArray *sorts;
@property (nonatomic, strong) NSArray *rows;

@end

@implementation LTTFiltersTVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.sorts = @[
                   @(LTTSortModel),
                   @(LTTSortBrandModel),
                   @(LTTSortRating)
                  ];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
    [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger count = 1;
    
    if (self.filterManager.activeFilters.count > 0) {
        count++;
    }
    if (self.filterManager.filtersPool.count > 0) {
        count++;
    }
    
    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.sorts.count;
    }
    else if (section == 1) {
        if (self.filterManager.activeFilters.count > 0) {
            return self.filterManager.activeFilters.count;
        }
        else if (self.filterManager.filtersPool.count > 0) {
            return self.filterManager.filtersPool.count;
        }
    }
    else if (section == 2) {
        if (self.filterManager.filtersPool.count > 0) {
            return self.filterManager.filtersPool.count;
        }
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 52.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section <= 1) {
        return 34.f;
    }
    
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"Сортировка";
    }
    else if (section == 1) {
        return @"Фильтры";
    }
    
    return @"";
}

#pragma mark - Cell creation
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        LTTSort sort = [self.sorts[indexPath.row] integerValue];
        return [self sortCellForSort:sort tableView:tableView indexPath:indexPath];
    }
    else {
        return [self filterCellForTableView:tableView indexPath:indexPath];
    }
}

- (UITableViewCell *)sortCellForSort:(LTTSort)sort tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = nil;
    if (self.filterManager.sort == sort) {
        identifier = LTTFiltersSortOnCell;
    }
    else {
        identifier = LTTFiltersSortOffCell;
    }
    
    LTTFilterTVCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.sort = sort;

    return cell;
}

- (UITableViewCell *)filterCellForTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    LTTFilter *filter = nil;
    if (indexPath.section == 1 && self.filterManager.activeFilters.count > 0) {
        filter = self.filterManager.activeFilters[indexPath.row];
    }
    else {
        filter = self.filterManager.filtersPool[indexPath.row];
    }
    
    return [self cellForFilter:filter tableView:tableView indexPath:indexPath];
}

- (LTTFilterTVCell *)cellForFilter:(LTTFilter *)filter tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"LTTFilterTVCell";
    switch (filter.type) {
        case LTTFilterTypeUnknown:
            identifier = LTTFiltersUnsupportedCell;
            break;
            
        case LTTFilterTypeBool:
            identifier = (filter.isActive) ? LTTFiltersBoolOnCell : LTTFiltersBoolOffCell;
            break;
            
        case LTTFilterTypeString:
        case LTTFilterTypeNumeric:
            identifier = (filter.isActive) ? LTTFiltersSNEOnCell : LTTFiltersSNEOffCell;
            break;
    }
    
    LTTFilterTVCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.filter = filter;
    
    @weakify(self);
    cell.onDropFilter = ^(LTTFilter *filter) {
        @strongify(self);
        [self.filterManager dropFilter:filter];
        [self.tableView reloadData];
    };
    
    if ([identifier isEqualToString:@"LTTFilterTVCell"]) {
        switch (filter.type) {
            case LTTFilterTypeUnknown:
                cell.valueLabel.text = @"unknown";
                break;
                
            case LTTFilterTypeString:
                cell.valueLabel.text = @"string";
                break;
                
            case LTTFilterTypeEnum:
                cell.valueLabel.text = @"enum";
                break;
                
            case LTTFilterTypeBool:
                cell.valueLabel.text = @"bool";
                break;
                
            case LTTFilterTypeNumeric:
                cell.valueLabel.text = @"numeric";
                break;
        }
    }
    
    return cell;
}

#pragma mark - Selection
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == LTTFiltersSectionSort) {
        [self didSelectSortForTableView:tableView indexPath:indexPath];
    }
    else {
        [self didSelectFilterForTableView:tableView indexPath:indexPath];
    }
}

- (void)didSelectSortForTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    LTTSort sort = [self.sorts[indexPath.row] integerValue];
    if (sort == self.filterManager.sort) {
        return;
    }
    
    self.filterManager.sort = sort;
    [tableView reloadData];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didSelectFilterForTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    LTTFilterTVCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    LTTFilterType type = cell.filter.type;
    
    switch (type) {
        case LTTFilterTypeUnknown:
            break;
            
        case LTTFilterTypeBool:
            if (cell.filter.isActive) {
                [self.filterManager dropFilter:cell.filter];
            }
            else {
                [self.filterManager activateFilterBool:cell.filter];
            }
            [self.tableView reloadData];
            break;
            
        case LTTFilterTypeString:
            SAFE_RUN(self.onStringFilterSelected, cell.filter);
            break;
            
        case LTTFilterTypeNumeric:
            SAFE_RUN(self.onNumericFilterSelected, cell.filter);
            break;
            
        case LTTFilterTypeEnum:
            SAFE_RUN(self.onEnumFilterSelected, cell.filter);
            break;
    }
}

@end
